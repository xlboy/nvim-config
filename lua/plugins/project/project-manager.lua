local u = require("utils")
local config = require("config.config")

local resession = {
  save_cwd = function()
    require("resession").save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
  end,
  load_cwd = function()
    pcall(function()
      require("resession").load(vim.fn.getcwd(), { dir = "dirsession", notify = false })
    end)
  end,
}

local function tint_refresh()
  require("tint").disable()
  require("tint").enable()
end

return {
  {
    "stevearc/resession.nvim",
    priority = 100,
    lazy = false,
    init = function()
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          local bufs = u.buffer.get_bufs()
          local is_no_name = #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == ""
          if is_no_name then return end
          resession.save_cwd()
        end,
      })
      -- vim.api.nvim_create_autocmd("VimEnter", { callback = resession.load_cwd })
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
    keys = {
      {
        "<leader>S.",
        function()
          resession.load_cwd()
          tint_refresh()
        end,
      },
    },
  },
  {
    dir = config.IS_WIN and "D:\\project\\nvim\\workspace-scanner.nvim" or "~/Desktop/xlboy/workspace-scanner.nvim",
    -- "xlboy/workspace-scanner.nvim",
    opts = {
      picker = {
        flat_opts = { separator = " 🌀 " },
        event = {
          on_select = function(entry)
            resession.save_cwd()
            vim.cmd("BDelete! all")
            vim.cmd("cd " .. entry.source.dir)
            resession.load_cwd()
            tint_refresh()
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

          local source = u.basic.os_pick({
            nvim = {
              my_config = { p_dir = "C:/Users/Administrator/AppData/Local/nvim", __extra__ = { level = 2 } },
              wezterm = "C:/Users/Administrator/.config/wezterm",
              lazy = { w_dir = vim.fn.stdpath("data") .. "/lazy" },
              { w_dir = "D:/project/nvim" },
              __extra__ = { level = 1 },
            },
            cpp = { w_dir = "D:/project/cpp" },
          }, {
            nvim = {
              my_config = { p_dir = "~/.config/nvim", __extra__ = { level = 1 } },
              wezterm_config = { p_dir = "~/.config/nvim" },
              __extra__ = { level = 1 },
            },
            li = { w_dir = "~/Desktop/lilith/" },
            xlboy = {
              { w_dir = "~/Desktop/xlboy/" },
              open_source = { w_dir = "~/Desktop/xlboy/__open-source__/" },
            },
          })

          picker.show({
            type = "flat",
            source = scanner.scan(source),
            telescope_opts = {
              layout_config = { height = 25, width = 110 },
            },
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

      if config.IN_HOME then
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
            layout_config = config.MINmini_ts_layout_wh,
          })
        end,
        desc = "[Project] All record",
      },
      {
        "<leader>fpr",
        function()
          require("telescope").extensions["neovim-project"].history({
            layout_config = config.MINmini_ts_layout_wh,
          })
        end,
        desc = "[Project] Recent history",
      },
    },
  },
}
