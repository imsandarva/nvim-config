local M = {}

-- Python-specific LSP settings
M.pyright_settings = {
  pyright = {
    disableLanguageServices = false,
    disableOrganizeImports = false,
  },
  python = {
    analysis = {
      autoSearchPaths = true,
      useLibraryCodeForTypes = true,
      diagnosticMode = 'workspace',
      typeCheckingMode = 'basic',
      autoImportCompletions = true,
      diagnosticSeverityOverrides = {
        reportMissingImports = 'warning',
        reportMissingTypeStubs = 'none',
        reportImportCycles = 'warning',
        reportUnusedImport = 'warning',
        reportUnusedClass = 'warning',
        reportUnusedFunction = 'warning',
        reportUnusedVariable = 'warning',
        reportDuplicateImport = 'warning',
      },
    },
    pythonPath = vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python',
  },
}

-- Python-specific keybindings
M.setup_keybindings = function()
  local opts = { noremap = true, silent = true }

  -- Python run current file
  vim.keymap.set('n', '<leader>py', ':!python3 %<CR>', vim.tbl_extend('force', opts, { desc = '[P]ython run current file' }))

  -- Python test current file
  vim.keymap.set('n', '<leader>pt', ':!python3 -m pytest %<CR>', vim.tbl_extend('force', opts, { desc = '[P]ython [T]est current file' }))

  -- Python create virtual environment
  vim.keymap.set('n', '<leader>pv', ':!python3 -m venv .venv<CR>', vim.tbl_extend('force', opts, { desc = '[P]ython create [V]irtual environment' }))

  -- Python format with black
  vim.keymap.set('n', '<leader>pb', ':!black %<CR>', vim.tbl_extend('force', opts, { desc = '[P]ython format with [B]lack' }))

  -- Python sort imports
  vim.keymap.set('n', '<leader>pi', ':!isort %<CR>', vim.tbl_extend('force', opts, { desc = '[P]ython sort [I]mports' }))
end

-- Setup Python-specific autocommands
M.setup_autocommands = function()
  local python_group = vim.api.nvim_create_augroup('python_group', { clear = true })

  -- Auto-format Python files on save - DISABLED
  -- Manual formatting available with <leader>pb
  -- vim.api.nvim_create_autocmd('BufWritePost', {
  --   pattern = '*.py',
  --   group = python_group,
  --   callback = function()
  --     -- Only format if black is available
  --     if vim.fn.executable('black') == 1 then
  --       vim.cmd('silent !black ' .. vim.fn.expand('%'))
  --     end
  --   end,
  -- })

  -- Set Python-specific options
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    group = python_group,
    callback = function()
      -- Use 4 spaces for Python
      vim.bo.tabstop = 4
      vim.bo.softtabstop = 4
      vim.bo.shiftwidth = 4
      vim.bo.expandtab = true
    end,
  })
end

-- Setup Python debugging
M.setup_debugging = function()
  local dap = require('dap')
  local dap_python = require('dap-python')

  -- Setup debugpy
  dap_python.setup(vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python')

  -- Python-specific debug configurations
  dap.configurations.python = {
    {
      type = 'python',
      request = 'launch',
      name = 'Launch file',
      program = '${file}',
      pythonPath = function()
        return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
      end,
    },
    {
      type = 'python',
      request = 'launch',
      name = 'Launch file with arguments',
      program = '${file}',
      args = function()
        local args_string = vim.fn.input('Arguments: ')
        return vim.split(args_string, ' ')
      end,
      pythonPath = function()
        return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
      end,
    },
  }
end

-- Disable any automatic formatting from LSP servers
M.disable_lsp_formatting = function()
  -- Disable document formatting for all LSP clients
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        -- Disable document formatting capabilities
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end
    end,
  })
end

return M
