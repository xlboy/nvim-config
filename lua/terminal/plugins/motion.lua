local u = require("terminal.utils")

return {
  {
    "folke/flash.nvim",
    ---@type Flash.Config
    opts = {
      label = { uppercase = false },
      modes = {
        search = { enabled = false },
        char = { enabled = false, multi_line = false },
      },
    },
    keys = {
      -- {
      --   "s",
      --   mode = { "n", "v", "o" },
      --   "<cmd>lua require('flash').jump({ search = { multi_window = false } })<CR>",
      --   desc = "Flash",
      -- },
      { "<leader>ssv", "<cmd>lua require('flash').treesitter_search()<CR>", desc = "Flash treesitter_search" },
      { "<leader>sv", "<cmd>lua require('flash').treesitter()<CR>", desc = "Flash treesitter" },
    },
  },
  {
    "ggandor/flit.nvim",
    event = "User BufRead",
    commit = "f4e9af572a62c808c8de214da672f2a115a98c35",
    config = function()
      require("flit").setup({ labeled_modes = "nx", multiline = false, opts = {} })
    end,
    dependencies = {
      { "ggandor/leap.nvim", commit = "208b0e5ae9f34f7cea4fdf97acb91429c346e250" },
      "tpope/vim-repeat",
    },
  },
  {
    "chaoren/vim-wordmotion",
    event = "User BufRead",
    init = function()
      vim.g.wordmotion_prefix = ";"
    end,
  },
  -- {
  --   "backdround/neowords.nvim",
  --   commit = "042d437f2a9eedffde1ab71238c95ed177e45b59",
  --   event = "User BufRead",
  --   config = function()
  --     local n = require("neowords")
  --     local p = n.pattern_presets
  --     local bigword = n.get_word_hops("\\v-@![-_[:lower:][:upper:][:digit:]]+")
  --     local string_group = n.get_word_hops('\\v"[^"]*"', "\\v'[^']*'", "\\v`[^`]*`")
  --     local symbol_group = n.get_word_hops("\\v[^[:alnum:]_\"'` ]")
  --
  --     vim.keymap.set({ "n", "x", "o" }, "W", bigword.forward_start)
  --     vim.keymap.set({ "n", "x", "o" }, "B", bigword.backward_start)
  --     vim.keymap.set({ "n", "x", "o" }, "e", string_group.forward_start)
  --     vim.keymap.set({ "n", "x", "o" }, "E", string_group.backward_start)
  --     vim.keymap.set({ "n", "x", "o" }, "q", symbol_group.forward_start)
  --     vim.keymap.set({ "n", "x", "o" }, "Q", symbol_group.backward_start)
  --   end,
  -- },
  {
    "xlboy/nvim-spider",
    event = "BufRead",
    opts = { skipInsignificantPunctuation = true },
    keys = {
      { "W", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "x" } },
      { "B", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "x" } },
    },
  },
  {
    "gsuuon/tshjkl.nvim",
    keys = { { "<leader>ct", desc = "Toggle tshjkl" } },
    opts = {
      select_current_node = false,
      keymaps = { toggle = "<leader>ct" },
    },
  },
  {
    "kwkarlwang/bufjump.nvim",
    event = "User BufRead",
    opts = { forward = "<C-u>", backward = "<C-y>" },
  },
  {
    "xlboy/node-edge-toggler.nvim",
    -- dir = "~/Desktop/xlboy/node-edge-toggler.nvim",
    init = function()
      local cmd = "<cmd>lua require('node-edge-toggler').toggle()<CR>"
      vim.api.nvim_create_autocmd({ "BufEnter" }, {
        pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.md", "*.json", "*.lua", "*.cpp", "*.c", "*.py", "*.java" },
        callback = function(ev)
          vim.api.nvim_buf_set_keymap(ev.buf, "n", "%", cmd, { noremap = true, silent = true })
        end,
      })
    end,
  },
  -- {
  --   "rainbowhxch/accelerated-jk.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("accelerated-jk").setup({
  --       acceleration_motions = { "w", "b" },
  --       acceleration_limit = 80,
  --       acceleration_table = { 3, 6, 10, 25, 40, 60, 100, 150 },
  --     })
  --     vim.api.nvim_set_keymap("n", "j", "<Plug>(accelerated_jk_gj)", {})
  --     vim.api.nvim_set_keymap("n", "k", "<Plug>(accelerated_jk_gk)", {})
  --   end,
  -- },
  {
    "smoka7/hop.nvim",
    keys = {
      { "s", "<cmd>HopWord<CR>", mode = { "n", "v" } },
      { ";l", "<cmd>HopLineStart<CR>", mode = { "n", "v" } },
      {
        ";f",
        function()
          require("hop").hint_words({ current_line_only = true })
        end,
        mode = { "n", "v" },
      },
    },
    config = function()
      require("hop").setup()
      vim.api.nvim_command("highlight HopNextKey1 cterm=bold gui=bold guifg=#ff007c")
      vim.api.nvim_command("highlight HopNextKey2 cterm=bold gui=bold guifg=#ff007c")
    end,
  },
  -- {
  --   "bloznelis/before.nvim",
  --   keys = {
  --     { "<C-o>", "<cmd>lua require('before').jump_to_last_edit()<CR>", mode = { "n" } },
  --     { "<C-i>", "<cmd>lua require('before').jump_to_next_edit()<CR>", mode = { "n" } },
  --   },
  --   opts = { history_size = 100 },
  -- },
  -- { "boltlessengineer/smart-tab.nvim", opts = {} },
  -- {
  --   "abecodes/tabout.nvim",
  --   dependencies = { "hrsh7th/nvim-cmp" },
  --   event = "User BufRead",
  --   opts = {
  --     act_as_tab = false,
  --   },
  -- },
  {
    "AgusDOLARD/backout.nvim",
    opts = {},
    keys = {
      { "<C-b><C-b>", "<cmd>lua require('backout').back()<cr>", mode = { "i", "n" } },
      { "<C-b><C-o>", "<cmd>lua require('backout').out()<cr>", mode = { "i", "n" } },
    },
  },
  -- TODO: 好像有bug, 回头自己写一个
  -- {
  --   "DarkKronicle/recall.nvim",
  --   event = "User BufRead",
  --   keys = {
  --     { "<C-i>", "<cmd>lua require('recall').jump_backwards()<CR>", desc = "Recall backwards through history" },
  --     { "<C-o>", "<cmd>lua require('recall').jump_forwards()<CR>", desc = "Recall forwards through history" },
  --   },
  --   opts = {},
  -- },
}
