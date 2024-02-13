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
  -- require("tint").disable()
  -- require("tint").enable()
end

local function is_valid_bufs()
  local bufs = u.buffer.get_bufs()
  if #bufs == 0 then return false end

  local is_no_name = #bufs == 1 and u.buffer.is_noname(bufs[1])
  if is_no_name then return false end

  return true
end

return {
  {
    "stevearc/resession.nvim",
    priority = 100,
    lazy = false,
    init = function()
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          if is_valid_bufs() then
            -- u.buffer.delete_non_cwd()
            resession.save_cwd()
          end
        end,
      })
      -- vim.api.nvim_create_autocmd("VimEnter", { callback = resession.load_cwd })
    end,
    opts = {
      autosave = { enabled = false, interval = 10, notify = false },
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
        "<leader>..",
        function()
          resession.load_cwd()
          tint_refresh()
        end,
      },
    },
  },
  {
    "xlboy/workspace-scanner.nvim",
    -- dir = u.basic.os_pick("D:\\project\\nvim\\workspace-scanner.nvim", "~/Desktop/xlboy/workspace-scanner.nvim"),
    --- @type WS.Config
    opts = {
      scanner = {
        source = u.basic.os_pick({
          -- li = { w_dir = "D:/project/li", __extra__ = { level = 3 } },
          nvim = {
            my_config = { p_dir = "C:/Users/Administrator/AppData/Local/nvim", __extra__ = { level = 2 } },
            wezterm = "C:/Users/Administrator/.config/wezterm",
            lazy = { w_dir = vim.fn.stdpath("data") .. "/lazy" },
            { w_dir = "D:/project/nvim" },
            data = vim.fn.stdpath("data"),
            __extra__ = { level = 1 },
          },
          cpp = { w_dir = "D:/project/cpp" },
          web = { w_dir = "D:/project/web", __extra__ = { level = 2 } },
        }, {
          nvim = {
            my_config = { p_dir = "~/.config/nvim", __extra__ = { level = 9 } },
            wezterm_config = { p_dir = "~/.config/wezterm", __extra__ = { level = 9 } },
            __extra__ = { level = 1 },
            lazy = { w_dir = vim.fn.stdpath("data") .. "/lazy" },
            data = "~/.local/share/nvim",
            -- },
            --[[]]
          },
          li = { w_dir = "~/Desktop/lilith/" },
          xlboy = {
            { w_dir = "~/Desktop/xlboy/" },
            open_source = { w_dir = "~/Desktop/xlboy/__open-source__/" },
            ["cs-cheat"] = { w_dir = "~/Desktop/xlboy/cs-cheat/" },
          },
        }),
      },
      --- @type WS.Config.Picker
      picker = {
        events = {
          --- @param entry WS.Picker.SelectedEntry
          on_select = function(entry)
            if is_valid_bufs() then resession.save_cwd() end
            require("close_buffers").delete({ type = "all" })
            vim.cmd("cd " .. entry.source.dir)
            resession.load_cwd()
            tint_refresh()
          end,
        },
        tree_opts = {
          workspace = {
            history_recent = {
              icon = false,
            },
          },
          keymaps = {
            back = "<Left>",
            forward = "<Right>",
          },
        },
      },
    },
    keys = {
      { "<leader>fpo", "<cmd>lua require('workspace-scanner').refresh()<cr>", desc = "[workspace-scanner] Refresh" },
      {
        "<leader>fpr",
        function()
          require("workspace-scanner").show_picker({
            show_history_only = true,
            telescope = {
              opts = {
                prompt_title = "Recent Projects (Flat)",
                layout_config = { width = 90, height = 25 },
              },
            },
            history = {
              recent = { icon = false },
            },
          })
        end,
        desc = "[workspace-scanner] Show Recent",
      },
      {
        "<leader>fpa",
        function()
          require("workspace-scanner").show_picker({
            mode = "tree",
            show_history_only = false,
            telescope = {
              opts = {
                prompt_title = "All Projects (Tree)",
                layout_config = { width = 90, height = 25 },
              },
            },
          })
        end,
        desc = "[workspace-scanner] Show Picker",
      },
    },
  },
  {
    "notjedi/nvim-rooter.lua",
    main = "nvim-rooter",
    cmd = { "Rooter" },
    config = { manual = true },
  },
}
