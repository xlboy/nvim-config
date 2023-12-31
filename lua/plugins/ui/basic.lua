return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "UIEnter",
    config = function()
      vim.cmd("highlight XlboyIndentScope guifg=#7bdfd0")
      require("ibl").setup({
        indent = { char = "│" },
        scope = {
          show_start = false,
          show_end = false,
          highlight = "XlboyIndentScope",
        },
        exclude = {
          buftypes = { "nofile", "terminal" },
          filetypes = { "help", "alpha", "dashboard", "lazy", "neogitstatus", "NvimTree", "neo-tree" },
        },
      })
    end,
  },
  {
    "dstein64/nvim-scrollview",
    enabled = false,
    event = "BufReadPre",
    opts = {
      on_startup = 1,
      signs_on_startup = { "diagnostics", "folds", "marks", "search", "spell" },
      winblend = 60,
      hide_on_intersect = 1,
      column = 1,
      current_only = 1,
      scrollview_auto_mouse = true,
      mode = "simple",
      diagnostics_error_symbol = "│", -- "▎",
      diagnostics_warn_symbol = "│", --"▎",
      -- diagnostics_info_symbol = "▎",
      -- diagnostics_hint_symbol = "",
    },
  },
}
