local u = require("utils")
return {
  {
    "xlboy/flash.nvim",
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
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            search = { multi_window = false },
          })
        end,
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
    keys = { { ";", desc = "Wordmotion startup!" } },
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
  {
    -- TODO: 待换，因为不能基于 cwd 来进行 mark
    "tomasky/bookmarks.nvim",
    event = "User Startup60s",
    config = function()
      require("bookmarks").setup({
        on_attach = function(bufnr)
          local bm = require("bookmarks")
          local map = vim.keymap.set
          map("n", "<leader>mcc", bm.bookmark_toggle) -- add or remove bookmark at current line
          map("n", "<leader>mi", bm.bookmark_ann) -- add or edit mark annotation at current line
          map("n", "<leader>mca", bm.bookmark_clean) -- clean all marks in local buffer
          map("n", "<leader>mj", bm.bookmark_next) -- jump to next mark in local buffer
          map("n", "<leader>mk", bm.bookmark_prev) -- jump to previous mark in local buffer
          map("n", "<leader>ml", ":Telescope bookmarks list<CR>") -- show marked file list in quickfix window
        end,
      })
      require("telescope").load_extension("bookmarks")
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
    "xlboy/filestack.nvim",
    event = "BufRead",
    opts = {
      keymaps = {
        jump = { backward = "<c-o>", forward = "<c-i>" },
        navigate = { backward = "<c-u>", forward = "<c-y>" },
      },
    },
  },
}
