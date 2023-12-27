local u = require("utils")
local constants = require("config.constants")

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    event = "VeryLazy",
    -- opts = {
    --   inlay_hints = { enabled = true },
    -- },
    config = function()
      -- Set correct icons in sign column
      local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = "󰋽 " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl })
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- local on_attach = function(client, bufnr)
      --   if client.server_capabilities.inlayHintProvider then vim.lsp.inlay_hint.enable(bufnr, true) end
      -- end

      require("mason-lspconfig").setup_handlers({
        function(server_name)
          local opts = {
            inlay_hints = { enabled = true },
            on_attach = on_attach,
            capabilities = capabilities,
          }

          if server_name == "clangd" then opts.cmd = { "clangd", "--offset-encoding=utf-16" } end
          if server_name == "tsserver" then
            opts.settings = {
              typescript = {
                inlayHints = {
                  includeInlayParameterNameHints = "all",
                  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = false,
                  includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
                },
              },
              javascript = {
                inlayHints = {
                  includeInlayParameterNameHints = "all",
                  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = false,
                  includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
                },
              },
            }
          end

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
  { "stevearc/aerial.nvim", event = "VeryLazy", opts = {} },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {
      floating_window = false,
      hint_enable = true,
      transparency = 5,
      toggle_key = "<C-s>",
      toggle_key_flip_floatwin_setting = true,
    },
  },
  {
    enabled = true,
    "lvimuser/lsp-inlayhints.nvim",
    branch = "anticonceal",
    commit = "aa1fee3469f70842fecb0e915fa0d1e5c6784501",
    init = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspAttach_inlayhints", {}),
        callback = function(args)
          if not (args.data and args.data.client_id) then return end
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client.server_capabilities.inlayHintProvider then
            local inlayhints = require("lsp-inlayhints")
            inlayhints.on_attach(client, args.buf)
            vim.api.nvim_buf_set_keymap(
              args.buf,
              "n",
              "<leader>lit",
              "<cmd>lua require('lsp-inlayhints').toggle()<CR>",
              { noremap = true, silent = true }
            )
          end
        end,
      })
    end,
    config = function()
      require("lsp-inlayhints").setup({ enabled_at_startup = false })
      vim.cmd([[highlight LspInlayHint guibg=NONE guifg=#5c6370]])
    end,
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
