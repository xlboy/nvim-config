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
      {
        "s",
        mode = { "n", "v", "o" },
        "<cmd>lua require('flash').jump({ search = { multi_window = false } })<CR>",
        desc = "Flash",
      },
      { "<leader>ssv", "<cmd>lua require('flash').treesitter_search()<CR>", desc = "Flash treesitter_search" },
      { "<leader>sv", "<cmd>lua require('flash').treesitter()<CR>", desc = "Flash treesitter" },
    },
  },
  {
    "ggandor/flit.nvim",
    event = "BufRead",
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
    event = "BufRead",
    init = function()
      vim.g.wordmotion_prefix = ";"
    end,
  },
  {
    "xlboy/nvim-spider",
    event = "BufRead",
    opts = { skipInsignificantPunctuation = true },
    keys = {
      { "W", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "x" } },
      { "B", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "x" } },
    },
  },
  -- {
  --   "backdround/rabbit-hop.nvim",
  --   event = "BufRead",
  --   config = function() end,
  -- },
  {
    "gsuuon/tshjkl.nvim",
    keys = { { "<leader>ct", desc = "Toggle tshjkl" } },
    opts = {
      select_current_node = false,
      keymaps = { toggle = "<leader>ct" },
    },
  },
  -- {
  --   "xlboy/filestack.nvim",
  --   event = "BufRead",
  --   opts = {
  --     keymaps = {
  --       jump = { backward = "<c-o>", forward = "<c-i>" },
  --       navigate = { backward = "<c-u>", forward = "<c-y>" },
  --     },
  --   },
  -- },
  {
    "kwkarlwang/bufjump.nvim",
    event = "BufRead",
    opts = { forward = "<C-y>", backward = "<C-u>" },
  },
  {
    "DarkKronicle/recall.nvim",
    event = "BufRead",
    keys = {
      { "<C-i>", "<cmd>lua require('recall').jump_backwards()<CR>", desc = "Recall backwards through history" },
      { "<C-o>", "<cmd>lua require('recall').jump_forwards()<CR>", desc = "Recall forwards through history" },
    },
    opts = {},
  },
}
