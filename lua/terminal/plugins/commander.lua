local u = require("terminal.utils")
local CAT = {
  FS = "fs",
  EDIT = "edit",
  BUF = "buf",
  WINDOW = "window",
  LSP = "lsp",
  GIT = "git",
}

local commands = {
  {
    desc = "Copy current file name",
    cmd = function()
      local file_path = vim.api.nvim_buf_get_name(0)
      local file_name = vim.fn.fnamemodify(file_path, ":t")
      u.basic.write_to_clipboard(file_name)
    end,
    cat = CAT.FS,
  },
  {
    desc = "Copy current cwd",
    cmd = function()
      u.basic.write_to_clipboard(vim.fn.getcwd())
    end,
    cat = CAT.FS,
  },
  {
    desc = "Copy current file path (absolute)",
    cmd = function()
      local file_path = vim.api.nvim_buf_get_name(0)
      u.basic.write_to_clipboard(file_path)
    end,
    cat = CAT.FS,
  },
  {
    desc = "Copy current file path & line (relative to cwd)",
    cmd = function()
      local file_path = vim.api.nvim_buf_get_name(0)
      local relative_path = vim.fn.fnamemodify(file_path, ":~:." .. vim.fn.getcwd() .. ":.")
      local current_line = vim.api.nvim_win_get_cursor(0)[1]
      local file_path_and_line = relative_path .. ":" .. current_line
      u.basic.write_to_clipboard(file_path_and_line)
    end,
    cat = CAT.FS,
  },
  {
    desc = "Open the current file in finder",
    cmd = function()
      local file_path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
      u.fs.open_dir_in_finder(file_path)
    end,
    cat = CAT.FS,
  },
  {
    desc = "Open the specified file (relative to cwd)",
    cmd = function()
      require("terminal.scripts.open-file").open_file()
    end,
    cat = CAT.FS,
  },
  { desc = "Restart lsp server", cmd = "<cmd>LspRestart<CR>", cat = CAT.LSP },
  {
    desc = "Swap ternary",
    cmd = '<cmd>lua require("swap-ternary").swap()<CR>',
    cat = CAT.LSP,
  },
  {
    desc = "TS Refresh Highlight",
    cmd = function()
      vim.cmd("TSDisable highlight")
      vim.cmd("TSEnable highlight")
    end,
    cat = CAT.LSP,
  },
  {
    desc = "TS Organize Imports",
    cmd = function()
      local params =
        { command = "_typescript.organizeImports", arguments = { vim.api.nvim_buf_get_name(0) }, title = "" }
      vim.lsp.buf.execute_command(params)
    end,
    cat = CAT.LSP,
  },
  { desc = "Reload Buffer", cmd = "<cmd>bufdo e<CR>zz", cat = CAT.BUF },
  { desc = "Reload Window", cmd = "<cmd>windo e<CR>zz", cat = CAT.WINDOW },
  { desc = "Advanced Git Search", cmd = "<cmd>AdvancedGitSearch<CR>", cat = CAT.GIT },
  {
    desc = "Open Message Float Window",
    cmd = function()
      local messages = vim.split(vim.api.nvim_exec("message", true), "\n")
      u.win.create_float({
        win = { config = { relative = "editor" } },
        contents = messages,
      })
    end,
    cat = CAT.WINDOW,
  },
  {
    -- 将当前 cwd 切换到当前文件所在目录
    desc = "Change cwd to current file directory",
    cmd = function()
      local file_path = vim.api.nvim_buf_get_name(0)
      local file_dir = vim.fn.fnamemodify(file_path, ":h")
      vim.cmd("cd " .. file_dir)
    end,
  },
}

return {
  {
    "FeiyouG/commander.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "prochri/telescope-all-recent.nvim" },
    keys = { { "<leader>pp", "<cmd>Telescope commander<CR>", mode = { "n", "v" } } },
    config = function()
      require("commander").setup({
        components = { "CAT", "DESC" },
        integration = {
          telescope = { enable = true },
          lazy = { enable = false },
        },
      })

      require("commander").add(commands, {})
    end,
  },
}
