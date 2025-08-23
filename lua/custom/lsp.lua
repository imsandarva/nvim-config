local lspconfig = require 'lspconfig'

-- Use blink.cmp for enhanced completion capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('blink.cmp').setup {
  keymap = {
    ['<CR>'] = require('blink.cmp').mapping.confirm { select = true },
  },
}

-- Configure LSP servers (managed by mason-lspconfig in init.lua)
local servers = { 'pyright' }

for _, server in ipairs(servers) do
  lspconfig[server].setup {
    capabilities = capabilities,
  }
end
