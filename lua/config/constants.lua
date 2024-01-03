return {
  IN_HOME = os.getenv("IN_HOME"),
  IS_WIN = vim.loop.os_uname().sysname == "Windows_NT",
  MINI_TS_LAYOUT_WH = {
    width = 90,
    height = 25,
  },
  FT_IGNORES = { "NvimTree", "neo-tree", "notify", "fidget", "Trouble" },
}
