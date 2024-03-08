local set = vim.api.nvim_set_keymap
local vsc = {
  fold = function()
    set("n", "za", "<Cmd>call VSCodeNotify('editor.toggleFold')<CR>", {})
    set("n", "zR", "<Cmd>call VSCodeNotify('editor.unfoldAll')<CR>", {})
    set("n", "zM", "<Cmd>call VSCodeNotify('editor.foldAll')<CR>", {})
    set("n", "zoo", "<Cmd>call VSCodeNotify('editor.unfold')<CR>", {})
    set("n", "<CR>", "<Cmd>call VSCodeNotify('editor.unfold')<CR>", {})
    set("n", "zO", "<Cmd>call VSCodeNotify('editor.unfoldRecursively')<CR>", {})
    set("n", "zcc", "<Cmd>call VSCodeNotify('editor.fold')<CR>", {})
    set("n", "zca", "<Cmd>call VSCodeNotify('editor.foldRecursively')<CR>", {})

    set("n", "z1", "<Cmd>call VSCodeNotify('editor.foldLevel1')<CR>", {})
    set("n", "z2", "<Cmd>call VSCodeNotify('editor.foldLevel2')<CR>", {})
    set("n", "z3", "<Cmd>call VSCodeNotify('editor.foldLevel3')<CR>", {})
    set("n", "z4", "<Cmd>call VSCodeNotify('editor.foldLevel4')<CR>", {})
    set("n", "z5", "<Cmd>call VSCodeNotify('editor.foldLevel5')<CR>", {})
    set("n", "z6", "<Cmd>call VSCodeNotify('editor.foldLevel6')<CR>", {})
    set("n", "z7", "<Cmd>call VSCodeNotify('editor.foldLevel7')<CR>", {})
  end,
  window = function()
    set("n", "<leader>cc", "<Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>", {})
    set("n", "<leader>ca", "<Cmd>call VSCodeNotify('workbench.action.closeAllEditors')<CR>", {})
    set("n", "{", "<Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>", {
      noremap = true,
    })
    set("n", "}", "<Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>", {
      noremap = true,
    })
    set("n", "<leader>kl", "<Cmd>call VSCodeNotify('workbench.action.focusRightGroup')<CR>", {
      noremap = true,
    })
    set("n", "<leader>kh", "<Cmd>call VSCodeNotify('workbench.action.focusLeftGroup')<CR>", {
      noremap = true,
    })
  end,
  base = function()
    set("n", "<leader>cf", "<Cmd>call VSCodeNotify('editor.action.formatDocument')<CR>", {})
    set("n", "<leader>w", "<Cmd>call VSCodeNotify('workbench.action.files.save')<CR>", {
      noremap = true,
      silent = true,
    })
  end,
}

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
  
  set('n', "<leader><leader>", "<Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>", {})
  set('n', "<leader>pp", "<Cmd>call VSCodeNotify('workbench.action.showCommands')<CR>", {})

  -- set("v", "y", '"+ygv<esc>', {})
  -- set("x", "y", '"+ygv<esc>', {})
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
end

vsc.fold()
vsc.window()
vsc.base()
default()
