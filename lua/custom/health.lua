local M = {}

-- Check LSP server health
function M.check_lsp_health()
  local clients = vim.lsp.get_active_clients()
  if #clients == 0 then
    vim.notify('No LSP servers are currently active', vim.log.levels.WARN)
    return false
  end
  
  local healthy = true
  for _, client in ipairs(clients) do
    local status = client.status
    if status == 'running' then
      vim.notify(string.format('LSP server %s is running normally', client.name), vim.log.levels.INFO)
    else
      vim.notify(string.format('LSP server %s has status: %s', client.name, status), vim.log.levels.WARN)
      healthy = false
    end
  end
  
  return healthy
end

-- Check completion provider status
function M.check_completion_health()
  -- Prefer nvim-cmp if present; otherwise check for minimal completion presence
  local ok_cmp, _ = pcall(require, 'cmp')
  if ok_cmp then
    vim.notify('nvim-cmp is available', vim.log.levels.INFO)
    return true
  end

  -- As a fallback, validate that LSP completion capability exists on any client
  for _, client in ipairs(vim.lsp.get_active_clients()) do
    if client.server_capabilities and client.server_capabilities.completionProvider then
      vim.notify('LSP completion is available via ' .. client.name, vim.log.levels.INFO)
      return true
    end
  end

  vim.notify('No completion provider detected (nvim-cmp or LSP)', vim.log.levels.WARN)
  return false
end

-- Comprehensive health check
function M.full_health_check()
  vim.notify('Starting comprehensive health check...', vim.log.levels.INFO)
  
  local lsp_ok = M.check_lsp_health()
  local completion_ok = M.check_completion_health()
  
  if lsp_ok and completion_ok then
    vim.notify('All systems are healthy!', vim.log.levels.INFO)
  else
    vim.notify('Some issues detected. Check the messages above.', vim.log.levels.WARN)
  end
  
  return lsp_ok and completion_ok
end

-- Auto-health check every 5 minutes
function M.setup_auto_health_check()
  local timer = vim.loop.new_timer()
  timer:start(0, 300000, vim.schedule_wrap(function()
    M.check_lsp_health()
  end))
end

return M
