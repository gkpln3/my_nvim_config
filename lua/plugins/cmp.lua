return {
	{
		"L3MON4D3/LuaSnip",
		lazy = true,
		build = vim.fn.has "win32" == 0
				and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
				or nil,
		dependencies = { "rafamadriz/friendly-snippets" },
		opts = {
			history = true,
			delete_check_events = "TextChanged",
			region_check_events = "CursorMoved",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-cmdline"
		},
		event = {"InsertEnter", "CmdlineEnter"},
		opts = function()
			local cmp = require "cmp"
			-- -- `:` cmdline setup.
			-- cmp.setup.cmdline(':', {
			-- 	mapping = cmp.mapping.preset.cmdline(),
			-- 	sources = cmp.config.sources({
			-- 		{ name = 'path' }
			-- 	}, {
			-- 		{
			-- 			name = 'cmdline',
			-- 			option = {
			-- 				ignore_cmds = { 'Man', '!' }
			-- 			}
			-- 		}
			-- 	})
			-- })
			-- -- `/` cmdline setup.
   --  	cmp.setup.cmdline('/', {
   --    	mapping = cmp.mapping.preset.cmdline(),
   --    	sources = {
   --      	{ name = 'buffer' }
   --    	}
   --  	})
			local snip_status_ok, luasnip = pcall(require, "luasnip")
			return {
				snippet = {
					expand = function(args) luasnip.lsp_expand(args.body) end,
				},
				confirm_opts = {
					behavior = cmp.ConfirmBehavior.Insert,
					select = true,
				},
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				mapping = {
					["<Up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
					["<Down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
					["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
					["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
					["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
					["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
					["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
					["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
					["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
					["<C-y>"] = cmp.config.disable,
					["<C-e>"] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },
					["<CR>"] = cmp.mapping.confirm { select = true },
				},
				sources = cmp.config.sources {
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "buffer",   priority = 500 },
					{ name = "path",     priority = 250 },
				},
			}
		end,
	}
}
