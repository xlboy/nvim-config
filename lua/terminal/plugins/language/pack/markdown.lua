local u = require("terminal.utils")

return {
  {
    "xlboy/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = u.basic.append_arrays(opts.ensure_installed, {
        -- "markdown",
        -- "markdown_inline",
      })
    end,
  },
  -- {
  --   "williamboman/mason-lspconfig.nvim",
  --   opts = function(_, opts)
  --     opts.ensure_installed = u.basic.append_arrays(opts.ensure_installed, { "marksman" })
  --   end,
  -- },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = "markdown",
  },
  { "AckslD/nvim-FeMaco.lua", main = "femaco", ft = { "markdown" }, config = true },
  {
    "Myzel394/easytables.nvim",
    ft = "markdown",
    opts = {},
  },
  {
    "MeanderingProgrammer/markdown.nvim",
    name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("render-markdown").setup({})
    end,
  },
}
