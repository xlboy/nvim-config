local u = require("utils")

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
  {
    "backdround/neowords.nvim",
    commit = "042d437f2a9eedffde1ab71238c95ed177e45b59",
    event = "User BufRead",
    config = function()
      local n = require("neowords")
      local p = n.pattern_presets
      local bigword = n.get_word_hops("\\v-@![-_[:lower:][:upper:][:digit:]]+")
      local string_group = n.get_word_hops('\\v"[^"]*"', "\\v'[^']*'", "\\v`[^`]*`")
      local symbol_group = n.get_word_hops("\\v[^[:alnum:]_\"'` ]")

      vim.keymap.set({ "n", "x", "o" }, "W", bigword.forward_start)
      vim.keymap.set({ "n", "x", "o" }, "B", bigword.backward_start)
      vim.keymap.set({ "n", "x", "o" }, "e", string_group.forward_start)
      vim.keymap.set({ "n", "x", "o" }, "E", string_group.backward_start)
      vim.keymap.set({ "n", "x", "o" }, "q", symbol_group.forward_start)
      vim.keymap.set({ "n", "x", "o" }, "Q", symbol_group.backward_start)
    end,
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
    cmd = { "HopWord", "HopChar1", "HopChar2", "HopLine" },
    keys = {
      { "<leader>;j", "<cmd>HopLineStartAC<CR>", mode = { "n", "v" }, desc = "HopLineStartAC" },
      { "<leader>;k", "<cmd>HopLineStartBC<CR>", mode = { "n", "v" }, desc = "HopLineStartCC" },
      { "<leader>;w", "<cmd>HopWordAC<CR>", mode = { "n", "v" }, desc = "HopWordAC" },
      { "<leader>;b", "<cmd>HopWordBC<CR>", mode = { "n", "v" }, desc = "HopWordBC" },
      {
        "<leader>;l",
        function()
          require("hop").hint_words({ current_line_only = true, direction = 2 })
        end,
        mode = { "n", "v" },
        desc = "HopWord L(Only CurrentLine)",
      },
      {
        "<leader>;h",
        function()
          require("hop").hint_words({ current_line_only = true, direction = 1 })
        end,
        mode = { "n", "v" },
        desc = "HopWord H(Only CurrentLine)",
      },
    },
    config = function()
      require("hop").setup()
      vim.api.nvim_command("highlight HopNextKey1 cterm=bold gui=bold guifg=#ff007c")
      vim.api.nvim_command("highlight HopNextKey2 cterm=bold gui=bold guifg=#ff007c")
    end,
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
