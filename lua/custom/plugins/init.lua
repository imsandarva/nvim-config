return {
  require 'custom.plugins.web-devicons',
  require 'custom.plugins.catppuccin',
  require 'custom.plugins.nvim-tree',
  require 'custom.plugins.telescope_config',

  { 'neovim/nvim-lspconfig' },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'L3MON4D3/LuaSnip' },
  { 'mfussenegger/nvim-dap' },
  { 'windwp/nvim-autopairs', config = true },
  { 'mg979/vim-visual-multi', branch = 'master' },
}
