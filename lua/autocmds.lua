local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
	desc = "Highlight yanked text",
	group = augroup("highlightyank", { clear = true }),
	pattern = "*",
	callback = function() vim.highlight.on_yank() end,
})


-- autocmd("BufEnter", {
-- 	desc = "Quit AstroNvim if more than one window is open and only sidebar windows are list",
-- 	group = augroup("auto_quit", { clear = true }),
-- 	callback = function()
-- 		local wins = vim.api.nvim_tabpage_list_wins(0)
-- 		-- Both neo-tree and aerial will auto-quit if there is only a single window left
-- 		if #wins <= 1 then return end
-- 		local sidebar_fts = { aerial = true, ["neo-tree"] = true }
-- 		for _, winid in ipairs(wins) do
-- 			if vim.api.nvim_win_is_valid(winid) then
-- 				local bufnr = vim.api.nvim_win_get_buf(winid)
-- 				local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
-- 				-- If any visible windows are not sidebars, early return
-- 				if not sidebar_fts[filetype] then
-- 					return
-- 					-- If the visible window is a sidebar
-- 				else
-- 					-- only count filetypes once, so remove a found sidebar from the detection
-- 					sidebar_fts[filetype] = nil
-- 				end
-- 			end
-- 		end
-- 		if #vim.api.nvim_list_tabpages() > 1 then
-- 			vim.cmd.tabclose()
-- 		else
-- 			vim.cmd.qall()
-- 		end
-- 	end,
-- })

autocmd("BufEnter", {
	desc = "Open Neo-Tree on startup with directory",
	group = augroup("neotree_start", { clear = true }),
	callback = function()
		if package.loaded["neo-tree"] then
			vim.api.nvim_del_augroup_by_name "neotree_start"
		else
			local stats = (vim.uv or vim.loop).fs_stat(vim.api.nvim_buf_get_name(0)) -- TODO: REMOVE vim.loop WHEN DROPPING SUPPORT FOR Neovim v0.9
			if stats and stats.type == "directory" then
				vim.api.nvim_del_augroup_by_name "neotree_start"
				require "neo-tree"
			end
		end
	end,
})

autocmd("TermClose", {
	pattern = "*lazygit*",
	desc = "Refresh Neo-Tree when closing lazygit",
	group = augroup("neotree_refresh", { clear = true }),
	callback = function()
		local manager_avail, manager = pcall(require, "neo-tree.sources.manager")
		if manager_avail then
			for _, source in ipairs { "filesystem", "git_status", "document_symbols" } do
				local module = "neo-tree.sources." .. source
				if package.loaded[module] then manager.refresh(require(module).name) end
			end
		end
	end,
})

autocmd("BufDelete", {
	pattern = "*",
	callback = function()
		-- Delay the execution to ensure the buffer list is updated after deletion
		vim.defer_fn(function()
			local buffers = vim.api.nvim_list_bufs()
			local editorBuffers = 0
			local neotreeBufferPresent = false

			for _, buf in ipairs(buffers) do
				if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == '' then
					editorBuffers = editorBuffers + 1
					if vim.bo[buf].filetype == 'neo-tree' then
						neotreeBufferPresent = true
					end
				end
			end

			-- Close Aerial if NeoTree is the only editor buffer remaining
			if editorBuffers == 1 and neotreeBufferPresent and vim.fn.exists("*aerial#close") == 1 then
				vim.fn["aerial#close"]()
			end
		end, 0)
	end,
})

function QuickFixFilterPrompt()
	local filter = vim.fn.input('Enter filter: ')
	if filter ~= '' then
		vim.cmd('Cfilter ' .. filter)
	end
end

function QuickFixExcludeFilterPrompt()
	local filter = vim.fn.input('Enter exclude filter: ')
	if filter ~= '' then
		vim.cmd('Cfilter! ' .. filter)
	end
end

vim.api.nvim_create_autocmd("FileType", {
pattern = "qf",
callback = function()
	vim.api.nvim_buf_set_keymap(0, 'n', 'f', ':lua QuickFixFilterPrompt()<CR>', { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(0, 'n', 'F', ':lua QuickFixExcludeFilterPrompt()<CR>', { noremap = true, silent = true })
end
})

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    -- Get the current value of iskeyword as a string
    local current_iskeyword = vim.api.nvim_get_option "iskeyword"
    -- Append the characters and set the modified value
    vim.opt_local.iskeyword = current_iskeyword .. ",_,-,.,/"
  end,
})

