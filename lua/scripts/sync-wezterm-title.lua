local function sync()
  vim.fn.system(string.format("wezterm cli set-tab-title %q", vim.fs.basename(vim.fn.getcwd())))
end

sync()
vim.api.nvim_create_autocmd({ "DirChanged" }, { pattern = "*", callback = sync })
