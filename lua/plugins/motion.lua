return {
  {
    "xlboy/flash.nvim",
    lazy = true,
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
      {
        "<leader>ssv",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Flash treesitter_search",
      },
      {
        "<leader>sv",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash treesitter",
      },
    },
  },
  {
    "ggandor/flit.nvim",
    lazy = true,
    keys = function()
      ---@type LazyKeys[]
      local ret = {}
      for _, key in ipairs({ "f", "F", "t", "T" }) do
        ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
      end
      return ret
    end,
    opts = { labeled_modes = "nx", multiline = false, opts = {} },
    dependencies = {
      "ggandor/leap.nvim",
      dependencies = { "tpope/vim-repeat" },
    },
  },
  {
    "chaoren/vim-wordmotion",
    event = "VeryLazy",
    init = function()
      vim.g.wordmotion_prefix = ";"
    end,
  },
  {
    "xlboy/nvim-spider",
    -- dir = "~/Desktop/xlboy/__open-source__/nvim-spider",
    -- "chrisgrieser/nvim-spider",
    event = "VeryLazy",
    opts = {
      skipInsignificantPunctuation = true,
      -- subwordMovement = false,
    },
    keys = {
      {
        "W",
        function()
          require("spider").motion("w")
        end,
        mode = { "n", "x" },
      },
      {
        "B",
        function()
          require("spider").motion("b")
        end,
        mode = { "n", "x" },
      },
    },
  },
  {
    "tomasky/bookmarks.nvim",
    event = "VeryLazy",
    config = function()
      require("bookmarks").setup({
        save_file = vim.fn.stdpath("data") .. "bookmarks",
        keywords = {
          ["@t"] = "☑️ ", -- mark annotation startswith @t ,signs this icon as `Todo`
          ["@w"] = "⚠️ ", -- mark annotation startswith @w ,signs this icon as `Warn`
          ["@f"] = "⛏ ", -- mark annotation startswith @f ,signs this icon as `Fix`
          ["@n"] = " ", -- mark annotation startswith @n ,signs this icon as `Note`
        },
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
    "cbochs/portal.nvim",
    event = "VeryLazy",
    keys = {
      -- { "<C-o>", "<cmd>Portal jumplist backward<cr>", desc = "Jump Backward" },
      -- { "<C-i>", "<cmd>Portal jumplist forward<cr>", desc = "Jump Forward" },
      { "g;", "<cmd>Portal changelist backward<cr>", desc = "Change Backward" },
      { "g,", "<cmd>Portal changelist forward<cr>", desc = "Change Forward" },
    },
    config = true,
  },
  {
    "gsuuon/tshjkl.nvim",
    event = "VeryLazy",
    opts = {
      select_current_node = false,
      keymaps = { toggle = "<leader>ct" },
    },
  },
}
