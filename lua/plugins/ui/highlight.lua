return {
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
    -- dir = "~/Desktop/xlboy/peepsight.nvim",
    event = "VeryLazy",
    init = function()
      vim.api.nvim_create_autocmd("WinLeave", {
        callback = function()
          local cur_win = vim.api.nvim_get_current_win()
          local cur_buf = vim.api.nvim_win_get_buf(cur_win)
          require("peepsight").clear(cur_buf)
        end,
      })
    end,
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
  { "itchyny/vim-cursorword", event = "UIEnter" },
  {
    -- 将不活跃的窗口置灰
    "miversen33/sunglasses.nvim",
    event = "UIEnter",
    opts = { filter_percent = 0.5 },
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "UIEnter",
    cmd = { "ColorizerToggle", "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers" },
    opts = {
      user_default_options = { names = true },
    },
  },
}
