local config = require("terminal.config.config")

return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    -- enabled = true,
    -- ft = u.basic.os_pick({ "lua", "cpp", "typescriptreact", "typescript" }, { "lua", "cpp" }),
    config = function()
      require("copilot").setup({
        filetypes = {
          lua = true,
          cpp = true,
          typescript = config.IS_WIN,
          typescriptreact = config.IS_WIN,
          ["*"] = false,
        },
        panel = { enabled = true },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<C-a>",
            accept_word = false,
            accept_line = false,
            next = "<C-n>",
            prev = "<C-p>",
            dismiss = "<C-]>",
          },
        },
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    cmd = "CopilotChat",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
