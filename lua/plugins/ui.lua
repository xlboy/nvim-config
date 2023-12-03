local utils = require("utils")

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("tokyonight").setup({
        -- transparent = true,
      })
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    config = function()
      local transparent = require("transparent")
      transparent.setup({
        extra_groups = {
          "NormalFloat",
          "NvimTreeNormal",
        },
      })
      transparent.clear_prefix("BufferLine")
      transparent.clear_prefix("NeoTree")
      transparent.clear_prefix("lualine")
    end,
    keys = {
      { "<leader>uT", "<cmd>TransparentToggle<CR>", desc = "Toggle transparency" },
    },
  },
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>udn",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
    init = function()
      utils.on_very_lazy(function()
        vim.notify = require("notify")
      end)
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },
  { "itchyny/vim-cursorword", event = "VeryLazy" },
  {
    "shellRaining/hlchunk.nvim",
    event = "UIEnter",
    init = function()
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, { pattern = "*", command = "EnableHL" })

      require("hlchunk").setup({
        chunk = {
          enable = true,
          use_treesitter = true,
          style = { { fg = "#73daca" } },
        },
        indent = {
          enable = false,
          chars = { "·" },
          use_treesitter = false,
          style = { {} },
        },
        blank = { enable = false },
        line_num = { enable = true, use_treesitter = true },
      })
    end,
  },
  {
    "utilyre/sentiment.nvim",
    event = "VeryLazy",
    opts = {
      pairs = { { "(", ")" }, { "[", "]" }, { "{", "}" }, { "<", ">" } },
    },
    init = function()
      vim.g.loaded_matchparen = 1
    end,
  },
  {
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy",
    config = true,
  },
}
