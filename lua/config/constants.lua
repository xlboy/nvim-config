return {
  IN_HOME = os.getenv("IN_HOME"),
  IS_WIN = vim.loop.os_uname().sysname == "Windows_NT",
}
