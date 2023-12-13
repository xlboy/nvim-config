return {
  {
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy",
    keys = {
      { "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]] },
      { "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]] },
      { "*", [[*<Cmd>lua require('hlslens').start()<CR>]] },
      { "#", [[#<Cmd>lua require('hlslens').start()<CR>]] },
      { "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]] },
      { "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]] },
    },
    init = function()
      local nvim_hlslens_ns = vim.api.nvim_create_namespace("custom.nvim-hlslens")
      vim.on_key(function(char)
        local is_normal = vim.api.nvim_get_mode()["mode"] == "n"
        if is_normal then
          local cur_key = vim.fn.keytrans(char)
          if cur_key == "<Esc>" then vim.cmd([[nohlsearch]]) end
        end
      end, nvim_hlslens_ns)
    end,
    config = true,
  },
  {
    "nvim-pack/nvim-spectre",
    event = "VeryLazy",
    opts = {
      mapping = { ["send_to_qf"] = { map = "<leader>o" } },
    },
    keys = {
      { "<leader>sr", desc = "[Spectre] prefix (...)" },
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
    event = "VeryLazy",
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
