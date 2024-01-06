local u = require("utils")

return {
  {
    "xlboy/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = u.basic.append_arrays(opts.ensure_installed, {
        "markdown",
        "markdown_inline",
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
  {
    "HakonHarnes/img-clip.nvim",
    ft = "markdown",
    config = function()
      require("img-clip").setup()
      require("commander").add({
        {
          desc = "Paste clipboard image",
          cmd = "<cmd>PasteImage<CR>",
          cat = "markdown",
        },
      }, {})
    end,
  },
}
