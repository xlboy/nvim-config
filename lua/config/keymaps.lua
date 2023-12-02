local set = vim.api.nvim_set_keymap
local utils = require("utils")
local t_extensions = require("telescope").extensions
utils.set_mappings({
  n = {
    ["'d"] = { '"0d' },
    ["'c"] = { '"0c' },
    ["<S-w>"] = { "3w" },
    ["<S-b>"] = { "3b" },
    ["<leader>jo"] = { "<CMD>join<CR>" },
    ["<leader>all"] = { "ggVG" },
    ["<S-h>"] = { "^" },
    ["<S-l>"] = { "$" },
    ["<S-k>"] = { "8k" },
    ["<S-j>"] = { "8j" },
    ["<S-u>"] = { "20k" },
    ["<S-d>"] = { "20j" },
    ["<C-q>"] = { "<cmd>qa!<cr>" },
    ["<leader>q"] = { "<cmd>confirm q<cr>" },
    ["<leader>w"] = { "<cmd>w<cr>" },
    ["<C-h>"] = { "<cmd>wincmd h<cr>" },
    ["<C-j>"] = { "<cmd>wincmd j<cr>" },
    ["<C-k>"] = { "<cmd>wincmd k<cr>" },
    ["<C-l>"] = { "<cmd>wincmd l<cr>" },
    ["|"] = { "<cmd>vsplit<cr>" },
    ["\\"] = { "<cmd>split<cr>" },
    ["<leader>fpr"] = {
      function()
        t_extensions["neovim-project"].history({
          layout_config = { width = 110, height = 25 },
        })
      end,
    },
    ["<leader>fpa"] = {
      function()
        t_extensions["neovim-project"].discover({
          layout_config = { width = 110, height = 25 },
        })
      end,
    },
  },
  v = {
    ["y"] = { '"+ygv<esc>' },
    ["<S-h>"] = { "^" },
    ["<S-l>"] = { "$" },
    ["<S-k>"] = { "8k" },
    ["<S-j>"] = { "8j" },
    ["<S-u>"] = { "20k" },
    ["<S-d>"] = { "20j" },
    ["'d"] = { '"0d' },
    ["'c"] = { '"0c' },
    ["<S-w>"] = { "3w" },
    ["<S-b>"] = { "3b" },
  },
  i = {
    ["jk"] = { "<esc>" },
    ["kj"] = { "<esc>" },
  },
})
