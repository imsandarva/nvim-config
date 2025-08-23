return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  cmd = 'Neotree',
  opts = {
    filesystem = {
      filtered_items = {
        hide_gitignored = false,
        hide_dotfiles = false,
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
    on_attach = function(bufnr)
      vim.keymap.set('n', '<C-b>', function()
        require('neo-tree.command').execute { action = 'close' }
      end, { buffer = bufnr, desc = 'Close NeoTree', noremap = true, silent = true })
    end,
  },
}
