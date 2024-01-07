local config = require("config.config")
local u = require("utils")

return {
  {
    -- 在 neo-tree 调用时加载，或是通过按键触发时加载
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    config = function()
      require("window-picker").setup({
        hint = "floating-big-letter",
        filter_rules = {
          bo = { filetype = config.ft_ignores, buftype = {} },
        },
      })
    end,
    keys = {
      {
        "<leader>wp",
        function()
          local picked_w_id = require("window-picker").pick_window()
          if not picked_w_id then return end
          vim.api.nvim_set_current_win(picked_w_id)
        end,
        desc = "Window pick",
      },
    },
  },
  {
    "mrjones2014/smart-splits.nvim",
    opts = {
      ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" },
      ignored_buftypes = { "nofile" },
    },
    keys = {
      { "<leader>wsh", "<cmd>lua require('smart-splits').swap_buf_left()<CR>", desc = "[Smart Window] Swap left" },
      { "<leader>wsl", "<cmd>lua require('smart-splits').swap_buf_right()<CR>", desc = "[Smart Window] Swap right" },
      { "<leader>wsj", "<cmd>lua require('smart-splits').swap_buf_down()<CR>", desc = "[Smart Window] Swap down" },
      { "<leader>wsk", "<cmd>lua require('smart-splits').swap_buf_up()<CR>", desc = "[Smart Window] Swap up" },
      { "<leader>wr", "<cmd>lua require('smart-splits').start_resize_mode()<CR>", desc = "[Smart Window] Resize mode" },
    },
  },
  {
    "nvim-focus/focus.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>wft",
        function()
          vim.cmd("FocusToggle")
          if vim.g.focus_disable then
            vim.notify("Focus mode off", vim.log.levels.INFO, { title = "focus.nvim" })
          else
            vim.notify("Focus mode on", vim.log.levels.INFO, { title = "focus.nvim" })
          end
        end,
        desc = "[Focus] Toggle window autosize",
      },
      { "<leader>wfe", ":FocusEqualise<CR>", desc = "[Focus] Equalise window" },
      { "<leader>wfa", ":FocusAutoresize<CR>", desc = "[Focus] Autoresize window" },
      { "<leader>wfm", ":FocusMaximise<CR>", desc = "[Focus] Maximise window" },
    },
    opts = {
      autoresize = { enable = true },
      ui = { cursorline = false, signcolumn = false },
    },
    config = function(_, opts)
      require("focus").setup(opts)

      local ignore_filetypes = config.ft_ignores
      local ignore_buftypes = { "nofile", "prompt", "popup", "help", "acwrite", "quifkfix" }
      local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })
      vim.api.nvim_create_autocmd("WinEnter", {
        group = augroup,
        callback = function(_)
          vim.w.focus_disable = vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
        end,
        desc = "Disable focus autoresize for BufType",
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        callback = function(_)
          vim.b.focus_disable = vim.tbl_contains(ignore_filetypes, vim.bo.filetype)
        end,
        desc = "Disable focus autoresize for FileType",
      })
    end,
  },
  {
    "carbon-steel/detour.nvim",
    keys = {
      { "<leader>wnf", "<cmd>lua require('detour').Detour()<CR>" },
    },
  },
}
