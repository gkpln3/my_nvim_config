return {
  "windwp/nvim-autopairs",
  config = function()
    -- Assuming you're using nvim-autopairs
    local npairs = require "nvim-autopairs"

    npairs.setup {
      check_ts = true, -- Enable tree-sitter integration
      -- Define other options as needed
    }

    -- Custom rule to make it work like VSCode's beforewhitespace
    local Rule = require "nvim-autopairs.rule"
    npairs.add_rules {
      Rule(" ", " "):with_pair(function(opts)
        local pair = opts.line:sub(opts.col - 1, opts.col)
        return vim.tbl_contains({ "()", "[]", "{}" }, pair)
      end),
    }
  end,
  lazy = false,
}

