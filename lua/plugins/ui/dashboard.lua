local u = require("utils")
local logo = {}

return {
  {
    "folke/drop.nvim",
    lazy = false,
    opts = { theme = "stars", winblend = 0, max = 150, interval = 80 },
    config = function(_, opts)
      require("drop").setup(opts)
      vim.g.drop_opened = false
      local callback = function()
        local opened_bufs = u.basic.get_opened_buffers()
        if #opened_bufs == 1 then
          local buf_name = vim.api.nvim_buf_get_name(opened_bufs[1])
          local is_no_name = #buf_name == 0
          if is_no_name and vim.g.drop_opened == false then
            vim.cmd([[hi NormalFroat guifg=#c0caf5]])
            require("drop").show()
            vim.g.drop_opened = true
          end
        else
          if vim.g.drop_opened == true then
            vim.cmd([[hi NormalFroat guifg=#c0caf5 guibg=#1f2335]])
            require("drop").hide()
            vim.g.drop_opened = false
          end
        end
      end

      local has_init = false
      vim.api.nvim_create_autocmd("User", {
        pattern = "SessionLoadPost",
        callback = function()
          if has_init == false then
            callback()
            has_init = true
            return
          end
        end,
      })

      -- vim.api.nvim_create_autocmd({ "BufEnter", "BufLeave" }, {
      --   pattern = "*",
      --   callback = function()
      --     callback()
      --   end,
      -- })
    end,
    keys = {
      -- { "<leader>udh", ":lua require('drop').hide()<CR>" },
      -- { "<leader>uds", ":lua require('drop').show()<CR>" },
      {
        "<leader>udt",
        function()
          if vim.g.drop_opened == true then
            require("drop").hide()
            vim.g.drop_opened = false
          else
            require("drop").show()
            vim.g.drop_opened = true
          end
        end,
        desc = "[Drop] Toogle",
      },
    },
  },
  {
    "goolord/alpha-nvim",
    enabled = false,
    event = "VeryLazy",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = logo["mm"]
      dashboard.section.header.opts.hl = "DashboardHeader"
      dashboard.section.footer.opts.hl = "DashboardFooter"

      dashboard.section.buttons.val = {}

      dashboard.config.layout = {
        { type = "padding", val = vim.fn.max({ 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) }) },
        dashboard.section.header,
        { type = "padding", val = 5 },
        dashboard.section.buttons,
        { type = "padding", val = 3 },
        dashboard.section.footer,
      }
      dashboard.config.opts.noautocmd = true
      return dashboard
    end,
    config = function(_, opts)
      require("alpha").setup(opts.config)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        desc = "Add Alpha dashboard footer",
        once = true,
        callback = function()
          local stats = require("lazy").stats()
          local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
          opts.section.footer.val = { "Nvim loaded " .. stats.count .. " plugins  in " .. ms .. "ms" }
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
    keys = {
      {
        "<leader>h",
        function()
          require("alpha").start(false, require("alpha").default_config)
        end,
        desc = "Home Screen",
      },
    },
  },
}
