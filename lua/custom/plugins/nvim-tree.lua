return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup {
      -- Disable auto_open when doing nvim .
      disable_netrw = false,
      hijack_netrw = false,
      -- Prevent auto opening when running nvim .
      open_on_setup = false,
      open_on_setup_file = false,
      -- For newer versions of nvim-tree, use these:
      auto_open = false,
      -- Required for newer version of nvim-tree
      -- This is the key config to disable auto opening
      hijack_directories = {
        enable = false,
      },
    }

    -- Your keybinding for toggling the tree with Ctrl+B
    vim.api.nvim_set_keymap('n', '<C-b>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
  end,
}
