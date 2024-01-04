return {
  {
    "kevinhwang91/nvim-hlslens",
    event = "CmdlineEnter",
    dependencies = { "anuvyklack/keymap-amend.nvim" },
    keys = {
      { "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]] },
      { "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]] },
      { "*", [[*<Cmd>lua require('hlslens').start()<CR>]] },
      { "#", [[#<Cmd>lua require('hlslens').start()<CR>]] },
      { "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]] },
      { "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]] },
    },
    init = function()
      require("keymap-amend")("n", "<Esc>", function(original)
        if vim.v.hlsearch then vim.cmd("nohlsearch") end
        original()
      end)
    end,
    config = true,
  },
  {
    "nvim-pack/nvim-spectre",
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
}
