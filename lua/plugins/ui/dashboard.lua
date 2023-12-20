local u = require("utils")
local logo = {}

return {
  {
    "folke/drop.nvim",
    event = "VeryLazy",
    opts = {
      theme = "stars",
      winblend = 0,
      max = u.basic.os_pick(150, 80),
      interval = u.basic.os_pick(80, 100),
      screensaver = 1000 * 60 * 10,
    },
    init = function()
      require("keymap-amend")("n", "<Esc>", function(original)
        if vim.g.drop_opened then
          require("drop").hide()
          vim.g.drop_opened = false
        end
        original()
      end)
    end,
    keys = {
      {
        "<leader>udt",
        function()
          require("drop")[vim.g.drop_opened and "hide" or "show"]()
          local theme = { "stars", "leaves", "snow", "xmas", "spring", "summer" }
          require("drop.config").options.theme = theme[math.random(#theme)]
          vim.g.drop_opened = not vim.g.drop_opened
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
