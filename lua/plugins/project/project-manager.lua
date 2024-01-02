local u = require("utils")
local constants = require("config.constants")

local resession = {
  save_cwd = function()
    require("resession").save(vim.fn.getcwd(), { dir = "dirsession" })
  end,
  load_cwd = function()
    pcall(function()
      require("resession").load(vim.fn.getcwd(), { dir = "dirsession" })
    end)
  end,
}

return {
  {
    "stevearc/resession.nvim",
    priority = 100,
    lazy = false,
    init = function()
      vim.api.nvim_create_autocmd("VimLeavePre", { callback = resession.save_cwd })
      vim.api.nvim_create_autocmd("VimEnter", { callback = resession.load_cwd })
    end,
    opts = {
      autosave = { enabled = true, interval = 60, notify = false },
      buf_filter = function(bufnr)
        local buftype = vim.bo[bufnr].buftype
        if buftype == "help" then return true end
        if buftype ~= "" and buftype ~= "acwrite" then return false end
        if vim.api.nvim_buf_get_name(bufnr) == "" then return false end

        return true
      end,
      extensions = { scope = {} }, -- add scope.nvim extension
    },
    keys = { { "<leader>S.", resession.load_cwd } },
  },
  {
    dir = constants.IS_WIN and "D:\\project\\nvim\\workspace-scanner.nvim" or nil,
    -- "xlboy/workspace-scanner.nvim",
    opts = {
      picker = {
        event = {
          on_select = function(entry)
            -- require("session_manager").save_current_session()
            resession.save_cwd()
            vim.cmd("BDelete! all")
            vim.cmd("cd " .. entry.source.dir)
            resession.load_cwd()
            -- require("session_manager").load_current_dir_session()
          end,
        },
      },
    },
    keys = {
      {
        "<leader>fpa",
        function()
          local scanner = require("workspace-scanner.scanner")
          local picker = require("workspace-scanner.picker")

          picker.show({
            type = "flat",
            source = scanner.scan({
              nvim = {
                my_config = {
                  p_dir = "C:/Users/Administrator/AppData/Local/nvim",
                  __extra__ = { level = 2 },
                },
                wezterm = "C:/Users/Administrator/.config/wezterm",
                { w_dir = "D:/project/nvim" },
                __extra__ = { level = 1 },
              },
              cpp = { w_dir = "D:/project/cpp" },
            }),
          })
        end,
      },
    },
  },
  {
    enabled = false,
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
  },
}
