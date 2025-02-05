return {
  {
    "nvimdev/lspsaga.nvim",
    opts = {
      symbol_in_winbar = { enable = false },
      lightbulb = { virtual_text = false },
      finder = { enable = false, default = "ref", left_width = 0.3 },
      code_action = { enable = false, extend_gitsigns = true },
      rename = {
        enable = false,
        in_select = false,
        keys = { quit = { "q", "<ESC>" } },
      },
    },
    keys = {
      { "<leader>la",    "<cmd>Lspsaga code_action<CR>",            desc = "Show code actions" },
      { "<leader>la",    "<cmd><C-U>Lspsaga range_code_action<CR>", desc = "Show code actions",          mode = "v" },
      { "]d",            "<cmd>Lspsaga diagnostic_jump_next<CR>",   desc = "Jump to next diagnostic" },
      { "[d",            "<cmd>Lspsaga diagnostic_jump_prev<CR>",   desc = "Jump to previous diagnostic" },
      -- { "gh", "<cmd>Lspsaga hover_doc<CR>", desc = "Show hover doc" },
      { "<C-LeftMouse>", "<cmd>Lspsaga goto_definition<CR>",        desc = "Show hover doc" },
      { "gd",            "<cmd>Lspsaga goto_definition<CR>",        desc = "Show hover doc" },
      { "gkh",           "<cmd>Lspsaga hover_doc ++keep<CR>",       desc = "Show hover doc [keep]" },
      { "gr",            "<cmd>Lspsaga finder<CR>",                 desc = "Show lsp finder" },
      { "<leader>lr",    vim.lsp.buf.rename,                        desc = "Rename symbol" },
      { "gl",            "<cmd>Lspsaga show_line_diagnostics<CR>",  desc = "Show line diagnostics" },
      { "<leader>l.",    "<cmd>Lspsaga signature_help<CR>",         desc = "Show signature help" },
    },
  },
  {
    enabled = false,
    "ray-x/navigator.lua",
    event = "User BufRead",
    dependencies = { { "ray-x/guihua.lua", build = "cd lua/fzy && make" } },
    config = function()
      require("navigator").setup({
        lsp_signature_help = false,
        default_mapping = false,
      })
    end,
    keys = function()
      return {
        { "gr", require("navigator.reference").reference },
      }
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
