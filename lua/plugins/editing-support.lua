return {
  { "wellle/targets.vim", event = "VeryLazy" },
  {
    "echasnovski/mini.surround",
    keys = {
      { "gza", desc = "Add surrounding", mode = { "n", "v" } },
      { "gzd", desc = "Delete surrounding" },
      { "gzf", desc = "Find right surrounding" },
      { "gzF", desc = "Find left surrounding" },
      { "gzh", desc = "Highlight surrounding" },
      { "gzr", desc = "Replace surrounding" },
      { "gzn", desc = "Update `MiniSurround.config.n_lines`" },
    },
    opts = {
      mappings = {
        add = "gza",
        delete = "gzd",
        find = "gzf",
        find_left = "gzF",
        highlight = "gzh",
        replace = "gzr",
        update_n_lines = "gzn",
      },
    },
  },
  {
    "Wansmer/sibling-swap.nvim",
    dependencies = { "nvim-treesitter" },
    keys = {
      {
        "<leader>s.",
        function()
          require("sibling-swap").swap_with_right_with_opp()
        end,
        desc = "Swap with right with opp",
      },
      {
        "<leader>s,",
        function()
          require("sibling-swap").swap_with_left_with_opp()
        end,
        desc = "Swap with left with opp",
      },
      {
        "<C-.>",
        function()
          require("sibling-swap").swap_with_right()
        end,
        desc = "Swap with right",
      },
      {
        "<C-,>",
        function()
          require("sibling-swap").swap_with_left()
        end,
        desc = "Swap with left",
      },
    },
    config = function()
      require("sibling-swap").setup({
        allowed_separators = {
          ",",
          ";",
          "and",
          "or",
          "&&",
          "&",
          "||",
          "|",
          "==",
          "===",
          "!=",
          "!==",
          "-",
          "+",
          ["<"] = ">",
          ["<="] = ">=",
          [">"] = "<",
          [">="] = "<=",
        },
        use_default_keymaps = true,
        -- Highlight recently swapped node. Can be boolean or table
        -- If table: { ms = 500, hl_opts = { link = 'IncSearch' } }
        -- `hl_opts` is a `val` from `nvim_set_hl()`
        highlight_node_at_cursor = false,
        -- keybinding for movements to right or left (and up or down, if `allow_interline_swaps` is true)
        keymaps = {
          ["<C-.>"] = "swap_with_right",
          ["<C-,>"] = "swap_with_left",
          ["<leader>s."] = "swap_with_right_with_opp",
          ["<leader>s,"] = "swap_with_left_with_opp",
        },
        ignore_injected_langs = false,
        -- allow swaps across lines
        allow_interline_swaps = true,
        -- swaps interline siblings without separators (no recommended, helpful for swaps html-like attributes)
        interline_swaps_witout_separator = false,
      })
    end,
  },
  { "xlboy/swap-ternary.nvim", event = "VeryLazy" },
  { "echasnovski/mini.bracketed", event = "VeryLazy" },
  {
    "mizlan/iswap.nvim",
    cmd = { "ISwap", "ISwapWith", "ISwapNode", "ISwapNodeWith" },
    config = function()
      require("iswap").setup({
        keys = "asdfghjklqwertyuiop123456",
        hl_snipe = "ErrorMsg",
        hl_selection = "WarningMsg",
        hl_grey = "LineNr",
        flash_style = false,
        hl_flash = "ModeMsg",
        move_cursor = true,
        autoswap = true,
        debug = nil,
        hl_grey_priority = "1000",
      })
    end,
  },
  {
    "Wansmer/treesj",
    keys = {
      { "<leader>jt", ":TSJToggle<CR>", silent = true },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      use_default_keymaps = false,
      max_join_length = 999,
    },
  },
  {
    -- Visual mode selection powered by treesitter
    "gsuuon/tshjkl.nvim",
    opts = {
      select_current_node = false,
      keymaps = {
        toggle = "<leader>ct",
      },
    },
    config = true,
    event = "VeryLazy",
  },
  {
    "echasnovski/mini.move",
    event = "VeryLazy",
    config = function()
      require("mini.move").setup()
    end,
  },
  {
    "echasnovski/mini.ai",
    config = function()
      require("mini.ai").setup()
    end,
  },
}
