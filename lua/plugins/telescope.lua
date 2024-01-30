return {
	{
  	"nvim-telescope/telescope.nvim",
		config = function()
			require("telescope").setup {
				defaults = {
					layout_config = {
      			horizontal = {
        			prompt_position = "top",
      			},
    			},
					sorting_strategy = "ascending",
				},
			}
		end,
	},
	{
		{
    "fdschmidt93/telescope-egrepify.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
		}
	}
}
