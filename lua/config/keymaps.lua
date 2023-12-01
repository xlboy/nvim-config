local set = vim.api.nvim_set_keymap

function default()
  set("n", "'d", '"0d', {})
  set("n", "'c", '"0c', {})
  set("n", "<S-w>", "3w", {})
  set("n", "<S-b>", "3b", {})
  set("n", "<leader>jo", "<CMD>join<CR>", {})
  set("n", "<leader>all", "ggVG", {})
  set("n", "<S-h>", "^", {})
  set("n", "<S-l>", "$", {})
  set("n", "<S-k>", "8k", {})
  set("n", "<S-j>", "8j", {})
  set("n", "<S-u>", "20k", {})
  set("n", "<S-d>", "20j", {})
  set("n", "<C-q>", "<CMD>q!<CR>", {})
  set("n", "<leader>q", "<CMD>q!<CR>", {})

  set("v", "y", '"+ygv<esc>', {})
  set("v", "<S-h>", "^", {})
  set("v", "<S-l>", "$", {})
  set("v", "<S-k>", "8k", {})
  set("v", "<S-j>", "8j", {})
  set("v", "<S-u>", "20k", {})
  set("v", "<S-d>", "20j", {})
  set("v", "'d", '"0d', {})
  set("v", "'c", '"0c', {})
  set("v", "<S-w>", "3w", {})
  set("v", "<S-b>", "3b", {})


  set("i", "jk", "<esc>", {})
  set("i", "kj", "<esc>", {})
end

default()
