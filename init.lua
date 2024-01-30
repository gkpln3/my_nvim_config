require("options")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {}
vim.list_extend(plugins, { { import = "plugins" } })
require("lazy").setup(plugins, nil)
require("keymaps")
require("filetype")
require("autocmds")

local function copy(lines, _) require("osc52").copy(table.concat(lines, "\n")) end
local function paste() return { vim.fn.split(vim.fn.getreg "", "\n"), vim.fn.getregtype "" } end
vim.g.clipboard = {
  name = "osc52",
  copy = { ["+"] = copy, ["*"] = copy },
  paste = { ["+"] = paste, ["*"] = paste },
}

vim.cmd "colorscheme flexoki-dark"
vim.cmd "packadd cfilter"
