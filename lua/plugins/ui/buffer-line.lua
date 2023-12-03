
return {
    {
      "akinsho/bufferline.nvim",
      event = "VeryLazy",
      config = function()
        vim.o.mousemoveevent = true
        require("bufferline").setup({})
      end,
    },
  }
  