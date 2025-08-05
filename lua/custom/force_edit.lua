vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    vim.opt_local.readonly = false
    vim.opt_local.modifiable = true
  end,
})
