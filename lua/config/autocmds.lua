vim.defer_fn(function()
  vim.api.nvim_exec_autocmds("User", { pattern = "Startup30s", modeline = false })
end, 30000)
