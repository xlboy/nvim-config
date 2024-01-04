local config = require("config.config")

return {
  {
    "utilyre/sentiment.nvim",
    event = "BufRead",
    opts = {
      pairs = { { "(", ")" }, { "[", "]" }, { "{", "}" }, { "<", ">" } },
    },
    init = function()
      vim.g.loaded_matchparen = 1
    end,
  },
  {
    "echasnovski/mini.cursorword",
    event = "BufRead",
    config = function()
      require("mini.cursorword").setup()
    end,
  },
  -- Automatically highlights other instances of the word under your cursor.
  -- This works with LSP, Treesitter, and regexp matching to find the other
  -- instances.
  {
    "RRethy/vim-illuminate",
    event = "BufRead",
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

  -- 非 focus 的窗口进行置灰
  {
    "levouh/tint.nvim",
    lazy = false,
    priority = 10, -- make sure to load this before all the other start plugins
    opts = {
      tint = -80,
      saturation = 0.6,
      window_ignore_function = function(winid)
        local buf = vim.api.nvim_win_get_buf(winid)
        local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
        if filetype == "" then return true end
        if vim.tbl_contains(config.ft_ignores, filetype) then return true end
      end,
    },
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "VeryLazy",
    cmd = { "ColorizerToggle", "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers" },
    opts = { user_default_options = { tailwind = true } },
    init = function()
      local done = false
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client.name == "tailwindcss" and done == false then
            vim.cmd("ColorizerToggle")
            done = true
          end
        end,
      })
    end,
  },
  {
    "uga-rosa/ccc.nvim",
    cmd = { "CccPick", "CccConvert" },
    opts = { highlighter = { auto_enable = true, lsp = true } },
  },
}
