-- Replace all normal delete operations to use black hole register
vim.keymap.set('n', 'd', '"_d', { noremap = true })
vim.keymap.set('n', 'dd', '"_dd', { noremap = true })
vim.keymap.set('n', 'dw', '"_dw', { noremap = true })
vim.keymap.set('n', 'D', '"_D', { noremap = true })
vim.keymap.set('n', 'x', '"_x', { noremap = true })

-- Map underscore-prefixed versions to real delete (preserve yank)
vim.keymap.set('n', '_d', 'd', { noremap = true })
vim.keymap.set('n', '_dd', 'dd', { noremap = true })
vim.keymap.set('n', '_dw', 'dw', { noremap = true })
vim.keymap.set('n', '_D', 'D', { noremap = true })
vim.keymap.set('n', '_x', 'x', { noremap = true })

vim.keymap.set('v', 'd', '"_d', { noremap = true })
vim.keymap.set('v', '_d', 'd', { noremap = true })

-- LSP Management Keybindings
vim.keymap.set('n', '<leader>lr', function()
  -- Refresh LSP workspace
  local clients = vim.lsp.get_active_clients()
  for _, client in ipairs(clients) do
    if client.supports_method('workspace/didChangeWatchedFiles') then
      client.notify('workspace/didChangeWatchedFiles', {
        changes = {
          {
            uri = vim.uri_from_bufnr(0),
            type = 2, -- 2 = changed
          },
        },
      })
    end
  end
  vim.notify('LSP workspace refreshed', vim.log.levels.INFO)
end, { desc = '[L]SP [R]efresh workspace' })

vim.keymap.set('n', '<leader>lR', function()
  -- Restart LSP servers
  local clients = vim.lsp.get_active_clients()
  for _, client in ipairs(clients) do
    vim.lsp.stop_client(client.id)
  end
  -- Restart after a brief delay
  vim.defer_fn(function()
    vim.cmd('LspStart')
  end, 500)
  vim.notify('LSP servers restarted', vim.log.levels.INFO)
end, { desc = '[L]SP [R]estart servers' })

vim.keymap.set('n', '<leader>lc', function()
  -- Force LSP reconnection by restarting the current buffer's LSP
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    vim.lsp.stop_client(client.id)
  end
  -- Wait a bit and then restart
  vim.defer_fn(function()
    vim.cmd('LspStart')
  end, 1000)
  vim.notify('LSP reconnecting...', vim.log.levels.INFO)
end, { desc = '[L]SP [C]onnect/reconnect' })

-- Python Development Keybindings
vim.keymap.set('n', '<leader>py', ':!python3 %<CR>', { desc = '[P]ython run current file' })
vim.keymap.set('n', '<leader>pt', ':!python3 -m pytest %<CR>', { desc = '[P]ython [T]est current file' })
vim.keymap.set('n', '<leader>pv', ':!python3 -m venv .venv<CR>', { desc = '[P]ython create [V]irtual environment' })

-- Enhanced Navigation Keybindings
vim.keymap.set('n', '<leader>j', '<C-d>', { desc = 'Scroll down half page' })
vim.keymap.set('n', '<leader>k', '<C-u>', { desc = 'Scroll up half page' })
vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { desc = '[G]it [G]ui (requires lazygit)' })

-- Buffer Management
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = '[B]uffer [D]elete current' })
vim.keymap.set('n', '<leader>bn', ':bnext<CR>', { desc = '[B]uffer [N]ext' })
vim.keymap.set('n', '<leader>bp', ':bprevious<CR>', { desc = '[B]uffer [P]revious' })

-- Search and Replace in current file (VSCode-style)
vim.keymap.set('n', '<leader>sr', function()
  local search = vim.fn.input('Search: ')
  if search == '' then return end
  local replace = vim.fn.input('Replace: ')
  if replace == '' then return end
  -- Use substitute with confirm flag for interactive replacement
  vim.cmd(string.format('%%s/%s/%s/gc', vim.fn.escape(search, '/'), vim.fn.escape(replace, '/')))
end, { desc = '[S]earch and [R]eplace in file' })

-- Check LSP status
vim.keymap.set('n', '<leader>ls', ':LspStatus<CR>', { desc = '[L]SP [S]tatus' })

-- Hop motion keybindings
vim.keymap.set('', '<leader><leader>w', ':HopWord<CR>', { desc = 'Hop to word' })
vim.keymap.set('', '<leader><leader>l', ':HopLine<CR>', { desc = 'Hop to line' })
vim.keymap.set('', '<leader><leader>c', ':HopChar1<CR>', { desc = 'Hop to character' })
vim.keymap.set('', '<leader><leader>p', ':HopPattern<CR>', { desc = 'Hop to pattern' })

-- Quick file operations
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = '[W]rite file' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = '[Q]uit' })
vim.keymap.set('n', '<leader>x', ':x<CR>', { desc = 'Save and e[X]it' })