-- Replace all normal delete operations to use black hole register
vim.keymap.set('n', 'd', '"_d', { noremap = true })
vim.keymap.set('n', 'dd', '"_dd', { noremap = true })
vim.keymap.set('n', 'dw', '"_dw', { noremap = true })
vim.keymap.set('n', 'D', '"_D', { noremap = true })
vim.keymap.set('n', 'x', '"_x', { noremap = true })

-- Map underscore-prefixed versions to real delete (preserve yank)
vim.keymap.set('n', '_d', 'd', { noremap = true })
vim.keymap.set('n', '_dd', 'dd', { noremap = true })
vim.keymap.set('n', '_dw', 'dw', { noremap = true })
vim.keymap.set('n', '_D', 'D', { noremap = true })
vim.keymap.set('n', '_x', 'x', { noremap = true })

vim.keymap.set('v', 'd', '"_d', { noremap = true })
vim.keymap.set('v', '_d', 'd', { noremap = true })

vim.keymap.set('n', '<C-b>', function()
  vim.cmd 'Neotree toggle filesystem reveal'
end, { desc = 'Toggle NeoTree', silent = true })
