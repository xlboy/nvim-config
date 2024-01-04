local config = require("config.config")
local t_builtin = require("telescope.builtin")

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        enabled = vim.fn.executable("make") == 1,
        build = "make",
      },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55 },
            vertical = { mirror = false },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          winblend = 20,
        },
        mappings = {
          i = {
            ["<C-h>"] = actions.preview_scrolling_left,
            ["<C-l>"] = actions.preview_scrolling_right,
            ["<C-Down>"] = actions.cycle_history_next,
            ["<C-Up>"] = actions.cycle_history_prev,
          },
          n = { q = actions.close },
        },
      }
    end,
    cmd = "Telescope",
    keys = {
      { "<leader>/", ":Telescope live_grep<CR>" },
      {
        "<leader>ff",
        function()
          t_builtin.find_files({
            layout_config = config.mini_ts_layout_wh,
            previewer = false,
          })
        end,
      },
      {
        "<leader>fc",
        function()
          t_builtin.current_buffer_fuzzy_find()
        end,
      },
      {
        "<leader>,",
        function()
          t_builtin.buffers({
            previewer = false,
            layout_config = { width = 70, height = 25 },
            path_display = function(opts, path)
              local tail = require("telescope.utils").path_tail(path)
              local text = string.format("%s (%s)", tail, vim.fn.fnamemodify(path, ":h"))
              local cols = { {
                { 1, #tail },
                "Constant",
              } }
              return text, cols
            end,
          })
        end,
      },
    },
  },
  {
    "xlboy/function-picker.nvim",
    lazy = true,
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      {
        "<leader>fns",
        function()
          require("function-picker").show({
            deep = {
              mode = "flat",
              tree_contour_opts = { indent = 2 },
              flat_opts = { space_character = " 🌀 " },
            },
          })
        end,
      },
    },
  },
  {
    "prochri/telescope-all-recent.nvim",
    dependencies = { "FeiyouG/commander.nvim" },
    lazy = true,
    -- event = "VeryLazy",
    config = function()
      require("telescope-all-recent").setup({
        database = {
          folder = vim.fn.stdpath("data"),
          file = "telescope-all-recent.sqlite3",
          max_timestamps = 10,
        },
        debug = false,
        scoring = {
          recency_modifier = { -- also see telescope-frecency for these settings
            [1] = { age = 240, value = 100 }, -- past 4 hours
            [2] = { age = 1440, value = 80 }, -- past day
            [3] = { age = 4320, value = 60 }, -- past 3 days
            [4] = { age = 10080, value = 40 }, -- past week
            [5] = { age = 43200, value = 20 }, -- past month
            [6] = { age = 129600, value = 10 }, -- past 90 days
          },
          -- how much the score of a recent item will be improved.
          boost_factor = 0.0001,
        },
        default = {
          disable = true, -- disable any unkown pickers (recommended)
          use_cwd = true, -- differentiate scoring for each picker based on cwd
          sorting = "recent", -- sorting: options: 'recent' and 'frecency'
        },
        pickers = { -- allows you to overwrite the default settings for each picker
          man_pages = { -- enable man_pages picker. Disable cwd and use frecency sorting.
            disable = false,
            use_cwd = false,
            sorting = "frecency",
          },
          ["commander#commander"] = { disable = false, use_cwd = false, sorting = "recent" },
        },
      })
    end,
  },
  {
    "xlboy/telescope-recent-files",
    config = function()
      require("telescope").load_extension("recent_files")
    end,
    dependencies = { "kkharji/sqlite.lua" },
    keys = {
      {
        "<leader><leader>",
        function()
          local t_extensions = require("telescope").extensions
          t_extensions.recent_files.pick({
            only_cwd = true,
            previewer = false,
            layout_config = config.mini_ts_layout_wh,
          })
        end,
      },
    },
  },
  {
    "Marskey/telescope-sg",
    config = function()
      require("telescope").load_extension("ast_grep")
      require("telescope").setup({
        extensions = {
          ast_grep = {
            command = { "sg", "--json=stream" }, -- must have --json=stream
            grep_open_files = false, -- search in opened files
            lang = nil, -- string value, specify language for ast-grep `nil` for default
          },
        },
      })
    end,
    keys = {
      { "<leader>fsg", "<CMD>Telescope ast_grep<CR>", desc = "Telescope ast_grep" },
    },
  },
  {
    "piersolenski/telescope-import.nvim",
    config = function()
      require("telescope").setup({
        extensions = {
          import = { layout_config = config.mini_ts_layout_wh },
        },
      })
      require("telescope").load_extension("import")
    end,
    keys = { { "<leader>tsi", ":Telescope import<CR>" } },
  },
}
