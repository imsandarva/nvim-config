-- Clean, working Neovim configuration
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Basic settings
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
  vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.termguicolors = true
vim.g.have_nerd_font = true

-- Custom ignore system for telescope and nvim-tree
-- Only ignores: binary files + .nvimignore patterns (NOT .gitignore)
local function get_ignore_patterns()
  local ignore_patterns = {}

  -- Always ignore binary files
  local binary_extensions = {
    'exe', 'dll', 'so', 'dylib', 'app', 'deb', 'rpm', 'zip', 'tar', 'gz', 'bz2', 'xz',
    '7z', 'rar', 'jar', 'war', 'ear', 'class', 'pyc', 'pyo', 'pyd', 'so', 'o', 'a',
    'lib', 'dylib', 'framework', 'nib', 'bundle', 'app', 'dmg', 'iso', 'img', 'bin',
    'dat', 'db', 'sqlite', 'sqlite3', 'mdb', 'accdb', 'pdb', 'ilk', 'exp', 'lib',
    'a', 'la', 'lo', 'obj', 'suo', 'user', 'aps', 'pch', 'vspscc', 'vssscc',
    'buildinfo', 'ncb', 'suo', 'tlb', 'tlh', 'tmp', 'temp', 'log', 'vsmdi',
    'docproj', 'user', 'aps', 'pch', 'vspscc', 'vssscc', 'ncb', 'suo', 'tlb',
    'tlh', 'tmp', 'temp', 'cache', 'obj', 'ilk', 'exp', 'lib', 'a', 'la', 'lo',
    'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'odt', 'ods', 'odp',
    'jpg', 'jpeg', 'png', 'gif', 'bmp', 'tiff', 'ico', 'svg', 'webp', 'mp4',
    'avi', 'mkv', 'mov', 'wmv', 'flv', 'webm', 'mp3', 'wav', 'flac', 'ogg'
  }

  for _, ext in ipairs(binary_extensions) do
    table.insert(ignore_patterns, '*.' .. ext)
  end

  -- Check for .nvimignore file in current or root directory
  local current_dir = vim.fn.getcwd()
  local root_patterns = { '.git', 'pyproject.toml', 'setup.py', 'requirements.txt', 'package.json' }

  local project_root = current_dir
  for _, pattern in ipairs(root_patterns) do
    local check_path = current_dir .. '/' .. pattern
    if vim.fn.isdirectory(check_path) == 1 or vim.fn.filereadable(check_path) == 1 then
      project_root = current_dir
      break
    end
  end

  local nvimignore_path = project_root .. '/.nvimignore'
  if vim.fn.filereadable(nvimignore_path) == 1 then
    local lines = vim.fn.readfile(nvimignore_path)
    for _, line in ipairs(lines) do
      line = vim.trim(line)
      if line ~= '' and not vim.startswith(line, '#') then
        if vim.startswith(line, '/') then
          -- Absolute path from project root
          table.insert(ignore_patterns, project_root .. line)
        else
          -- Pattern relative to project root
          table.insert(ignore_patterns, project_root .. '/' .. line)
        end
      end
    end
  end

  return ignore_patterns
end

-- Make function available globally for testing
_G.get_ignore_patterns = get_ignore_patterns

-- Basic keymaps
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-p>', ':Telescope find_files<CR>')
vim.keymap.set('n', '<C-s>', ':w<CR>')
vim.keymap.set('n', '<Space>n', ':bnext<CR>')
vim.keymap.set('n', '<Space>b', ':bprevious<CR>')
vim.keymap.set('n', '<C-b>', ':NvimTreeToggle<CR>')
vim.keymap.set('n', '<leader>ls', ':LspStatus<CR>')
vim.keymap.set('n', '<leader>la', ':LspStart<CR>')

-- Plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require('lazy').setup({
  -- Core functionality
  'tpope/vim-sleuth',
      'nvim-lua/plenary.nvim',

  -- File explorer
  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup({
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = {
          dotfiles = true,
          custom = get_ignore_patterns(),
          git_ignored = false, -- Don't filter git ignored files
        },
        git = {
          ignore = false, -- Don't use .gitignore
        },
      })
    end,
  },

  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-telescope/telescope-ui-select.nvim' },
    config = function()
      require('telescope').setup({
        extensions = {
          ['ui-select'] = { require('telescope.themes').get_dropdown() },
        },
      })
      require('telescope').load_extension('ui-select')

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sf', function()
        builtin.find_files({
          file_ignore_patterns = get_ignore_patterns(),
          no_ignore = true, -- Don't respect .gitignore
          hidden = true, -- Include hidden files
        })
      end, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    end,
  },

  -- LSP and completion
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      -- Setup Mason
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = { 'lua_ls', 'pyright' },
        automatic_installation = true,
      })

      -- LSP keymaps
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
          map('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
          map('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
        end,
      })

      -- Setup completion
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp', priority = 1000 },
          { name = 'luasnip', priority = 750 },
          { name = 'buffer', priority = 500 },
          { name = 'path', priority = 250 },
        }),
        experimental = {
          ghost_text = true,
        },
      })

      -- Setup LSP servers using new Neovim 0.11 API
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      vim.lsp.config('pyright', {
        cmd = { vim.fn.expand('~/.local/share/nvim/mason/bin/pyright-langserver'), '--stdio' },
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = 'workspace',
            },
          },
        },
      })

      vim.lsp.config('lua_ls', {
        cmd = { vim.fn.expand('~/.local/share/nvim/mason/bin/lua-language-server') },
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = { library = vim.api.nvim_get_runtime_file('', true) },
            diagnostics = { globals = { 'vim' } },
            telemetry = { enable = false },
          },
        },
      })

      -- LSP commands
      vim.api.nvim_create_user_command('LspStart', function()
        local bufnr = vim.api.nvim_get_current_buf()
        local filetype = vim.bo[bufnr].filetype
        if filetype == 'python' then
          require('lspconfig').pyright.setup({
            cmd = { vim.fn.expand('~/.local/share/nvim/mason/bin/pyright-langserver'), '--stdio' },
          })
        elseif filetype == 'lua' then
          require('lspconfig').lua_ls.setup({
            cmd = { vim.fn.expand('~/.local/share/nvim/mason/bin/lua-language-server') },
                  })
                end
      end, {})

      vim.api.nvim_create_user_command('LspStatus', function()
        local clients = vim.lsp.get_clients()
        if #clients == 0 then
          print('❌ No LSP servers are currently active')
        else
          print('✅ Active LSP servers:')
          for _, client in ipairs(clients) do
            print(string.format('- %s (id: %d)', client.name, client.id))
          end
        end
      end, {})

      -- Auto-start LSP
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'python', 'lua' },
        callback = function()
          vim.cmd('LspStart')
        end,
      })
    end,
  },

  -- Formatting
  {
    'stevearc/conform.nvim',
    config = function()
      require('conform').setup({
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        },
      })
      vim.keymap.set('n', '<leader>f', function()
        require('conform').format({ async = true })
      end, { desc = '[F]ormat buffer' })
    end,
  },

  -- Colorscheme
  {
    'folke/tokyonight.nvim',
    config = function()
      vim.cmd.colorscheme('tokyonight-night')
    end,
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { 'lua', 'python', 'vim', 'vimdoc' },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
})
