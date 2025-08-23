-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-tree/nvim-web-devicons', --  For file  and folder icons
  },
  cmd = 'Neotree',
  opts = {
    filesystem = {
      filtered_items = {
        hide_gitignored = false, -- show .gitignored files
        hide_dotfiles = false, -- optional: show dotfiles
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
