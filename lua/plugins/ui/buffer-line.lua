return {
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
