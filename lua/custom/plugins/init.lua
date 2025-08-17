-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  require 'custom.plugins.catppuccin',
  require 'custom.plugins.telescope_config',
  { 'neovim/nvim-lspconfig' },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'L3MON4D3/LuaSnip' },
  { 'mfussenegger/nvim-dap' },
  { 'windwp/nvim-autopairs', config = true },

  { 'mg979/vim-visual-multi', branch = 'master' },
}
