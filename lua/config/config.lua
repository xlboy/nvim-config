return {
  IN_HOME = os.getenv("IN_HOME"),
  IS_WIN = vim.loop.os_uname().sysname == "Windows_NT",
  mini_ts_layout_wh = {
    width = 90,
    height = 25,
  },
  ft_ignores = {
    "qf",
    "Outline",
    "neo-tree",
    "notify",
    "fidget",
    "Trouble",
    "incline",
    "TelescopePrompt",
    "TelescopeResults",
  },
  colors = {
    window = {
      active = { bg = "#17c0eb", fg = "#ffffff" },
      visible = { bg = "#2f3640", fg = "#afc5c7" },
      default = { bg = "none", fg = "#B0BEC5" },
    },
    modified = { fg = "#d4920c" },
  },
  symbols = {
    rounded_corner = { left = "", right = "" },
  },
  telescope_recent = {
    pickers = { "commander#commander" },
    ui_select_prompts = { "[Outline] Target Symbol", "[Chainsaw] Target Log", "[VSCode Opener] Select Mode" },
  },
}
