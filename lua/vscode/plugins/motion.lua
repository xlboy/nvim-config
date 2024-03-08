local u = require("vscode.utils")

return {
  {
    "folke/flash.nvim",
    ---@type Flash.Config
    opts = {
      label = { uppercase = false },
      modes = {
        search = { enabled = false },
        char = { enabled = false, multi_line = false },
      },
    },
    keys = {
      -- {
      --   "s",
      --   mode = { "n", "v", "o" },
      --   "<cmd>lua require('flash').jump({ search = { multi_window = false } })<CR>",
      --   desc = "Flash",
      -- },
      { "<leader>ssv", "<cmd>lua require('flash').treesitter_search()<CR>", desc = "Flash treesitter_search" },
      { "<leader>sv", "<cmd>lua require('flash').treesitter()<CR>", desc = "Flash treesitter" },
    },
  },
  {
    "ggandor/flit.nvim",
    event = "User BufRead",
    commit = "f4e9af572a62c808c8de214da672f2a115a98c35",
    config = function()
      require("flit").setup({ labeled_modes = "nx", multiline = false, opts = {} })
    end,
    dependencies = {
      { "ggandor/leap.nvim", commit = "208b0e5ae9f34f7cea4fdf97acb91429c346e250" },
      "tpope/vim-repeat",
    },
  },
  {
    "chaoren/vim-wordmotion",
    event = "User BufRead",
    init = function()
      vim.g.wordmotion_prefix = ";"
    end,
  },
  {
    "xlboy/nvim-spider",
    event = "BufRead",
    opts = { skipInsignificantPunctuation = true },
    keys = {
      { "W", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "x" } },
      { "B", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "x" } },
    },
  },
  {
    "gsuuon/tshjkl.nvim",
    keys = { { "<leader>ct", desc = "Toggle tshjkl" } },
    opts = {
      select_current_node = false,
      keymaps = { toggle = "<leader>ct" },
    },
  },
  {
    "xlboy/node-edge-toggler.nvim",
    init = function()
      local cmd = "<cmd>lua require('node-edge-toggler').toggle()<CR>"
      vim.api.nvim_create_autocmd({ "BufEnter" }, {
        pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.md", "*.json", "*.lua", "*.cpp", "*.c", "*.py", "*.java" },
        callback = function(ev)
          vim.api.nvim_buf_set_keymap(ev.buf, "n", "%", cmd, { noremap = true, silent = true })
        end,
      })
    end,
  },
  {
    "smoka7/hop.nvim",
    keys = {
      { "s", "<cmd>HopWord<CR>", mode = { "n", "v" } },
      { ";l", "<cmd>HopLineStart<CR>", mode = { "n", "v" } },
      {
        ";f",
        function()
          require("hop").hint_words({ current_line_only = true })
        end,
        mode = { "n", "v" },
      },
    },
    config = function()
      require("hop").setup()
      vim.api.nvim_command("highlight HopNextKey1 cterm=bold gui=bold guifg=#ff007c")
      vim.api.nvim_command("highlight HopNextKey2 cterm=bold gui=bold guifg=#ff007c")
    end,
  },
  {
    "AgusDOLARD/backout.nvim",
    opts = {},
    keys = {
      { "<C-b><C-b>", "<cmd>lua require('backout').back()<cr>", mode = { "i", "n" } },
      { "<C-b><C-o>", "<cmd>lua require('backout').out()<cr>", mode = { "i", "n" } },
    },
  },
  {
    "RRethy/vim-illuminate",
    event = "User BufRead",
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = { providers = { "treesitter", "regex" } },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },
}
