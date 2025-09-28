local M = {}

-- Optimized Python LSP settings for maximum efficiency
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
      typeCheckingMode = 'off', -- Disable type checking for faster completions
      autoImportCompletions = true,
      includeFileSpecs = { '*.py', '*.pyi' },
      exclude = { '__pycache__', '.git', 'node_modules' },
      diagnosticSeverityOverrides = {
        reportMissingImports = 'none', -- Don't warn about missing imports during completion
        reportMissingTypeStubs = 'none',
        reportImportCycles = 'none',
        reportUnusedImport = 'none',
        reportUnusedClass = 'none',
        reportUnusedFunction = 'none',
        reportUnusedVariable = 'none',
        reportDuplicateImport = 'none',
      },
      -- Optimize for speed and completions
      useLibraryCodeForTypes = false, -- Faster but less accurate
    },
    pythonPath = vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python',
  },
}

-- Setup workspace for better import completions
M.setup_workspace = function()
  -- Auto-detect Python project root and set workspace
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    callback = function()
      local current_file = vim.api.nvim_buf_get_name(0)
      local project_root = vim.fn.fnamemodify(current_file, ':h')

      -- Look for common Python project indicators
      local indicators = { 'pyproject.toml', 'setup.py', 'requirements.txt', '.git' }
      for _, indicator in ipairs(indicators) do
        if vim.fn.filereadable(project_root .. '/' .. indicator) == 1 or
           vim.fn.isdirectory(project_root .. '/' .. indicator) == 1 then
          -- Found project root, update Pyright workspace
          if vim.lsp.buf.server_ready() then
            vim.lsp.buf.add_workspace_folder(project_root)
          end
          break
        end
      end
    end,
  })
end

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

-- Debug Python environment
M.debug_python_env = function()
  print('=== Python Environment Debug ===')
  print('Python executable:', vim.fn.exepath('python3') or vim.fn.exepath('python') or 'NOT FOUND')
  print('Current working directory:', vim.fn.getcwd())
  print('Current file:', vim.fn.expand('%:p'))
  print('File type:', vim.bo.filetype)

  -- Check if we're in a Python project
  local indicators = { 'pyproject.toml', 'setup.py', 'requirements.txt', 'Pipfile', '.git' }
  for _, indicator in ipairs(indicators) do
    if vim.fn.filereadable(indicator) == 1 or vim.fn.isdirectory(indicator) == 1 then
      print('Found project indicator:', indicator)
      break
    end
  end

  -- Check LSP status
  local clients = vim.lsp.get_clients({ name = 'pyright' })
  if #clients > 0 then
    print('Pyright status: ACTIVE')
    print('Workspace folders:', vim.inspect(clients[1].workspaceFolders))
  else
    print('Pyright status: NOT ACTIVE')
  end
end

return M
