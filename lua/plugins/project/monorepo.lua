local constants = require("config.constants")

return {
  "imNel/monorepo.nvim",
  event = "VeryLazy",
  config = function()
    require("monorepo").setup()
  end,
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>fpm",
      function()
        require("telescope").extensions.monorepo.monorepo({
          layout_config = constants.MINI_TS_LAYOUT_WH,
        })
      end,
      desc = "[Monorepo] change cwd",
    },
  },
}
