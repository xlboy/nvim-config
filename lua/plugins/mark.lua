local t_extensions = require("telescope").extensions
return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufRead",
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({
        default = {
          -- select = function(list_item, list, options) end,
        },
      })

      vim.keymap.set("n", ",a", function()
        harpoon:list():append()
      end)
      vim.keymap.set("n", ",,", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)
    end,
  },
  {
    "ten3roberts/bookmarks.nvim",
    branch = "feat-scoped-bookmarks",
    event = "User Startup30s",
    keys = {
      { "<leader>mt", description = "[bookmark] add or remove mark at current line" },
      { "<leader>mi", description = "[bookmark] add or edit mark annotation at current line" },
      { "<leader>mc", description = "[bookmark] clean all marks in local buffer" },
      { "<leader>mj", description = "[bookmark] jump to next mark in local buffer" },
      { "<leader>mk", description = "[bookmark] jump to previous mark in local buffer" },
      { "<leader>ml", description = "[bookmark] list all marks in local buffer" },
    },
    config = function()
      require("bookmarks").setup({
        scoped = true,
        on_attach = function(bufnr)
          local bm = require("bookmarks")
          local map = vim.keymap.set
          map("n", "<leader>mt", bm.bookmark_toggle) -- add or remove bookmark at current line
          map("n", "<leader>mi", bm.bookmark_ann) -- add or edit mark annotation at current line
          map("n", "<leader>mc", bm.bookmark_clean) -- clean all marks in local buffer
          map("n", "<leader>mj", bm.bookmark_next) -- jump to next mark in local buffer
          map("n", "<leader>mk", bm.bookmark_prev) -- jump to previous mark in local buffer
          map("n", "<leader>ml", function()
            t_extensions.bookmarks.list({ previewer = false })
          end)
        end,
      })
      require("telescope").load_extension("bookmarks")
    end,
  },
}
