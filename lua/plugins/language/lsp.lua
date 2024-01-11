local u = require("utils")
local config = require("config.config")

return {
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      { "williamboman/mason-lspconfig.nvim" },
    },
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
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      { "jay-babu/mason-null-ls.nvim", cmd = { "NullLsInstall", "NullLsUninstall" } },
    },
  },
  {
    "nvimdev/lspsaga.nvim",
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
      { "<leader>la", ":Lspsaga code_action<CR>", desc = "Show code actions" },
      { "<leader>la", ":<C-U>Lspsaga range_code_action<CR>", desc = "Show code actions", mode = "v" },
      { "]d", ":Lspsaga diagnostic_jump_next<CR>", desc = "Jump to next diagnostic" },
      { "[d", ":Lspsaga diagnostic_jump_prev<CR>", desc = "Jump to previous diagnostic" },
      { "gh", ":Lspsaga hover_doc<CR>", desc = "Show hover doc" },
      { "gd", ":Lspsaga goto_definition<CR>", desc = "Show hover doc" },
      { "gkh", ":Lspsaga hover_doc ++keep<CR>", desc = "Show hover doc [keep]" },
      { "gr", ":Lspsaga finder<CR>", desc = "Show lsp finder" },
      { "<leader>lr", ":Lspsaga rename<CR>", desc = "Rename symbol" },
      { "gl", ":Lspsaga show_line_diagnostics<CR>", desc = "Show line diagnostics" },
      { "<leader>l.", ":Lspsaga signature_help<CR>", desc = "Show signature help" },
    },
  },
  {
    "antosha417/nvim-lsp-file-operations",
    commit = "8e7223e138590c1bd9d86d3de810e65939d8b12f",
    event = "User Startup30s", -- 启动 30s 后再加载
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
  {
    "hedyhli/outline.nvim",
    config = function()
      require("outline").setup({
        outline_window = {
          position = "left",
          width = 45,
          relative_width = false,
        },
        keymaps = {
          hover_symbol = "gh",
          toggle_preview = "P",
        },
        symbols = { filter = { "Function", "Class", "Method" } },
      })
    end,
    keys = function()
      local o = require("outline")
      local function switch_symbol(callback)
        vim.ui.select({ "Function", "default" }, {
          prompt = "[Outline] Target Symbol",
        }, function(symbol)
          if not symbol then return end

          local filter = {}
          if symbol ~= "default" then filter = { symbol } end
          require("outline.config").setup({
            symbols = { filter = filter },
          })
          callback(symbol)
        end)
      end

      return {
        {
          "<leader>lss",
          function()
            switch_symbol(function()
              if o.is_open() then o.refresh() end
            end)
          end,
          desc = "[Outline] Toogle",
        },
        {
          "<leader>lst",
          function()
            if o.is_open() then return o.focus_toggle() end
            o.open()
          end,
          desc = "[Outline] Toogle",
        },
        { "<leader>lsc", "<cmd>lua require('outline').close()<CR>", desc = "[Outline] Close" },
      }
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    commit = "fed2c8389c148ff1dfdcdca63c2b48d08a50dea0",
    event = "InsertEnter",
    opts = {
      floating_window = false,
      hint_enable = true,
      transparency = 5,
      toggle_key = "<C-s>",
      toggle_key_flip_floatwin_setting = true,
    },
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    branch = "anticonceal",
    commit = "0fb3b5ef16f2d7e85963cb0b1beacf573ade35de",
    keys = { "<leader>lit", desc = "[Lsp] Toggle Inlay Hints" },
    init = function()
      local open = false
      vim.g.switch_inlay_hints = function(buf)
        open = not open
        vim.lsp.inlay_hint.enable(buf, open)
      end
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
              "<cmd>lua vim.g.switch_inlay_hints(" .. args.buf .. ")<CR>",
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

  {
    "j-hui/fidget.nvim",
    event = "BufRead",
    opts = {
      notification = { window = { winblend = 0 } },
      integration = {
        ["nvim-tree"] = { enable = true },
      },
    },
  },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = {
      use_diagnostic_signs = true,
      action_keys = {
        hover = "gh",
      },
    },
    keys = {
      { "<leader>ldc", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>lda", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then vim.notify(err, vim.log.levels.ERROR) end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then vim.notify(err, vim.log.levels.ERROR) end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
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
