local u = require("utils")
return {
  {
    "xlboy/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = u.basic.append_arrays(opts.ensure_installed, {
        "html",
        "css",
        "javascript",
        "json",
        "tsx",
        "typescript",
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "js-everts/cmp-tailwind-colors", opts = {} },
    },
    opts = function(_, opts)
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        if item.kind == "Color" then
          item = require("cmp-tailwind-colors").format(entry, item)
          if item.kind == "Color" then return format_kinds(entry, item) end
          return item
        end
        return format_kinds(entry, item)
      end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = u.basic.append_arrays(opts.ensure_installed, {
        "html",
        "cssls",
        "tsserver",
        "jsonls",
        "tailwindcss",
      })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = u.basic.append_arrays(opts.ensure_installed, { "prettierd" })
    end,
  },
  -- {
  --   "pmizio/typescript-tools.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  --   ft = { "javascript", "typescript", "typescriptreact" },
  --   opts = {},
  -- },
}
