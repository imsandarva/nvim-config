return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false, -- Load immediately for quick access
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- For icons (already in your setup, but explicit is safe)
  },
  config = function()
    -- Basic setup (customize as needed; see :help nvim-tree for more options)
    require('nvim-tree').setup {
      disable_netrw = true, -- Disable Vim's built-in netrw
      hijack_netrw = true, -- Let nvim-tree handle directories
      view = {
        width = 30, -- Sidebar width
        side = 'left', -- Position
      },
      filters = {
        dotfiles = false, -- Show dotfiles (like .git)
        git_ignored = false, -- Show git-ignored files
      },
      actions = {
        open_file = {
          quit_on_open = false, -- Keep sidebar open after opening a file
        },
      },
    }
  end,
}
