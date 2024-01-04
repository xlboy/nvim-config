return {
  {
    "xlboy/text-case.nvim",
    keys = {
      { "ga.", ":TextCaseOpenTelescope<CR>", mode = { "n", "v" } },
      { "gaa", ":TextCaseOpenTelescopeQuickChange<CR>" },
      { "gai", ":TextCaseOpenTelescopeLSPChange<CR>" },
      { "gam", ":TextCaseOpenTelescopeQuickOrLSP<CR>" },
    },
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
    end,
  },
  { "wellle/targets.vim", event = "BufRead" },
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
          -- ["<C-.>"] = "swap_with_right",
          -- ["<C-,>"] = "swap_with_left",
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
    },
  },
  { "xlboy/swap-ternary.nvim" },
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
    "nguyenvukhang/nvim-toggler",
    opts = {
      inverses = {
        ["up"] = "down",
        ["Up"] = "Down",
        ["left"] = "right",
        ["Left"] = "Right",
        ["1"] = "0",
        ["true"] = "false",
        ["TRUE"] = "FALSE",
        ["True"] = "False",
        ["off"] = "on",
        ["OFF"] = "ON",
        ["yes"] = "no",
        ["Yes"] = "No",
        ["YES"] = "NO",
      },
      remove_default_keybinds = true,
    },
    keys = {
      {
        "<leader>jr",
        function()
          require("nvim-toggler").toggle()
        end,
        desc = "Toggle",
      },
    },
  },
  {
    "Wansmer/treesj",
    keys = { { "<leader>jt", ":TSJToggle<CR>", silent = true } },
    opts = { use_default_keymaps = false, max_join_length = 999 },
  },
  {
    "echasnovski/mini.move",
    event = "BufRead",
    config = function()
      require("mini.move").setup()
    end,
  },
  {
    "echasnovski/mini.ai",
    -- keys = {
    --   { "a", mode = { "x", "o" } },
    --   { "i", mode = { "x", "o" } },
    -- },
    event = "BufRead",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      -- register all text objects with which-key
      require("utils").lazy.on_load("which-key.nvim", function()
        ---@type table<string, string|table>
        local i = {
          [" "] = "Whitespace",
          ['"'] = 'Balanced "',
          ["'"] = "Balanced '",
          ["`"] = "Balanced `",
          ["("] = "Balanced (",
          [")"] = "Balanced ) including white-space",
          [">"] = "Balanced > including white-space",
          ["<lt>"] = "Balanced <",
          ["]"] = "Balanced ] including white-space",
          ["["] = "Balanced [",
          ["}"] = "Balanced } including white-space",
          ["{"] = "Balanced {",
          ["?"] = "User Prompt",
          _ = "Underscore",
          a = "Argument",
          b = "Balanced ), ], }",
          c = "Class",
          f = "Function",
          o = "Block, conditional, loop",
          q = "Quote `, \", '",
          t = "Tag",
        }
        local a = vim.deepcopy(i)
        for k, v in pairs(a) do
          a[k] = v:gsub(" including.*", "")
        end

        local ic = vim.deepcopy(i)
        local ac = vim.deepcopy(a)
        for key, name in pairs({ n = "Next", l = "Last" }) do
          i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
          a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
        end
        require("which-key").register({
          mode = { "o", "x" },
          i = i,
          a = a,
        })
      end)
    end,
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    -- TODO: 111
    opts = {
      useDefaultKeymaps = false,
    },
    keys = {
      { "_gc", "<cmd>lua require('various-textobjs').multiCommentedLines()<CR>", mode = { "x", "o" } },
      { "im", "<cmd>lua require('various-textobjs').chainMember('inner')<CR>", mode = { "x", "o" } },
      { "am", "<cmd>lua require('various-textobjs').chainMember('outer')<CR>", mode = { "x", "o" } },
      { "ii", "<cmd>lua require('various-textobjs').indentation('inner', 'inner')<CR>", mode = { "x", "o" } },
      { "ir", "<cmd>lua require('various-textobjs').restOfIndentation()<CR>", mode = { "x", "o" } },
    },
  },
  -- autopairs, autotag --
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      fast_wrap = {
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0,
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = { "xlboy/nvim-treesitter" },
    event = "InsertEnter",
    config = function()
      require("nvim-treesitter.configs").setup({
        autotag = {
          enable = true,
          enable_close_on_slash = false,
        },
      })
    end,
  },
  -- Auto Indent
  { "NMAC427/guess-indent.nvim", event = "BufRead", config = true },
  -- 在 cmd 中输入整数后跳转到对应的行中
  { "nacro90/numb.nvim", event = "CmdlineEnter" },
  -- 加快日志创建速度。创建各种特定于语言的日志语句，例如变量、断言或时间测量的日志
  {
    "chrisgrieser/nvim-chainsaw",
    keys = {
      {
        "<leader>tcm",
        "<cmd>lua require('chainsaw').messageLog()<CR>",
        desc = "[Chainsaw] Create Message Log",
        mode = { "n", "v" },
      },
      {
        "<leader>tcv",
        "<cmd>lua require('chainsaw').variableLog()<CR>",
        desc = "[Chainsaw] Create Variable Log",
        mode = { "n", "v" },
      },
      {
        "<leader>tco",
        "<cmd>lua require('chainsaw').objectLog()<CR>",
        desc = "[Chainsaw] Create Object Log",
        mode = { "n", "v" },
      },
      {
        "<leader>tcr",
        "<cmd>lua require('chainsaw').removeLogs()<CR>",
        desc = "[Chainsaw] Remove All Log",
        mode = { "n", "v" },
      },
    },
  },
}
