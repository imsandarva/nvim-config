return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    -- Minimal, reliable setup for nvim-tree
    require('nvim-tree').setup {
      -- Do not hijack netrw; keep behavior predictable
      disable_netrw = false,
      hijack_netrw = false,

      -- Keep the tree in sync with the working directory
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = { enable = true, update_root = true },

      -- Watch filesystem for changes
      filesystem_watchers = { enable = true, debounce_delay = 50 },

      -- Git indicators
      git = { enable = true, ignore = false, show_on_dirs = true, show_on_files = true, timeout = 400 },

      -- Basic view settings
      view = { adaptive_size = true, width = 30, side = 'left', number = false, relativenumber = false, signcolumn = 'yes' },

      -- Simple renderer with icons and indentation markers
      renderer = {
        highlight_git = true,
        highlight_opened_files = 'icon',
        indent_width = 2,
        indent_markers = { enable = true, inline_arrows = true },
        icons = { git_placement = 'before', modified_placement = 'after', padding = ' ', symlink_arrow = ' ➛ ' },
        special_files = { 'Cargo.toml', 'Makefile', 'README.md', 'readme.md' },
        symlink_destination = true,
      },

      -- Filters
      filters = { dotfiles = false, git_ignored = false },

      -- Trash integration
      trash = { cmd = 'gio trash', require_confirm = true },

      -- Live filter
      live_filter = { prefix = '[FILTER]: ', always_show_folders = true },

      -- Notifications and logging
      notify = { threshold = vim.log.levels.INFO, absolute_path = true },
      log = { enable = false, truncate = false },
    }

    -- If the tree is visible, reload it when files change
    vim.api.nvim_create_autocmd({ 'BufWritePost', 'FileChangedShellPost' }, {
      callback = function()
        local ok, api = pcall(require, 'nvim-tree.api')
        if ok and api.tree.is_visible() then
          api.tree.reload()
        end
      end,
    })
  end,
}
