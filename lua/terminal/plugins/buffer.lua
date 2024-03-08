local u = require("terminal.utils")

local apis = {}

return {
  {
    "kazhala/close-buffers.nvim",
    dependencies = {
      "famiu/bufdelete.nvim",
      "prochri/telescope-all-recent.nvim",
    },
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
      local bufd = require("bufdelete")
      local force = true

      local handle_delete = function(buf, force, use_native)
        local del = function()
          if use_native then
            vim.api.nvim_buf_delete(buf, { force = force })
          else
            bufd.bufdelete(buf, force)
          end
        end
        if u.buffer.is_modified(buf) then
          local ok = vim.fn.confirm("Buffer is modified, close anyway?", "&Yes\n&No", 2)
          if ok == 1 then del() end
        else
          del()
        end
      end

      local close_apis = {
        ["Current"] = {
          k = "<leader>cc",
          cb = function()
            local cur_buf = vim.api.nvim_get_current_buf()
            if u.buffer.is_noname(cur_buf) then
              handle_delete(cur_buf, force, true)
            else
              handle_delete(cur_buf, force)
            end
          end,
        },
        ["All"] = {
          k = "<leader>ca",
          cb = function()
            for _, buf in ipairs(u.buffer.get_bufs()) do
              handle_delete(buf, force, true)
            end
          end,
        },
        ["Other"] = {
          k = "<leader>co",
          cb = function()
            local cur_buf = vim.api.nvim_get_current_buf()

            for _, buf in ipairs(u.buffer.get_bufs()) do
              if buf ~= cur_buf then handle_delete(buf, force, true) end
            end
          end,
        },
        ["Suffix"] = {
          k = "<leader>cs",
          cb = function()
            local suffix = vim.fn.input("Suffix: ")
            if suffix ~= "" then
              local to_delete = vim.tbl_filter(function(buf)
                local filename = vim.api.nvim_buf_get_name(buf)
                return string.find(filename, ".*[.]" .. suffix) ~= nil
              end, u.buffer.get_bufs())

              for _, buf in ipairs(to_delete) do
                handle_delete(buf, force, true)
              end
            end
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
              handle_delete(buf, force)
            end
          end,
        },
        ["Git Unchanged"] = {
          k = "<leader>cu",
          cb = function()
            local to_delete = vim.tbl_filter(function(buf)
              local is_term = vim.api.nvim_get_option_value("buftype", { buf = buf }) == "terminal"
              if is_term then return false end
              return u.buffer.is_git_changed(buf) == false
            end, u.buffer.get_bufs())

            for _, buf in ipairs(to_delete) do
              handle_delete(buf, force)
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
              handle_delete(buf, force)
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
