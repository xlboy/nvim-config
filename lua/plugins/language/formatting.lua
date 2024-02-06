return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "n",
      desc = "Format buffer",
    },
  },
  config = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "myPrettier" },
        typescript = { "myPrettier" },
        typescriptreact = { "myPrettier" },
        markdown = { "myPrettier" },
        json = { "prettier" },
        cpp = { "clang-format" },
      },
      format_on_save = false,
    })

    require("conform").formatters.myPrettier = {
      command = "prettier",
      args = { "$FILENAME", "--write" },
      stdin = false,
      cwd = require("conform.util").root_file({ ".prettierrc", "package.json" }),
      require_cwd = true,
    }
  end,
}
