return {
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      config = {
        tailwindcss = {
          settings = {
            tailwindCSS = {
              classAttributes = {
                "class",
                "className",
                "classNames",
                "ngClass",
                "classList",
              },
              experimental = {
                classRegex = {
                  { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                  { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                  {
                    "tw`([^`]*)",
                    'tw="([^"]*)',
                    'tw={"([^"}]*)',
                    "tw\\.\\w+`([^`]*)",
                    "tw\\(.*?\\)`([^`]*)",
                  },
                },
              },
              includeLanguages = {
                typescript = "javascript",
                typescriptreact = "javascript",
              },
              emmetCompletions = false,
              validate = true,
              lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidConfigPath = "error",
                invalidScreen = "error",
                invalidTailwindDirective = "error",
                invalidVariant = "error",
                recommendedVariantOrder = "warning",
              },
            },
          },
        },
      },
    },
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
    "razak17/tailwind-fold.nvim",
    dependencies = { "xlboy/nvim-treesitter" },
    ft = { "html", "typescriptreact" },
    config = function()
      vim.cmd("set conceallevel=2")
      require("tailwind-fold").setup()

      ---@diagnostic disable-next-line: missing-parameter
      require("commander").add({
        { desc = "Tailwind Fold Toggle", cmd = ":TailwindFoldToggle<CR>" },
      })

      vim.api.nvim_create_autocmd("WinEnter", {
        callback = function()
          vim.cmd("TailwindFoldEnable")
        end,
        desc = "Tailwind Fold Enable",
      })
    end,
  },
}
