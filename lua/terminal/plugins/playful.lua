local u = require("terminal.utils")

return {
  {
    "eandrju/cellular-automaton.nvim",
    keys = {
      { "<leader>fmk", "<cmd>CellularAutomaton make_it_rain<CR>", desc = "[CellularAutomaton] Make it rain" },
      { "<leader>fml", "<cmd>CellularAutomaton game_of_life<CR>", desc = "[CellularAutomaton] game of life" },
    },
  },

  -- {
  --   enabled = false,
  --   "folke/drop.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     theme = "stars",
  --     winblend = 0,
  --     max = u.basic.os_pick(150, 80),
  --     interval = u.basic.os_pick(80, 100),
  --     screensaver = 1000 * 60 * 10,
  --   },
  --   init = function()
  --     require("keymap-amend")("n", "<Esc>", function(original)
  --       if vim.g.drop_opened then
  --         require("drop").hide()
  --         vim.g.drop_opened = false
  --       end
  --       original()
  --     end)
  --   end,
  --   keys = {
  --     {
  --       "<leader>udt",
  --       function()
  --         require("drop")[vim.g.drop_opened and "hide" or "show"]()
  --         local theme = { "stars", "leaves", "snow", "xmas", "spring", "summer" }
  --         require("drop.config").options.theme = theme[math.random(#theme)]
  --         vim.g.drop_opened = not vim.g.drop_opened
  --       end,
  --       desc = "[Drop] Toogle",
  --     },
  --   },
  -- },

  -- { enabled = false, "tamton-aquib/zone.nvim", opts = { after = 3000000 } },

  -- {
  --   enabled = false,
  --   "ElPiloto/significant.nvim",
  --   lazy = true,
  --   keys = {
  --     {
  --       "<leader>fms",
  --       function()
  --         -- local significant = require("significant")
  --         -- local sprites = require("significant.sprites")
  --         -- local lnum = 10
  --         -- for animation_name, _ in pairs(sprites) do
  --         --   significant.start_animated_sign(lnum, animation_name, 100)
  --         --   lnum = lnum + 1
  --         -- end
  --       end,
  --     },
  --   },
  -- },
}
