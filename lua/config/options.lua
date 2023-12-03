vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.laststatus = 0 -- 状态行的显示
opt.ruler = false -- 是否显示光标所在行的行号
opt.cmdheight = 0 -- 底部的命令行高度

opt.number = false -- 显示行号
opt.signcolumn = "yes"
opt.mousescroll = "ver:4,hor:2" -- 鼠标滚轮滚动行数

opt.pumheight = 20 -- 弹出菜单的高度
opt.pumblend = 8 -- 弹出菜单的透明度