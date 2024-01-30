local actions = require "telescope.actions"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local action_state = require "telescope.actions.state"
local scan = require "plenary.scandir"

-- Function to get the list of filetypes
local function get_filetypes()
  local filetype_paths = vim.api.nvim_get_runtime_file("ftplugin/*.vim", true)
  local filetypes = {}

  for _, path in ipairs(filetype_paths) do
    local filetype = path:match "ftplugin/(.*)%.vim$"
    if filetype then table.insert(filetypes, filetype) end
  end

  return filetypes
end

-- Function to change the filetype
local change_filetype = function()
  local filetypes = get_filetypes()

  pickers
    .new({}, {
      prompt_title = "Change Filetype",
      finder = finders.new_table {
        results = filetypes,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vim.api.nvim_buf_set_option(0, "filetype", selection[1])
        end)
        return true
      end,
    })
    :find()
end

-- Map this function to a keybinding or call it directly
vim.keymap.set("n", "<leader>ft", change_filetype)

