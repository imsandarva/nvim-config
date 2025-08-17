local lspconfig = require 'lspconfig'

-- Use blink.cmp for enhanced completion capabilities
local capabilities = require('blink.cmp').get_lsp_capabilities()

-- Configure LSP servers (managed by mason-lspconfig in init.lua)
local servers = { 'pyright' }

for _, server in ipairs(servers) do
  lspconfig[server].setup {
    capabilities = capabilities,
  }
end
