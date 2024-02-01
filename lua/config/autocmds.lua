local config = require("config.config")

vim.defer_fn(function()
  vim.api.nvim_exec_autocmds("User", { pattern = "Startup30s", modeline = false })
end, 30000)

vim.defer_fn(function()
  vim.api.nvim_exec_autocmds("User", { pattern = "Startup60s", modeline = false })
end, 60000);

-- 在首次进入 InsertEnter 时，且对应的 Buf 的 FileType 不为 ... 时，执行 User BufInsertEnter
(function()
  local id
  id = vim.api.nvim_create_autocmd({ "InsertEnter" }, {
    callback = function()
      local ft = vim.bo.filetype
      if vim.tbl_contains(config.ft_ignores, ft) then return end
      vim.api.nvim_exec_autocmds("User", { pattern = "BufInsertEnter", modeline = false })
      vim.api.nvim_del_autocmd(id)
    end,
  })
end)();

-- 在首次进入 Buf 时，且 Buf 的 FileType 不为 ... 时，执行 User BufRead
(function()
  local id
  id = vim.api.nvim_create_autocmd({ "BufRead" }, {
    callback = function()
      local ft = vim.bo.filetype
      if vim.tbl_contains(config.ft_ignores, ft) then return end
      vim.api.nvim_exec_autocmds("User", { pattern = "BufRead", modeline = false })
      vim.api.nvim_del_autocmd(id)
    end,
  })
end)()
