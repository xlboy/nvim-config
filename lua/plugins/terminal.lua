local uv = vim.loop
local terms = {}

local set_keymap = function(bufnr)
  local maps = {
    ["<leader>o"] = function()
      require("terminal").open()
    end,
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

    [{ "<Esc>", "jk", "kj" }] = function()
      vim.cmd("stopinsert")
    end,
  }

  for _, mode in ipairs({ "t", "n" }) do
    for key, fn in pairs(maps) do
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

return {
  "niuiic/terminal.nvim",
  event = "VeryLazy",
  config = function()
    require("terminal").setup({
      on_term_opened = function(bufnr, pid)
        vim.api.nvim_set_option_value("filetype", "terminal", { buf = bufnr })
        set_keymap(bufnr)
        terms[bufnr] = pid
      end,
    })

    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      pattern = { "*" },
      callback = function(args)
        local filetype = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
        if filetype == "terminal" then vim.cmd("startinsert") end
      end,
    })
  end,
  keys = {
    { "<leader>tm", desc = "[Terminal] ..." },
    { "<leader>tmo", ':lua require("terminal").open()<CR>', desc = "[Terminal] open" },
  },
}
