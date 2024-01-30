-- lazy.nvim
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("noice").setup {
      notify = {
        enabled = true,
      },
      lsp = {
        hover = {
          enabled = true,
        },
        signature = {
          enabled = true,
        },
        progress = {
          enabled = true,
        },
      },
      messages = {
        enabled = true,
      },
    }
  end,
}

