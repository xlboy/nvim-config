local config = require("terminal.config.config")
local u = require("terminal.utils")

return {
  {
    "kevinhwang91/nvim-hlslens",
    event = "CmdlineEnter",
    dependencies = { "anuvyklack/keymap-amend.nvim" },
    keys = {
      { "n",  [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]] },
      { "N",  [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]] },
      { "*",  [[*<Cmd>lua require('hlslens').start()<CR>]] },
      { "#",  [[#<Cmd>lua require('hlslens').start()<CR>]] },
      { "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]] },
      { "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]] },
    },
    config = function()
      require("hlslens").setup()
      require("keymap-amend")("n", "<Esc>", function(original)
        if vim.v.hlsearch then vim.cmd("nohlsearch") end
        original()
      end)
    end,
  },
  {
    "utilyre/sentiment.nvim",
    event = "User BufRead",
    opts = {
      pairs = { { "(", ")" }, { "[", "]" }, { "{", "}" }, { "<", ">" } },
    },
    init = function()
      vim.g.loaded_matchparen = 1
    end,
  },
  {
    "echasnovski/mini.cursorword",
    event = "User BufRead",
    config = function()
      require("mini.cursorword").setup()
    end,
  },
  -- Automatically highlights other instances of the word under your cursor.
  -- This works with LSP, Treesitter, and regexp matching to find the other
  -- instances.
  {
    "RRethy/vim-illuminate",
    event = "User BufRead",
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = { providers = { "lsp", "treesitter", "regex" } },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
  },

  -- 非 focus 的窗口进行置灰
  {
    "levouh/tint.nvim",
    enabled = true,
    lazy = false,
    priority = 10, -- make sure to load this before all the other start plugins
    opts = {
      tint = -90,
      saturation = 0.6,
      window_ignore_function = function(winid)
        local buf = vim.api.nvim_win_get_buf(winid)
        local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
        if filetype == "" then return true end
        if vim.tbl_contains(config.ft_ignores, filetype) then return true end
      end,
    },
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "User BufRead",
    enabled = false,
    cmd = { "ColorizerToggle", "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers" },
    opts = { user_default_options = { tailwind = true } },
  },
  {
    "uga-rosa/ccc.nvim",
    cmd = { "CccPick", "CccConvert" },
    ft = { "typescriptreact" },
    opts = { highlighter = { auto_enable = true, lsp = true } },
  },
  -- 对指定字符进行高亮
  (function()
    local colors =
    { "#0c0d0e", "#e5c07b", "#7FFFD4", "#8A2BE2", "#FF4500", "#008000", "#0000FF", "#FFC0CB", "#FFF9E3", "#7d5c34" }
    local highlight_colors = {}
    for index, color in pairs(colors) do
      highlight_colors["color_" .. index - 1] = { color, "smart" }
    end

    return {
      "pocco81/high-str.nvim",
      event = "User BufRead",
      opts = {
        verbosity = 0,
        saving_path = "/tmp/highstr/",
        highlight_colors = highlight_colors,
      },
      keys = {
        { "<leader>hha", ":<c-u>HSHighlight ",      mode = "v", desc = "[high-str] add" },
        { "<leader>hhd", ":<c-u>HSRmHighlight<CR>", mode = "n", desc = "[high-str] delete" },
      },
    }
  end)(),
  -- 光标动画
  --[[ { "danilamihailov/beacon.nvim", event = "BufRead" } ]]

  -- 彩虹括号
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "User BufRead",
    config = function()
      require('rainbow-delimiters.setup').setup({
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterCyan',
          'RainbowDelimiterRed',
          'RainbowDelimiterViolet',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
        },
      })
    end
  }
}
