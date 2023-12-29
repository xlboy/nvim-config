return {
  {
    "utilyre/sentiment.nvim",
    event = "VeryLazy",
    opts = {
      pairs = { { "(", ")" }, { "[", "]" }, { "{", "}" }, { "<", ">" } },
    },
    init = function()
      vim.g.loaded_matchparen = 1
    end,
  },
  -- {
  --   "xlboy/peepsight.nvim",
  --   enabled = false,
  --   -- dir = "~/Desktop/xlboy/peepsight.nvim",
  --   event = "VeryLazy",
  --   init = function()
  --     vim.api.nvim_create_autocmd("WinLeave", {
  --       callback = function()
  --         local cur_win = vim.api.nvim_get_current_win()
  --         local cur_buf = vim.api.nvim_win_get_buf(cur_win)
  --         require("peepsight").clear(cur_buf)
  --       end,
  --     })
  --   end,
  --   config = function()
  --     require("peepsight").setup({
  --       -- Lua
  --       "function_definition",
  --       "local_function_definition_statement",
  --       "function_definition_statement",
  --
  --       -- TypeScript
  --       "if_statement",
  --       "class_declaration",
  --       "method_definition",
  --       "arrow_function",
  --       "function_declaration",
  --       "generator_function_declaration",
  --     }, {
  --       highlight = { hl_group = "SpecialKey" },
  --     })
  --     -- require("peepsight").enable()
  --   end,
  -- },
  -- { "itchyny/vim-cursorword", event = "UIEnter" },
  {
    "echasnovski/mini.cursorword",
    event = "UIEnter",
    config = function()
      require("mini.cursorword").setup()
    end,
  },
  -- Automatically highlights other instances of the word under your cursor.
  -- This works with LSP, Treesitter, and regexp matching to find the other
  -- instances.
  {
    "RRethy/vim-illuminate",
    event = "UIEnter",
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = { providers = { "lsp" } },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },

  {
    "levouh/tint.nvim",
    event = "UIEnter",
    opts = {
      tint = -80,
      saturation = 0.6,
      window_ignore_function = function(winid)
        local buf = vim.api.nvim_win_get_buf(winid)
        return vim.bo[buf].modifiable ~= true
      end,
    },
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "UIEnter",
    cmd = { "ColorizerToggle", "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers" },
    opts = {
      user_default_options = { names = true },
    },
  },
}
