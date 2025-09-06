return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup {
      -- Basic settings
      disable_netrw = false,
      hijack_netrw = false,
      
      -- Enhanced LSP integration
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = { enable = true, update_root = true },
      
      -- File watching for better LSP integration
      filesystem_watchers = {
        enable = true,
        debounce_delay = 50,
        ignore_dirs = {},
      },
      
      -- Git integration
      git = { enable = true, ignore = false, show_on_dirs = true, show_on_files = true, timeout = 400 },
      
      -- View settings
      view = { adaptive_size = true, width = 30, side = 'left', number = false, relativenumber = false, signcolumn = 'yes' },
      
      -- Renderer settings with icons
      renderer = {
        highlight_git = true,
        highlight_opened_files = 'icon',
        highlight_modified = 'name',
        root_folder_label = ':~:s?$?/..?',
        indent_width = 2,
        indent_markers = { enable = true, inline_arrows = true },
        icons = { git_placement = 'before', modified_placement = 'after', padding = ' ', symlink_arrow = ' ➛ ' },
        special_files = { 'Cargo.toml', 'Makefile', 'README.md', 'readme.md' },
        symlink_destination = true,
      },
      
      -- Filter settings
      filters = { dotfiles = false, git_ignored = true },
      
      -- Trash settings
      trash = { cmd = 'gio trash', require_confirm = true },
      
      -- Live filter settings
      live_filter = { prefix = '[FILTER]: ', always_show_folders = true },
      
      -- Tab settings
      tab = { sync = { open = false, close = false, ignore = {} } },
      
      -- Notify settings
      notify = { threshold = vim.log.levels.INFO, absolute_path = true },
      
      -- Log settings
      log = {
        enable = false,
        truncate = false,
        types = {
          all = false,
          config = false,
          copy_paste = false,
          dev = false,
          diagnostics = false,
          git = false,
          profile = false,
          watcher = false,
        },
>>>>>>> d95d97339cb2d0f471a17e6899c0b88e625936a5
      },
      
      -- File watching for better LSP integration
      filesystem_watchers = {
        enable = true,
        debounce_delay = 50,
        ignore_dirs = {},
      },
      
      -- Git integration
      git = {
        enable = true,
        ignore = false,
        show_on_dirs = true,
        show_on_files = true,
        timeout = 400,
      },
      
      -- View settings
      view = {
        adaptive_size = true,
        centralize_selection = false,
        width = 30,
        hide_root_folder = false,
        side = 'left',
        preserve_window_proportions = false,
        number = false,
        relativenumber = false,
        signcolumn = 'yes',
        mappings = {
          custom_only = false,
          list = {},
        },
      },
      
      -- Renderer settings with icons
      renderer = {
        add_trailing = false,
        group_empty = false,
        highlight_git = true,
        full_name = false,
        highlight_opened_files = 'icon',
        highlight_modified = 'name',
        root_folder_label = ':~:s?$?/..?',
        indent_width = 2,
        indent_markers = {
          enable = true,
          inline_arrows = true,
          icons = {
            corner = '└',
            edge = '│',
            item = '├',
            bottom = '─',
            none = ' ',
          },
        },
        icons = {
          web_devicons = {
            file = {
              enable = true,
              color = true,
            },
            folder = {
              enable = true,
              color = true,
            },
          },
          git_placement = 'before',
          modified_placement = 'after',
          padding = ' ',
          symlink_arrow = ' ➛ ',
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
            modified = true,
          },
          glyphs = {
            default = '󰈚',
            symlink = '󰉒',
            bookmark = '󰃀',
            modified = '●',
            folder = {
              arrow_closed = '󰉋',
              arrow_open = '󰉋',
              default = '󰉋',
              open = '󰉋',
              empty = '󰉋',
              empty_open = '󰉋',
              symlink = '󰉋',
              symlink_open = '󰉋',
            },
            git = {
              unstaged = '✗',
              staged = '✓',
              unmerged = '󰘬',
              renamed = '➜',
              untracked = '★',
              deleted = '󰩺',
              ignored = '◌',
            },
          },
        },
        special_files = { 'Cargo.toml', 'Makefile', 'README.md', 'readme.md' },
        symlink_destination = true,
      },
      
      -- Filter settings
      filters = {
        dotfiles = false,
        git_ignored = true,
        git_clean = false,
        no_buffer = false,
        custom = {},
        exclude = {},
      },
      
      -- Trash settings
      trash = {
        cmd = 'gio trash',
        require_confirm = true,
      },
      
      -- Live filter settings
      live_filter = {
        prefix = '[FILTER]: ',
        always_show_folders = true,
      },
      
      -- Tab settings
      tab = {
        sync = {
          open = false,
          close = false,
          ignore = {},
        },
      },
      
      -- Notify settings
      notify = {
        threshold = vim.log.levels.INFO,
        absolute_path = true,
      },
      
      -- Log settings
      log = { enable = false, truncate = false },
    }

    -- Your keybinding for toggling the tree with Ctrl+B
    vim.api.nvim_set_keymap('n', '<C-b>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
    
    -- Refresh nvim-tree when files change, if visible
    vim.api.nvim_create_autocmd({ 'BufWritePost', 'FileChangedShellPost' }, {
      callback = function()
        local ok, tree_api = pcall(require, 'nvim-tree.api')
        if ok and tree_api.tree.is_visible() then
          tree_api.tree.reload()
        end
      end,
    })
  end,
}
