local u = require("utils")
local constants = require("config.constants")

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    event = "VeryLazy",
    config = function()
      -- Set correct icons in sign column
      local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = "󰋽 " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl })
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(client, bufnr) end

      require("mason-lspconfig").setup_handlers({
        function(server_name)
          local opts = { on_attach = on_attach, capabilities = capabilities }

          if server_name == "clangd" then opts.cmd = { "clangd", "--offset-encoding=utf-16" } end

          require("lspconfig")[server_name].setup(opts)
        end,
      })
    end,
  },
  { "williamboman/mason.nvim", config = true },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "VeryLazy",
    opts = function()
      local ensure_installed = { "lua_ls", "tsserver" }

      if constants.IS_WIN then
        u.basic.append_arrays(ensure_installed, {
          "clangd",
          "neocmake",
        })
      end

      return { ensure_installed = ensure_installed }
    end,
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "VeryLazy",
    opts = {
      symbol_in_winbar = { enable = false },
      lightbulb = { virtual_text = false },
      finder = { default = "ref", left_width = 0.3 },
      code_action = { extend_gitsigns = true },
      rename = {
        in_select = false,
        keys = {
          quit = { "q", "<ESC>" },
        },
      },
    },
    keys = {
      { "<leader>la", ":Lspsaga code_action<CR>", desc = "Show code actions", mode = "n" },
      { "<leader>la", ":<C-U>Lspsaga range_code_action<CR>", desc = "Show code actions", mode = "v" },
      { "]d", ":Lspsaga diagnostic_jump_next<CR>", desc = "Jump to next diagnostic", mode = "n" },
      { "[d", ":Lspsaga diagnostic_jump_prev<CR>", desc = "Jump to previous diagnostic", mode = "n" },
      { "gh", ":Lspsaga hover_doc<CR>", desc = "Show hover doc", mode = "n" },
      { "gd", ":Lspsaga goto_definition<CR>", desc = "Show hover doc", mode = "n" },
      { "gkh", ":Lspsaga hover_doc ++keep<CR>", desc = "Show hover doc [keep]", mode = "n" },
      { "gr", ":Lspsaga finder<CR>", desc = "Show lsp finder", mode = "n" },
      { "<leader>lr", ":Lspsaga rename<CR>", desc = "Rename symbol", mode = "n" },
      { "gl", ":Lspsaga show_line_diagnostics<CR>", desc = "Show line diagnostics", mode = "n" },
      { "<leader>l.", ":Lspsaga signature_help<CR>", desc = "Show signature help", mode = "n" },
    },
  },
  {
    "antosha417/nvim-lsp-file-operations",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
  {
    event = "VeryLazy",
    "stevearc/aerial.nvim",
    opts = {},
  },
  -- {
  --   "ErichDonGubler/lsp_lines.nvim",
  --   event = "BufEnter",
  --   init = function()
  --     vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
  --   end,
  --   config = true,
  --   keys = {
  --     {
  --       "<leader>ldt",
  --       function()
  --         local new_virtual_lines = not vim.diagnostic.config().virtual_lines
  --         vim.diagnostic.config({ virtual_lines = new_virtual_lines, virtual_text = not new_virtual_lines })
  --       end,
  --       desc = "[Lsp] Toogle Diagnostic Mode (line/text)",
  --     },
  --   },
  -- },
}
