local config = require("config.config")

return {
  "imNel/monorepo.nvim",
  commit = "256a302900d6af6e032f1f2bf4f2407bd4569fe8",
  config = function()
    require("monorepo").setup()
  end,
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>fpm",
      function()
        require("telescope").extensions.monorepo.monorepo({
          layout_config = config.mini_ts_layout_wh,
        })
      end,
      desc = "[Monorepo] change cwd",
    },
  },
}
