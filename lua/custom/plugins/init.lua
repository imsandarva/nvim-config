-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
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

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', -- LSP completions
      'hrsh7th/cmp-buffer', -- buffer words
      'hrsh7th/cmp-path', -- filesystem paths
      'hrsh7th/cmp-cmdline', -- command line completions
      'L3MON4D3/LuaSnip', -- snippets
      'saadparwaiz1/cmp_luasnip', -- connect cmp + snippets
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
      }
    end,
  },
}
