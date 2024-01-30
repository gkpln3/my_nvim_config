return {
  "stevearc/aerial.nvim",
  opts = {},
  -- Optional dependencies
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("aerial").setup {
      -- Your configuration settings
      open_automatic = false, -- This setting will make Aerial open automatically
      layout = {
        default_direction = "right",
        -- Determines where the aerial window will be opened
        --   edge   - open aerial at the far right/left of the editor
        --   window - open aerial to the right/left of the current window
        placement = "edge",
        preserve_equality = true,
      },
      attach_mode = "global",
    }
  end,
}
