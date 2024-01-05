vim.defer_fn(function()
  vim.api.nvim_exec_autocmds("User", { pattern = "Startup30s", modeline = false })
end, 30000)

vim.defer_fn(function()
  vim.api.nvim_exec_autocmds("User", { pattern = "Startup60s", modeline = false })
end, 60000)

