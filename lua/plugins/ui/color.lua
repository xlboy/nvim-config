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
        -- 取消光标行的透明
        exclude_groups = { "CursorLine" },
      })
      transparent.clear_prefix("BufferLine")
      transparent.clear_prefix("NeoTree")
    end,
    keys = {
      { "<leader>uT", "<cmd>TransparentToggle<CR>", desc = "Toggle transparency" },
    },
  },
}
