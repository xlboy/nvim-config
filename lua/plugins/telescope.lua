return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        enabled = vim.fn.executable("make") == 1,
        build = "make",
      },
      {
        "nvim-telescope/telescope-ui-select.nvim",
        event = "VeryLazy",
        config = function()
          require("telescope").load_extension("ui-select")
          require("telescope").setup({
            extensions = {
              ["ui-select"] = {
                layout_config = { width = 70, height = 15 },
              },
            },
          })
        end,
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
        },
        mappings = {
          i = {
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
          },
          n = { q = actions.close },
        },
      }
    end,
    cmd = "Telescope",
    keys = {
      { "<leader>/", ":Telescope live_grep<CR>", mode = "n" },
      { "<leader>ff", ":Telescope find_files<CR>", mode = "n" },
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
        mode = { "n" },
      },
    },
  },
  {
    "xlboy/telescope-recent-files",
    event = "VeryLazy",
    config = function() require("telescope").load_extension("recent_files") end,
    dependencies = { "kkharji/sqlite.lua" },
    keys = {
      {
        "<leader><leader>",
        function()
          local t_extensions = require("telescope").extensions
          t_extensions.recent_files.pick({
            only_cwd = true,
            previewer = false,
            layout_config = { width = 110, height = 25 },
          })
        end,
        mode = "n",
      },
    },
  },
  {
    "Marskey/telescope-sg",
    event = "VeryLazy",
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
    "coffebar/neovim-project",
    opts = {
      projects = {
        "~/.config/*",
        "~/Desktop/lilith/*",
        "~/Desktop/xlboy/*",
        "~/Desktop/xlboy/__open-source__/*",
        "~/Desktop/xlboy-project/__open-source__/*",
        "~/Desktop/xlboy-project/*",
        "D:\\project\\cpp\\*",
        "D:\\project\\nvim\\*",
        "C:\\Users\\Administrator\\.config\\*",
        "C:\\Users\\Administrator\\AppData\\Local\\nvim",
      },
    },
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "Shatur/neovim-session-manager", lazy = true },
    },
    init = function() require("telescope").load_extension("neovim-project") end,
    lazy = false,
    priority = 100,
  },
}
