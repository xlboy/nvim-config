require("config.init")
require("scripts.init")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.language" },
    { import = "plugins.ui" },
    { import = "plugins.project" },
  },
  defaults = { lazy = true },
  checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "zipPlugin", "tutor" },
    },
  },
})
