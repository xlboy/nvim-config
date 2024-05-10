local uv = vim.loop
local terms = {}

local set_keymap = function(bufnr)
  local maps = {
    [{ "n" }] = {
      -- ["<leader>o"] = function()
      --   require("terminal").open()
      -- end,
      ["<leader>cc"] = function()
        uv.kill(terms[bufnr], "sigkill")
        table.remove(terms, bufnr)
        vim.api.nvim_buf_delete(bufnr, {
          force = true,
        })
      end,
      ["<leader>ca"] = function()
        for buf, pid in pairs(terms) do
          uv.kill(pid, "sigkill")
          vim.api.nvim_buf_delete(buf, { force = true })
        end
        terms = {}
      end,
    },
    [{ "t" }] = {
      [{ "jk", "kj", "<Esc>" }] = function()
        vim.cmd("stopinsert")
      end,
    },
  }

  for modeGroup, values in pairs(maps) do
    for _, mode in ipairs(modeGroup) do
      for key, fn in pairs(values) do
        if type(key) == "string" then
          vim.api.nvim_buf_set_keymap(bufnr, mode, key, "", { callback = fn })
        else
          for _, _key in ipairs(key) do
            vim.api.nvim_buf_set_keymap(bufnr, mode, _key, "", { callback = fn })
          end
        end
      end
    end
  end
end

return {
  {
    "niuiic/terminal.nvim",
    enabled = false,
    config = function()
      require("terminal").setup({
        on_term_opened = function(bufnr, pid)
          -- 延时 300ms 设置 filetype 为 terminal
          vim.defer_fn(function()
            vim.api.nvim_set_option_value("filetype", "terminal", { buf = bufnr })
            set_keymap(bufnr)
            terms[bufnr] = pid
          end, 300)
        end,
      })
    end,
    keys = {
      { "<leader>tm", desc = "[Terminal] ..." },
      { "<leader>tmo", ':lua require("terminal").open()<CR>', desc = "[Terminal] open" },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    opts = {},
    event = "User BufRead",
    keys = {
      -- { "<leader>tm", desc = "[Terminal] ..." },
      -- { "<leader>tmo", 'ToggleTerm', desc = "[Terminal] open" },
    },
  },
}
