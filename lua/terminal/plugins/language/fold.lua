return {
  {
    "kevinhwang91/nvim-ufo",
    enabled = false,
    event = "VeryLazy",
    dependencies = { { "kevinhwang91/promise-async" } },
    opts = {
      -- provider_selector = function(_, filetype, buftype)
      --   local function handleFallbackException(bufnr, err, providerName)
      --     if type(err) == "string" and err:match("UfoFallbackException") then
      --       return require("ufo").getFolds(bufnr, providerName)
      --     else
      --       return require("promise").reject(err)
      --     end
      --   end
      --
      --   return (filetype == "" or buftype == "nofile") and "indent" -- only use indent until a file is opened
      --       or function(bufnr)
      --         return require("ufo")
      --             .getFolds(bufnr, "lsp")
      --             :catch(function(err)
      --               return handleFallbackException(bufnr, err, "treesitter")
      --             end)
      --             :catch(function(err)
      --               return handleFallbackException(bufnr, err, "indent")
      --             end)
      --       end
      -- end,
      --
      -- fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
      --   local newVirtText = {}
      --   local suffix = (" 󰁂 %d "):format(endLnum - lnum)
      --   local sufWidth = vim.fn.strdisplaywidth(suffix)
      --   local targetWidth = width - sufWidth
      --   local curWidth = 0
      --   for _, chunk in ipairs(virtText) do
      --     local chunkText = chunk[1]
      --     local chunkWidth = vim.fn.strdisplaywidth(chunkText)
      --     if targetWidth > curWidth + chunkWidth then
      --       table.insert(newVirtText, chunk)
      --     else
      --       chunkText = truncate(chunkText, targetWidth - curWidth)
      --       local hlGroup = chunk[2]
      --       table.insert(newVirtText, { chunkText, hlGroup })
      --       chunkWidth = vim.fn.strdisplaywidth(chunkText)
      --       -- str width returned from truncate() may less than 2nd argument, need padding
      --       if curWidth + chunkWidth < targetWidth then
      --         suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      --       end
      --       break
      --     end
      --     curWidth = curWidth + chunkWidth
      --   end
      --   table.insert(newVirtText, { suffix, "@text.title.3.markdown" })
      --   return newVirtText
      -- end,
    },
  },
  -- 折叠嵌套
  {
    "jghauser/fold-cycle.nvim",
    keys = {
      { "zcc", "<cmd>normal! zc<CR>",                            desc = "[Fold] Close" },
      { "zoo", "<cmd>normal! zo<CR>",                            desc = "[Fold] Open" },
      { "zcn", "<cmd>lua require('fold-cycle').close_all()<CR>", desc = "[Fold] Nested Close" },
      { "zon", "<cmd>lua require('fold-cycle').open_all()<CR>",  desc = "[Fold] Nested Open" },
    },
  },
  -- 按 h/l 即可触发折叠（当前是关闭状态）；支持 折叠 session 功能
  {
    enabled = true,
    "chrisgrieser/nvim-origami",
    event = "VeryLazy",
    opts = { setupFoldKeymaps = false },
  },
  {
    "domharries/foldnav.nvim",
    version = "*",
    init = function()
      vim.g.foldnav = { flash = { enabled = true } }
    end,
    keys = {
      { "<C-h>", function() require("foldnav").goto_start() end },
      { "<C-j>", function() require("foldnav").goto_next() end },
      { "<C-k>", function() require("foldnav").goto_prev_start() end },
      -- { "<C-k>", function() require("foldnav").goto_prev_end() end },
      { "<C-l>", function() require("foldnav").goto_end() end },
    },
  },
}
