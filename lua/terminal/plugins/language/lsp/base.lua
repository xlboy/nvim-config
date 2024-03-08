return {
  {
    "neovim/nvim-lspconfig",
    event = "User BufRead",
    -- lazy = false,
    dependencies = {
      { "williamboman/mason.nvim", opts = {} },
      { "williamboman/mason-lspconfig.nvim", opts = { automatic_installation = true } },
    },
    init = function()
      local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = "󰋽 " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl })
      end
    end,
    config = function(_, opts)
      local default_lsp_opts = {
        inlay_hints = { enabled = true },
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      }
      local lspconfig = require("lspconfig")
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          local merged_opts = vim.tbl_extend("force", default_lsp_opts, opts[server_name] or {})
          lspconfig[server_name].setup(merged_opts)
        end,
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = { { "jay-babu/mason-null-ls.nvim" } },
    cmd = { "NullLsInstall", "NullLsUninstall", "NullLsLog", "NullLsInfo" },
    opts = {},
  },
}
