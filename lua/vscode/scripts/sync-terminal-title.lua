local function kitty()
  vim.fn.system(string.format("kitty @ set-tab-title %q", vim.fs.basename(vim.fn.getcwd())))
  vim.api.nvim_create_autocmd({ "DirChanged" }, {
    pattern = "*",
    callback = function()
      vim.fn.system(string.format("kitty @ set-tab-title %q", vim.fs.basename(vim.fn.getcwd())))
    end,
  })
end

local function wezterm()
  local function sync()
    vim.fn.system(string.format("wezterm cli set-tab-title %q", vim.fs.basename(vim.fn.getcwd())))
  end

  sync()
  vim.api.nvim_create_autocmd({ "DirChanged" }, { pattern = "*", callback = sync })
end

wezterm()
