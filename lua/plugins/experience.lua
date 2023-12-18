local u = require("utils")

return {
  {
    "Pocco81/true-zen.nvim",
    event = "VeryLazy",
    keys = { { "<leader>tzn", ":TZNarrow<CR>", mode = { "v", "n" } } },
    -- init = function()
    --   require("keymap-amend")("n", "/", function(original)
    --     vim.g._true_zen_ = {}
    --     if vim.g._true_zen_.narrow then
    --       local cur_buf = vim.api.nvim_get_current_buf()
    --       if cur_buf == vim.g._true_zen_.buf then
    --         local v_lines = u.basic.get_visible_lines()
    --         local start_line = v_lines[1]
    --         local end_line = v_lines[#v_lines]
    --         local cmd_str = vim.cmd(string.format(":%s,%sg/buf/", start_line, end_line))
    --         -- 为什么会失败呢？
    --         vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd_str, true, false, true), "n", true)
    --         return
    --       end
    --     end
    --
    --     original()
    --   end)
    -- end,
    config = function()
      require("true-zen").setup({
        modes = {
          narrow = {
            folds_style = "invisible",
            run_ataraxis = false,
            callbacks = {
              open_pre = function()
                vim.g._true_zen_ = {
                  buf = vim.api.nvim_get_current_buf(),
                  narrow = true,
                }
              end,
              close_pre = function()
                vim.g._true_zen_ = {}
              end,
            },
          },
          ataraxis = {
            padding = { left = 13, right = 13 },
          },
        },
      })
    end,
  },
  {
    "AckslD/nvim-FeMaco.lua",
    lazy = true,
    config = function()
      require("femaco").setup()
    end,
  },
}
