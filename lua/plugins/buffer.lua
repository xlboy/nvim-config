local u = require("utils")

return {
  {
    "kazhala/close-buffers.nvim",
    dependencies = { "prochri/telescope-all-recent.nvim" },
    init = function()
      vim.api.nvim_create_autocmd({ "BufEnter" }, {
        callback = function()
          local bufs = u.buffer.get_bufs()

          if #bufs == 2 then
            local noname_buf = vim.tbl_filter(u.buffer.is_noname, bufs)[1]
            if noname_buf then vim.api.nvim_buf_delete(noname_buf, { force = false }) end
          end
        end,
      })
    end,
    keys = function()
      local force = true
      local close_apis = {
        ["Current"] = {
          k = "<leader>cc",
          cb = function()
            local cur_buf = vim.api.nvim_get_current_buf()
            if u.buffer.is_modified(cur_buf) then
              local ok = vim.fn.confirm("Buffer is modified, close anyway?", "&Yes\n&No", 2)
              if ok == 1 then vim.cmd("BDelete! this") end
            else
              vim.cmd("BDelete this")
            end
          end,
        },
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
        ["Non CWD"] = { k = "<leader>cd", cb = u.buffer.delete_non_cwd },
        ["Git Unchanged"] = {
          k = "<leader>cu",
          cb = function()
            local to_delete = vim.tbl_filter(function(buf)
              local is_term = vim.api.nvim_get_option_value("buftype", { buf = buf }) == "terminal"
              if is_term then return false end
              return u.buffer.is_git_changed(buf) == false
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
  -- 让 tab 下的 buffer 独立，另外配合  resession.nvim 来使用
  { "tiagovla/scope.nvim", config = true },
  -- 自动关闭不用的 buffer
  -- { "axkirillov/hbac.nvim", opts = { threshold = 6 } },
  {
    "chrisgrieser/nvim-early-retirement",
    opts = { retirementAgeMins = 10 },
    event = "User BufRead",
  },
}
