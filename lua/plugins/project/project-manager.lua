local u = require("utils")
local constants = require("config.constants")

-- return {
--   "gnikdroy/projections.nvim",
--   branch = "pre_release",
--   dependencies = { "prochri/telescope-all-recent.nvim" },
--   config = function()
--     require("projections").setup({
--       workspaces = {
--         "~/.config",
--         "~/Desktop/lilith/",
--         "~/Desktop/xlboy/",
--         "~/Desktop/xlboy/__open-source__/",
--         vim.fn.stdpath("data") .. "/lazy/",
--       },
--       patterns = { ".git", "package.json", ".clangd", "README.md", "stylua.toml" }, -- Default patterns to use if none were specified. These are NOT regexps.
--     })
--     require("telescope").load_extension("projections")
--   end,
--   keys = {
--     {
--       "<leader>fpa",
--       function()
--         require("telescope").extensions.projections.projections({
--           sorter = nil,
--           layout_config = constants.MINI_TS_LAYOUT_WH,
--         })
--       end,
--       desc = "[Project] All record",
--     },
--   },
-- }

return {
  "coffebar/neovim-project",
  lazy = false,
  priority = 100,
  opts = function()
    local opts = {
      projects = u.basic.os_pick({
        "D:/project/cpp/*",
        "D:/project/nvim/*",
        "D:/project/li/*",
        "C:/Users/Administrator/.config/wezterm",
        "C:/Users/Administrator/AppData/Local/nvim",
      }, {
        "~/.config/nvim",
        "~/.config/wezterm",
        "~/Desktop/lilith/*",
        "~/Desktop/xlboy/*",
        "~/Desktop/xlboy/__open-source__/*",
      }),
      last_session_on_startup = false,
    }

    u.basic.append_arrays(opts.projects, { vim.fn.stdpath("data") .. "/lazy/*" })

    if constants.IN_HOME then
      u.basic.append_arrays(opts.projects, {
        "~/Desktop/xlboy-project/__open-source__/*",
        "~/Desktop/xlboy-project/*",
      })
    end

    return opts
  end,
  dependencies = { { "nvim-lua/plenary.nvim" }, { "Shatur/neovim-session-manager", lazy = true } },
  init = function()
    require("telescope").load_extension("neovim-project")
  end,
  keys = {
    {
      "<leader>fpa",
      function()
        require("telescope").extensions["neovim-project"].discover({
          layout_config = constants.MINI_TS_LAYOUT_WH,
        })
      end,
      desc = "[Project] All record",
    },
    {
      "<leader>fpr",
      function()
        require("telescope").extensions["neovim-project"].history({
          layout_config = constants.MINI_TS_LAYOUT_WH,
        })
      end,
      desc = "[Project] Recent history",
    },
  },
}
