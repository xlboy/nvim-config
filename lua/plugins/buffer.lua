local u = require("utils")

return {
  {
    "kazhala/close-buffers.nvim",
    dependencies = { "prochri/telescope-all-recent.nvim" },
    keys = function()
      local force = true
      local close_apis = {
        ["Current"] = { k = "<leader>cc", cb = "<cmd>BDelete this<CR>" },
        ["All"] = { k = "<leader>ca", cb = "<cmd>BDelete all<CR>" },
        ["Other"] = { k = "<leader>co", cb = "<cmd>BDelete other<CR>" },
        ["Nameless"] = { k = "<leader>cn", cb = "<cmd>BDelete! nameless<CR>" },
        ["Suffix"] = {
          k = "<leader>cs",
          cb = function()
            local suffix = vim.fn.input("Suffix: ")
            if suffix ~= "" then vim.cmd("BDelete regex=.*[.]" .. suffix) end
          end,
        },
        ["Glob Pattern Buffer"] = {
          k = "<leader>cg",
          cb = function()
            local pattern = vim.fn.input("Glob Pattern: ")
            if pattern ~= "" then vim.cmd("BDelete glob=" .. pattern) end
          end,
        },
        ["Non CWD"] = {
          k = "<leader>cd",
          cb = function()
            local to_delete = vim.tbl_filter(function(buf)
              local filename = vim.api.nvim_buf_get_name(buf)
              local cwd = vim.fn.getcwd()
              return not vim.startswith(filename, cwd)
            end, u.buffer.get_bufs())

            for _, buf in ipairs(to_delete) do
              vim.api.nvim_buf_delete(buf, { force = force })
            end
          end,
        },
        ["Git Unchanged"] = {
          k = "<leader>cu",
          cb = function()
            local to_delete = vim.tbl_filter(function(buf)
              local is_term = vim.api.nvim_get_option_value("buftype", { buf = buf }) == "terminal"
              if is_term then return false end
              return u.buffer.is_buffer_git_changed(buf)
            end, u.buffer.get_bufs())

            for _, buf in ipairs(to_delete) do
              vim.api.nvim_buf_delete(buf, { force = force })
            end
          end,
        },
        ["At node_modules"] = {
          k = "<leader>cnm",
          cb = function()
            local to_delete = vim.tbl_filter(function(buf)
              local filename = vim.api.nvim_buf_get_name(buf)
              return string.find(filename, "node_modules") ~= nil
            end, u.buffer.get_bufs())

            for _, buf in ipairs(to_delete) do
              vim.api.nvim_buf_delete(buf, { force = force })
            end
          end,
        },
      }

      local close_menu = (function()
        return function()
          vim.ui.select(vim.tbl_keys(close_apis), { prompt = "Buffer Closer" }, function(api_name)
            if not api_name then return end
            local api = close_apis[api_name]
            if type(api.cb) == "string" then
              u.basic.feedkeys(api.cb)
            else
              api.cb()
            end
          end)
        end
      end)()

      local keys = { { "<leader>cm", close_menu, desc = "[Close Buffer] Open Menu" } }
      for _, api in pairs(close_apis) do
        table.insert(keys, { api.k, api.cb, desc = "[Close Buffer] " .. _ })
      end

      return keys
    end,
  },
  { "tiagovla/scope.nvim", config = true },
}