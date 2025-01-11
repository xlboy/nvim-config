local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

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
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "zipPlugin", "tutor" },
    },
  },
  concurrency = 15
})
