local u = require("utils")

return {
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    config = function()
      require("window-picker").setup({ hint = "floating-big-letter" })
    end,
  },
  {
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
    opts = {
      ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" },
      ignored_buftypes = { "nofile" },
    },
    keys = {
      { "<leader>wsh", ":lua require('smart-splits').swap_buf_left()<CR>", desc = "[Smart Window] Swap left" },
      { "<leader>wsl", ":lua require('smart-splits').swap_buf_right()<CR>", desc = "[Smart Window] Swap right" },
      { "<leader>wsj", ":lua require('smart-splits').swap_buf_down()<CR>", desc = "[Smart Window] Swap down" },
      { "<leader>wsk", ":lua require('smart-splits').swap_buf_up()<CR>", desc = "[Smart Window] Swap up" },
      { "<leader>wr", ":lua require('smart-splits').start_resize_mode()<CR>", desc = "[Smart Window] Resize mode" },
    },
  },
  {
    "anuvyklack/windows.nvim",
    event = "VeryLazy",
    dependencies = { "anuvyklack/middleclass", "anuvyklack/animation.nvim" },
    opts = {
      autowidth = { enable = true },
      ignore = {
        buftype = { "quickfix" },
        filetype = { "NvimTree", "neo-tree", "NeogitStatus" },
      },
      animation = { enable = false, duration = 100, fps = u.basic.os_pick(144, 60) },
    },
    config = function(_, opts)
      vim.o.winwidth = 30
      vim.o.winminwidth = 30
      vim.o.equalalways = false
      require("windows").setup(opts)
    end,
    keys = {
      { "<leader>wsz", ":WindowsMaximize<CR>", desc = "[Window Auto Size] Maximize" },
      { "<leader>ws\\", ":WindowsMaximizeVertically<CR>", desc = "[Window Auto Size] Maximize V" },
      { "<leader>ws|", ":WindowsMaximizeVertically<CR>", desc = "[Window Auto Size] Maximize H" },
      { "<leader>wsr", ":WindowsEqualize<CR>", desc = "[Window Auto Size] Reset" },
    },
  },
}
