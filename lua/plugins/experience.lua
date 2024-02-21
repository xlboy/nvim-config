local u = require("utils")

return {
  {
    "Pocco81/true-zen.nvim",
    keys = function()
      local buf_ranges = {} --- @type table<string, integer[]>

      require("keymap-amend")("n", "/", function(original)
        local bufnr = vim.api.nvim_get_current_buf()
        if not buf_ranges[bufnr] then return original() end

        local s_line, e_line = unpack(buf_ranges[bufnr])
        local contents = vim.api.nvim_buf_get_lines(bufnr, s_line - 1, e_line, true)
        local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

        u.win.create_float({
          win = { config = { relative = "editor" } },
          contents = contents,
          buf_options = { filetype = buf_ft },
        })
        u.basic.feedkeys("/")
      end)

      -- local ufo = require("ufo")
      local function handler()
        local bufnr = vim.api.nvim_get_current_buf()
        u.basic.feedkeys(":TZNarrow<CR>", "v")

        vim.defer_fn(function()
          if buf_ranges[bufnr] then
            -- ufo.enable()
            buf_ranges[bufnr] = nil
          else
            -- ufo.disable()
            local v_lines = u.basic.get_visible_lines()
            buf_ranges[bufnr] = { v_lines[1], v_lines[#v_lines] } -- start_line, end_line
          end
        end, 200)
      end

      return { { "<leader>tzn", handler, mode = { "x", "n" } } }
    end,
    config = function()
      require("true-zen").setup({
        modes = {
          narrow = { folds_style = "informative", run_ataraxis = false },
          ataraxis = { padding = { left = 13, right = 13 } },
        },
      })
    end,
  },
  -- {
  --   "karb94/neoscroll.nvim",
  --   event = "User BufRead",
  --   opts = {
  --     hide_cursor = true,
  --     cursor_scrolls_alone = true,
  --     respect_scrolloff = true
  --   },
  --   keys = function()
  --     return {
  --       { "<S-k>", "<cmd>lua require('neoscroll').scroll(-8, true, 30)<CR>" },
  --       { "<S-j>", "<cmd>lua require('neoscroll').scroll(8, true, 30)<CR>" },
  --     }
  --   end,
  -- },
  -- {
  --   "echasnovski/mini.animate",
  --   event = "User BufRead",
  --   config = function()
  --     local time = 200
  --     require("mini.animate").setup({
  --       scroll = {
  --         enable = true,
  --         timing = function(_, n)
  --           return time / n
  --         end,
  --       },
  --       cursor = { enable = false },
  --     })
  --   end,
  -- },
}
