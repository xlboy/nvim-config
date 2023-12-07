return {
  {
    "gelguy/wilder.nvim",
    event = "CmdlineEnter",
    config = function()
      local wilder = require("wilder")
      wilder.setup({ modes = { ":", "/", "?" } })
      wilder.set_option(
        "renderer",
        wilder.renderer_mux({
          [":"] = wilder.popupmenu_renderer({
            highlighter = wilder.basic_highlighter(),
          }),
          ["/"] = wilder.wildmenu_renderer({
            highlighter = wilder.basic_highlighter(),
          }),
        })
      )
    end,
    dependencies = {
      "romgrk/fzy-lua-native",
      "lambdalisue/nerdfont.vim",
    },
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
        "class_declaration",
        "method_definition",
        "arrow_function",
        "function_declaration",
        "generator_function_declaration",
      }, {
        highlight = { hl_group = "SpecialKey" }
      })
      require("peepsight").enable()
    end,
  },
  {
    "Pocco81/true-zen.nvim",
    lazy = true,
    keys = { { "<leader>tzn", ":TZNarrow<CR>", mode = { "v" } } },
    config = function()
      require("true-zen").setup({})
    end,
  },
  {
    "xlboy/function-picker.nvim",
    lazy = true,
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      {
        "<leader>fns",
        function()
          require("function-picker").show({
            deep = {
              mode = "flat",
              tree_contour_opts = { indent = 2 },
              flat_opts = { space_character = " 🌀 " },
            },
          })
        end,
        mode = { "n" },
      },
    },
  },
  {
    "AckslD/nvim-FeMaco.lua",
    lazy = true,
    config = function()
      require("femaco").setup()
    end,
  },
}
