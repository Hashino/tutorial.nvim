local Config = {}

Config.default_opts = {
  enabled = true,

  edit_win_config = {
    relative = "editor",

    width = 50,
    height = 16,
    col = vim.o.columns - 50,
    row = vim.o.lines - 3 - 16,

    style = "minimal",
    border = "rounded",

    noautocmd = true,
  },
}

Config.options = Config.default_opts

return Config
