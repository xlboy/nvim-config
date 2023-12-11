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
        function() require("flash").treesitter_search() end,
        desc = "Flash treesitter_search",
      },
      {
        "<leader>sv",
        mode = { "n", "o", "x" },
        function() require("flash").treesitter() end,
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
    init = function() vim.g.wordmotion_prefix = ";" end,
  },
  {
    "xlboy/nvim-spider",
    -- dir = "~/Desktop/xlboy/__open-source__/nvim-spider",
    event = "VeryLazy",
    config = function() require("spider").setup({ skipInsignificantPunctuation = true }) end,
    keys = {
      { "W", function() require("spider").motion("w") end, mode = { "n", "x" } },
      { "B", function() require("spider").motion("b") end, mode = { "n", "x" } },
    },
  },
}
