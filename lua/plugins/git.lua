local constants = require("config.constants")
return {
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = function(_, opt)
      opt.current_line_blame = true
      opt.current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 200,
        ignore_whitespace = false,
        relative_time = true,
      }
      opt.current_line_blame_formatter_opts = {
        relative_time = true,
      }

      -- opt.current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>"
      opt.sign_priority = 0
    end,
    keys = {
      { "<leader>gdt", ':lua require("gitsigns").diffthis()<CR>', desc = "[Git] Current line change diffview" },
      { "]g", ':lua require("gitsigns").next_hunk()<CR>', desc = "[Git] Next Git hunk" },
      { "[g", ':lua require("gitsigns").prev_hunk()<CR>', desc = "[Git] Next Git hunk" },
    },
  },
  {
    "NeogitOrg/neogit",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },

  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>gdc", ":DiffviewFileHistory %<CR>", desc = "[Git] view file history" },
      { "<leader>gdb", ":DiffviewFileHistory<CR>", desc = "[Git] view branch history" },
      { "<leader>gdq", ":DiffviewClose<CR>", desc = "[Git] Close current diffview" },
    },
  },
  {
    "aaronhallaert/advanced-git-search.nvim",
    event = "VeryLazy",
    config = function()
      -- optional: setup telescope before loading the extension
      require("telescope").setup({
        -- move this to the place where you call the telescope setup function
        extensions = {
          advanced_git_search = {
            diff_plugin = "diffview",
            telescope_theme = {
              show_custom_functions = {
                layout_config = constants.MINI_TS_LAYOUT_WH,
              },
            },
          },
        },
      })

      require("telescope").load_extension("advanced_git_search")
    end,
    dependencies = {
      "tpope/vim-rhubarb",
      "sindrets/diffview.nvim",
    },
  },
}
