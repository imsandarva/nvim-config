local M = {}

-- Check LSP server health with detailed diagnostics
function M.check_lsp_health()
  local clients = vim.lsp.get_active_clients()
  if #clients == 0 then
    vim.notify('❌ No LSP servers are currently active', vim.log.levels.WARN)
    vim.notify('💡 Try: :LspRestart or open a supported file type', vim.log.levels.INFO)
    return false
  end

  local healthy = true
  vim.notify('🔍 Checking LSP server health...', vim.log.levels.INFO)

  for _, client in ipairs(clients) do
    local status = client.status or 'unknown'
    local status_icon = '❓'

    if status == 'running' or status == 'initialized' then
      status_icon = '✅'
      vim.notify(string.format('%s LSP server %s is healthy', status_icon, client.name), vim.log.levels.INFO)
    elseif status == 'starting' then
      status_icon = '⏳'
      vim.notify(string.format('%s LSP server %s is starting...', status_icon, client.name), vim.log.levels.INFO)
    else
      status_icon = '❌'
      vim.notify(string.format('%s LSP server %s has issues (status: %s)', status_icon, client.name, status), vim.log.levels.WARN)
      healthy = false
    end

    -- Check if server has required capabilities
    if client.server_capabilities then
      local caps = client.server_capabilities
      if not caps.completionProvider and not caps.hoverProvider then
        vim.notify(string.format('⚠️  %s may be missing important capabilities', client.name), vim.log.levels.WARN)
      end
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

-- Auto-health check every 5 minutes with startup verification
function M.setup_auto_health_check()
  -- Initial health check after startup
  vim.defer_fn(function()
    M.check_lsp_health()
  end, 2000) -- Wait 2 seconds after startup

  -- Periodic health checks
  local timer = vim.loop.new_timer()
  timer:start(0, 300000, vim.schedule_wrap(function()
    M.check_lsp_health()
  end))
end

-- Quick LSP server verification
function M.verify_lsp_servers()
  vim.notify('🔍 Verifying LSP server installation...', vim.log.levels.INFO)

  -- Check if required tools are installed
  local required_tools = {
    'lua-language-server',
    'pyright-langserver'
  }

  for _, tool in ipairs(required_tools) do
    if vim.fn.executable(tool) == 0 then
      vim.notify(string.format('⚠️  %s not found in PATH', tool), vim.log.levels.WARN)
      vim.notify('💡 Install with: :MasonInstall ' .. tool, vim.log.levels.INFO)
    else
      vim.notify(string.format('✅ %s is available', tool), vim.log.levels.INFO)
    end
  end

  -- Check Mason installation status
  local mason_ok, mason_registry = pcall(require, 'mason-registry')
  if mason_ok then
    local installed_packages = mason_registry.get_installed_packages()
    vim.notify(string.format('📦 Mason has %d packages installed', #installed_packages), vim.log.levels.INFO)
  end
end

return M
