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
    "Pocco81/true-zen.nvim",
    lazy = true,
    keys = { { "<leader>tzn", ":TZNarrow<CR>", mode = { "v" } } },
    config = function() require("true-zen").setup({}) end,
  },
  {
    "AckslD/nvim-FeMaco.lua",
    lazy = true,
    config = function() require("femaco").setup() end,
  },
}
