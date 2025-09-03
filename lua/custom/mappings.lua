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

-- Add LSP workspace refresh and server restart keybindings
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
  vim.notify('LSP servers restarted', vim.log.levels.INFO)
end, { desc = '[L]SP [R]estart servers' })

-- Add a keybinding to force LSP reconnection
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
