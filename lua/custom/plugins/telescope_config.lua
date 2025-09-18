-- telescope_config.lua
return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local telescope = require 'telescope'
    local actions = require 'telescope.actions'

    telescope.setup {
      defaults = {
        mappings = {
          i = { ['<esc>'] = actions.close },
        },
      },
      pickers = {
        find_files = {
          no_ignore = true, -- Always include .gitignore'd files
          hidden = true, -- Include hidden files
          cache_picker = false, --  disables result caching
        },
      },
    }

    -- Keymap for refreshing files manually (optional)
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles (fd)' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  end,
}
