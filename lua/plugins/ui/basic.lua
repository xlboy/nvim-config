local utils = require("utils")

return {
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>udn",
        function() require("notify").dismiss({ silent = true, pending = true }) end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
      on_open = function(win) vim.api.nvim_win_set_config(win, { zindex = 100 }) end,
    },
    init = function()
      utils.on_very_lazy(function() vim.notify = require("notify") end)
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },
  { "itchyny/vim-cursorword", event = "VeryLazy" },
  -- {
  --   "shellRaining/hlchunk.nvim",
  --   enabled = false,
  --   event = "UIEnter",
  --   init = function()
  --     vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, { pattern = "*", command = "EnableHL" })
  --
  --     require("hlchunk").setup({
  --       chunk = {
  --         enable = true,
  --         use_treesitter = true,
  --         style = { { fg = "#73daca" } },
  --       },
  --       indent = {
  --         enable = false,
  --         chars = { "·" },
  --         use_treesitter = false,
  --         style = { {} },
  --       },
  --       blank = { enable = false },
  --       line_num = { enable = true, use_treesitter = true },
  --     })
  --   end,
  -- },
  {
    "utilyre/sentiment.nvim",
    event = "VeryLazy",
    opts = {
      pairs = { { "(", ")" }, { "[", "]" }, { "{", "}" }, { "<", ">" } },
    },
    init = function() vim.g.loaded_matchparen = 1 end,
  },
  {
    "xlboy/peepsight.nvim",
    event = "VeryLazy",
    config = function()
      require("peepsight").setup({
        -- Lua
        "function_definition",
        "local_function_definition_statement",
        "function_definition_statement",

        -- TypeScript
        "if_statement",
        "class_declaration",
        "method_definition",
        "arrow_function",
        "function_declaration",
        "generator_function_declaration",
      }, {
        highlight = { hl_group = "SpecialKey" },
      })
      require("peepsight").enable()
    end,
  },
}
