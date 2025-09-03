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
  local has_cmp = pcall(require, 'blink.cmp')
  if not has_cmp then
    vim.notify('blink.cmp is not available', vim.log.levels.ERROR)
    return false
  end
  
  -- Check if completion is working
  local ok, cmp = pcall(require, 'blink.cmp')
  if ok then
    vim.notify('blink.cmp is loaded and should be working', vim.log.levels.INFO)
    return true
  else
    vim.notify('Failed to load blink.cmp', vim.log.levels.ERROR)
    return false
  end
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
