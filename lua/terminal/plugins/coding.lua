local t_extensions = require("telescope").extensions

return {
  {
    "johmsalas/text-case.nvim",
    keys = {
      {
        "gai",
        function()
          local t_opts = {
            prompt_title = "Text Case - %s",
            layout_strategy = "cursor",
            layout_config = { cursor = { width = 40, height = 16 } },
          }

          local is_visual = vim.api.nvim_get_mode().mode == "v"
          if is_visual then
            local state = require("textcase.plugin.plugin").state
            local utils = require("textcase.shared.utils")

            state.telescope_previous_visual_region =
              utils.get_visual_region(0, true, nil, utils.get_mode_at_operator("v"))
            t_opts.prompt_title = string.format(t_opts.prompt_title, "Visual")
            t_extensions.textcase.visual_mode(t_opts)
            return
          end

          vim.lsp.buf_request(0, "textDocument/rename", vim.lsp.util.make_position_params(), function(err, result)
            local can_rename = result ~= nil
            local fn_name = can_rename and "normal_mode_lsp_change" or "normal_mode_quick_change"
            t_opts.prompt_title = string.format(t_opts.prompt_title, can_rename and "LSP" or "Quick")
            t_extensions.textcase[fn_name](t_opts)
          end)
        end,
        desc = "[Text Case] Smart Open",
        mode = { "n", "v" },
      },
    },
    config = function()
      require("textcase").setup({ default_keymappings_enabled = false })
      require("telescope").load_extension("textcase")
    end,
  },
  { "wellle/targets.vim", event = "User BufRead" },
  {
    "echasnovski/mini.surround",
    keys = {
      { "gza", desc = "Add surrounding", mode = { "n", "v" } },
      { "gzd", desc = "Delete surrounding" },
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
        keymaps = {},
        ignore_injected_langs = false,
        -- allow swaps across lines
        allow_interline_swaps = true,
        -- swaps interline siblings without separators (no recommended, helpful for swaps html-like attributes)
        interline_swaps_witout_separator = false,
      })
    end,
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
    event = "User BufRead",
    config = function()
      require("mini.move").setup()
    end,
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    opts = { useDefaultKeymaps = false },
    keys = {
      { "_gc", "<cmd>lua require('various-textobjs').multiCommentedLines()<CR>", mode = { "x", "o" } },
      { "im", "<cmd>lua require('various-textobjs').chainMember('inner')<CR>", mode = { "x", "o" } },
      { "am", "<cmd>lua require('various-textobjs').chainMember('outer')<CR>", mode = { "x", "o" } },
      { "ii", "<cmd>lua require('various-textobjs').indentation('inner', 'inner')<CR>", mode = { "x", "o" } },
      { "ir", "<cmd>lua require('various-textobjs').restOfIndentation()<CR>", mode = { "x", "o" } },
      { "iv", "<cmd>lua require('various-textobjs').value('inner')<CR>", mode = { "x", "o" } },
      { "ik", "<cmd>lua require('various-textobjs').key('inner')<CR>", mode = { "x", "o" } },
      { "iu", "<cmd>lua require('various-textobjs').url()<CR>", mode = { "x", "o" } },
    },
  },
  -- autopairs, autotag --
  {
    "windwp/nvim-autopairs",
    event = "User BufInsertEnter",
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
    event = "User BufInsertEnter",
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
  -- { "NMAC427/guess-indent.nvim", event = "User BufRead", config = true },
  {
    "vidocqh/auto-indent.nvim",
    event = "BufReadPre",
    opts = {
      indentexpr = function(lnum)
        return require("nvim-treesitter.indent").get_indent(lnum)
      end,
    },
  },
  -- 在 cmd 中输入整数后跳转到对应的行中
  { "nacro90/numb.nvim", event = "CmdlineEnter" },
  -- 加快日志创建速度。创建各种特定于语言的日志语句，例如变量、断言或时间测量的日志
  {
    "chrisgrieser/nvim-chainsaw",
    dependencies = { "prochri/telescope-all-recent.nvim" },
    opts = {
      logStatements = {
        messageLog = { nvim_lua = 'print("%s ")' },
        objectLog = { nvim_lua = 'print("%s %s: " .. vim.inspect(%s))' },
        variableLog = { nvim_lua = 'print("%s %s: " .. tostring(%s))' },
      },
    },
    keys = {
      {
        "<leader>pc",
        function()
          local log_fn_names = vim.tbl_filter(function(v)
            return v ~= "setup"
          end, vim.tbl_keys(require("chainsaw")))
          vim.ui.select(log_fn_names, {
            prompt = "[Chainsaw] Target Log",
          }, function(fn_name)
            if not fn_name then return end
            require("chainsaw")[fn_name]()
          end)
        end,
        desc = "[Chainsaw] Create Log",
        mode = { "n", "v", "x" },
      },
    },
  },
  {
    "chrisgrieser/nvim-recorder",
    opts = {},
    event = "User BufRead",
  },
}
