return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    icons = { group = vim.g.icons_enabled and "" or "+", separator = "" },
    disable = { filetypes = { "TelescopePrompt" } },
  },
}