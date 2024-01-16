return {
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = { enable_autocmd = false },
  },
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gc", mode = { "n", "v" }, desc = "Comment toggle linewise" },
      { "gb", mode = { "n", "v" }, desc = "Comment toggle blockwise" },
    },
    init = function()
      -- 移除按 o 换行时依然自带注释效果（与 VSCode 一致的行为）
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
        end,
      })
    end,
    opts = function()
      local commentstring_avail, commentstring = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      return commentstring_avail and commentstring and { pre_hook = commentstring.create_pre_hook() } or {}
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "User BufRead",
    opts = {
      keywords = {
        region = { color = "hint" },
        endregion = { color = "hint" },
      },
      highlight = {
        pattern = [[.*<(KEYWORDS)\s*:?]],
      },
    },
  },
}
