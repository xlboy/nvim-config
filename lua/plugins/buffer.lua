return {
  {
    "kazhala/close-buffers.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>cc", ":BDelete! this<CR>", desc = "Delete Current Buffer" },
      { "<leader>ca", ":BDelete! all<CR>", desc = "Delete All Buffer" },
      { "<leader>co", ":BDelete! other<CR>", desc = "Delete Other Buffer" },
      { "<leader>cn", ":BDelete! nameless<CR>", desc = "Delete Nameless Buffer" },
      {
        "<leader>cs",
        function()
          local suffix = vim.fn.input("Suffix: ")
          if suffix ~= "" then vim.cmd(":BDelete! regex=.*[.]" .. suffix) end
        end,
        desc = "Delete Specify Suffix Buffer",
      },
      {
        "<leader>cg",
        function()
          local pattern = vim.fn.input("Glob Pattern: ")
          if pattern ~= "" then vim.cmd(":BDelete! glob=" .. pattern) end
        end,
        desc = "Delete Specify Suffix Buffer",
      },
    },
  },
  -- ui
  {
    "akinsho/bufferline.nvim",
    config = function()
      vim.o.mousemoveevent = true
      require("bufferline").setup({
        options = {
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "center",
            },
          },
          always_show_bufferline = true,
          show_tab_indicators = false,
          diagnostics_indicator = function(_, _, diagnostics_dict, _)
            -- only show warning and error
            local s = " "
            for e, n in pairs(diagnostics_dict) do
              local sym = e == "error" and " " or (e == "warning" and " " or "")
              s = s .. sym .. n
            end
            return s
          end,
          hover = {

            delay = 36,
            reveal = { "close" },
            enabled = true,
          },
          style_preset = "slant",
        },
      })
    end,
  },
}
