return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("tokyonight").setup()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    config = function()
      local transparent = require("transparent")
      transparent.setup({
        extra_groups = { "MasonNormal", "NvimTreeNormal", "FoldColumn" },
        exclude_groups = { "CursorLine" },
      })
      transparent.clear_prefix("BufferLine")
      transparent.clear_prefix("NeoTree")
      transparent.clear_prefix("neo-tree")
      transparent.clear_prefix("DiagnosticVirtual")
      transparent.clear_prefix("NvimSeparator")
    end,
    keys = {
      { "<leader>uT", "<cmd>TransparentToggle<CR>", desc = "Toggle transparency" },
    },
  },
}
