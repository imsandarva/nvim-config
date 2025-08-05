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
          i = {
            ['<esc>'] = actions.close,
          },
        },
      },
    }

    -- Auto refresh file list after writing or changing directory
    vim.api.nvim_create_autocmd({ 'BufWritePost', 'DirChanged' }, {
      callback = function()
        require('telescope.builtin').find_files { hidden = true, no_ignore = true }
      end,
    })
  end,
}
