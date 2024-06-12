local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

local in_vscode = vim.g.vscode
local spec = {}
if in_vscode then
  require("vsc")
  spec = {
     import = "vsc.plugins" 
  }
else
  require("terminal")
  spec = {
    { import = "terminal.plugins" },
    { import = "terminal.plugins.language" },
    { import = "terminal.plugins.language.pack" },
    { import = "terminal.plugins.language.lsp" },
    { import = "terminal.plugins.ui" },
    { import = "terminal.plugins.project" },
  }
end

require("lazy").setup({
  spec = spec,
  defaults = { lazy = true },
  checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "zipPlugin", "tutor" },
    },
  },
})
