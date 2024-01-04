return {
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    keys = {
      {
        "<leader>udn",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    config = function()
      require("notify").setup({
        -- background_colour = "#000000",
        timeout = 3000,
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.75)
        end,
        on_open = function(win)
          vim.api.nvim_win_set_config(win, { zindex = 100 })
        end,
      })
      local banned_messages = { "No information available" }
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.notify = function(msg, ...)
        for _, banned in ipairs(banned_messages) do
          if msg == banned then return end
        end
        require("notify")(msg, ...)
      end
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 200
    end,
    opts = {},
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        get_config = function(opts)
          return {
            backend = "nui",
            nui = {
              position = "center",
            },
          }
        end,
      },
    },
  },
}
