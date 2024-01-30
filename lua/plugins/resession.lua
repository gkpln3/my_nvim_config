return {
  'stevearc/resession.nvim',
  opts = {},
	config = function ()
		require("resession").setup()
	end,
	lazy = false
}
