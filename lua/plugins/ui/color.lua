return {
  {
    enabled = true,
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("tokyonight").setup({
        -- 不仅是让 tokyonight 透明，也是让 nvim-notify 透明
        transparent = true,
      })
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
      local prefix = { "BufferLine", "NeoTree", "neo-tree", "DiagnosticVirtual", "NvimSeparator", "Trouble", "Edgy", "TabLineFill" }
      for _, v in ipairs(prefix) do
        transparent.clear_prefix(v)
      end
    end,
    keys = {
      { "<leader>uT", "<cmd>TransparentToggle<CR>", desc = "Toggle transparency" },
    },
  },
}
