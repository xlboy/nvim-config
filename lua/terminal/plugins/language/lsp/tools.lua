return {
  {
    "antosha417/nvim-lsp-file-operations",
    commit = "8e7223e138590c1bd9d86d3de810e65939d8b12f",
    event = "User BufRead",
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
          close = { "q" },
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
    event = "User BufRead",
    opts = {
      floating_window = true,
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
    "folke/trouble.nvim",
    enabled = false,
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
}
