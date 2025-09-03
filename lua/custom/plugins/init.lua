-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- Load web devicons first (required for file icons)
  { 'nvim-tree/nvim-web-devicons', lazy = false, priority = 1000 },
  
  require 'custom.plugins.catppuccin',
  require 'custom.plugins.telescope_config',
  require 'custom.plugins.nvim-tree',
  { 'neovim/nvim-lspconfig' },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'L3MON4D3/LuaSnip' },
  { 'mfussenegger/nvim-dap' },
  { 'windwp/nvim-autopairs', config = true },
  { 'mg979/vim-visual-multi', branch = 'master' },
}
