return {
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>udn",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    init = function()
      local done = false
      local banned_messages = {
        "No information available",
        "[LSP] No client with id 1",
        "position_encoding param is required in vim.lsp.util.make_position_params. Defaulting to position encoding of the first client.",
        "position_encoding param is required in vim.lsp.util.make_range_params. Defaulting to position encoding of the first client."
      }
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.notify = function(msg, ...)
        local notify = require("notify")
        if done == false then
          done = true
          notify.setup({
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
        end
        for _, banned in ipairs(banned_messages) do
          if msg == banned then return end
        end
        notify(msg, ...)
      end
    end,
  },
  {
    "folke/which-key.nvim",
    event = "User Startup30s", -- 启动 30s 后再加载
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
