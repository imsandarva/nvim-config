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

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      -- Custom source for Python relative imports
      local py_import_source = {}
      py_import_source.new = function()
        return setmetatable({}, { __index = py_import_source })
      end
      function py_import_source:is_available()
        return vim.bo.filetype == 'python'
      end
      function py_import_source:get_debug_name()
        return 'py_import'
      end
      function py_import_source:complete(request, callback)
        local line = request.context.cursor_before_line
        local mod = line:match('^%s*from%s+([%._%w]*)$')
        if not mod then
          return callback()
        end

        local cwd = vim.fn.expand '%:p:h'
        local leading = mod:match('^(%.*)') or ''
        local rest = mod:sub(#leading + 1)
        local base = cwd
        if #leading > 1 then
          for _ = 2, #leading do
            base = vim.fn.fnamemodify(base, ':h')
          end
        end
        local rel = rest:gsub('^%.', ''):gsub('%.', '/')
        local target = (rel ~= '' and (base .. '/' .. rel) or base)
        if vim.fn.isdirectory(target) == 0 then
          return callback()
        end

        local names = vim.fn.readdir(target)
        local items = {}
        for _, name in ipairs(names) do
          if name:sub(1, 1) ~= '.' then
            local full = target .. '/' .. name
            if vim.fn.isdirectory(full) == 1 then
              table.insert(items, { label = name })
            elseif name:sub(-3) == '.py' and name ~= '__init__.py' then
              table.insert(items, { label = name:sub(1, -4) })
            end
          end
        end
        table.sort(items, function(a, b)
          return a.label < b.label
        end)
        callback(items)
      end
      cmp.register_source('py_import', py_import_source.new())

      cmp.setup {
        -- Fast and simple: trigger immediately, minimal work per keystroke
        completion = {
          autocomplete = { cmp.TriggerEvent.TextChanged },
          keyword_length = 0,
        },
        preselect = cmp.PreselectMode.Item,
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-Space>'] = cmp.mapping.complete(),
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
        -- Keep sources minimal and ordered for relevance
        sources = cmp.config.sources({
          { name = 'nvim_lsp', priority = 1000, keyword_length = 0 },
          { name = 'path', priority = 800, keyword_length = 0 },
          { name = 'luasnip', priority = 700 },
        }, {
          {
            name = 'buffer',
            keyword_length = 2,
            priority = 250,
            option = {
              get_bufnrs = function()
                return { vim.api.nvim_get_current_buf() }
              end,
            },
          },
        }),
        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        experimental = { ghost_text = true },
      }

      -- Python: prioritize import source and immediate path/lsp results
      cmp.setup.filetype('python', {
        sources = cmp.config.sources({
          { name = 'py_import', priority = 1200, keyword_length = 0 },
          { name = 'nvim_lsp', priority = 1000, keyword_length = 0 },
          { name = 'path', priority = 800, keyword_length = 0 },
          { name = 'luasnip', priority = 700 },
        }, {
          {
            name = 'buffer',
            keyword_length = 2,
            priority = 250,
            option = {
              get_bufnrs = function()
                return { vim.api.nvim_get_current_buf() }
              end,
            },
          },
        }),
      })
    end,
  },
}
