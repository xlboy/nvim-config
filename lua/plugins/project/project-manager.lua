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
    -- "xlboy/workspace-scanner.nvim",
    dir = u.basic.os_pick("D:\\project\\nvim\\workspace-scanner.nvim", "~/Desktop/xlboy/workspace-scanner.nvim"),
    event = "UIEnter",
    opts = {
      scanner = {
        source = u.basic.os_pick({
          li = { w_dir = "D:/project/li", __extra__ = { level = 3 } },
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
            my_config = { p_dir = "~/.config/nvim", __extra__ = { level = 9 } },
            wezterm_config = { p_dir = "~/.config/nvim" },
            __extra__ = { level = 1 },
            lazy = { w_dir = vim.fn.stdpath("data") .. "/lazy" },
          },
          li = { w_dir = "~/Desktop/lilith/", __extra__ = { level = 1 } },
          xlboy = {
            { w_dir = "~/Desktop/xlboy/" },
            open_source = { w_dir = "~/Desktop/xlboy/__open-source__/" },
          },
        }),
      },
      picker = {
        -- flat_opts = { separator = " 🌀 " },
        event = {
          on_select = function(entry)
            if is_valid_bufs() then resession.save_cwd() end
            require("close_buffers").delete({ type = "all" })
            vim.cmd("cd " .. entry.source.dir)
            resession.load_cwd()
            tint_refresh()
          end,
        },
      },
    },
    keys = {
      { "<leader>fpr", "<cmd>lua require('workspace-scanner').refresh()<cr>", desc = "[workspace-scanner] Refresh" },
      {
        "<leader>fpa",
        "<cmd>lua require('workspace-scanner').show_picker()<cr>",
        desc = "[workspace-scanner] Show Picker",
      },
    },
    config = function(_, opts)
      require("workspace-scanner").setup(opts)
      require("workspace-scanner").show_picker()
    end,
  },
}
