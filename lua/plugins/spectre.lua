return {
	"nvim-pack/nvim-spectre",
	config = function ()
		require('spectre').setup({is_block_ui_break = true})
	end,
	cmd = "Spectre"
}
