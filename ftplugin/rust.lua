vim.wo.relativenumber = true
vim.wo.number = true

vim.cmd("compiler cargo")
vim.bo.makeprg = "cargo build"
