-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Theme
vim.opt.background = 'dark'
require("tokyonight").setup({
  style = "night"
})
vim.cmd [[colorscheme tokyonight]]

  -- Key Mappings
vim.g.mapleader = '<space>'

vim.keymap.set('i', 'jj', '<esc>', {desc = 'quick exit insert mode'})
