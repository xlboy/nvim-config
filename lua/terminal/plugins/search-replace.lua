return {
  {
    "nvim-pack/nvim-spectre",
    enabled = true,
    opts = {
      mapping = { ["send_to_qf"] = { map = "<leader>o" } },
    },
    keys = {
      { "<leader>sr", desc = "[Spectre] ..." },
      {
        "<leader>srf",
        '<esc>:lua require("spectre").open_file_search()<CR>',
        mode = { "n", "x" },
        desc = "[Spectre] Search and replace - open_file_search",
      },
      {
        "<leader>srv",
        '<esc>:lua require("spectre").open_visual()<CR>',
        mode = { "n", "x" },
        desc = "[Spectre] Search and replace - open_visual",
      },
    },
  },
  {
    "cshuaimin/ssr.nvim",
    enabled = true,
    keys = {
      {
        "<leader>sR",
        function()
          require("ssr").open()
        end,
        desc = "[Ssr] Search and replace",
        mode = { "n", "x" },
      },
    },
    opts = {
      border = "rounded",
      min_width = 50,
      min_height = 5,
      max_width = 120,
      max_height = 25,
      keymaps = {
        close = "q",
        next_match = "n",
        prev_match = "N",
        replace_confirm = "<cr>",
        replace_all = "<leader><cr>",
      },
    },
  },
  -- {
  --   "MagicDuck/grug-far.nvim",
  --   config = function()
  --     require("grug-far").setup()
  --   end,
  --   keys = {
  --     { "<leader>sr", ":GrugFar<CR>", desc = "[grug-far] Search and replace", mode = { "n", "x" } },
  --   },
  -- },
}
