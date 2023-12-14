local u = require("utils")
local constants = require("config.constants")

return {
  {
    "LintaoAmons/scratch.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>scce", ":ScratchEditConfig<cr>", desc = "sc - config edit" },
      { "<leader>scci", ":ScratchInitConfig<cr>", desc = "sc - config init" },
      { "<leader>scn", ":Scratch<cr>", desc = "sc - new scratch" },
      { "<leader>scN", ":ScratchWithName<cr>", desc = "sc - new scratch (named)" },
      { "<leader>sco", ":ScratchOpen<cr>", desc = "sc - open scratch" },
      { "<leader>scO", ":ScratchOpenFzf<cr>", desc = "sc - open scratch (fzf)" },
    },
  },
  {
    "coffebar/neovim-project",
    opts = function()
      local opts = {
        projects = u.basic.os_pick({
          "D:/project/cpp/*",
          "D:/project/nvim/*",
          "C:/Users/Administrator/.config/wezterm",
          "C:/Users/Administrator/AppData/Local/nvim",
        }, {
          "~/.config/nvim",
          "~/.config/wezterm",
          "~/Desktop/lilith/*",
          "~/Desktop/xlboy/*",
          "~/Desktop/xlboy/__open-source__/*",
        }),
      }

      if constants.IN_HOME then
        u.basic.append_arrays(opts.projects, {
          "~/Desktop/xlboy-project/__open-source__/*",
          "~/Desktop/xlboy-project/*",
        })
      end

      return opts
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "Shatur/neovim-session-manager", lazy = true },
    },
    init = function()
      require("telescope").load_extension("neovim-project")
    end,
    lazy = false,
    priority = 100,
  },
}
