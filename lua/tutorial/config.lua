local Config = {}

local WIDTH = 40
local HEIGHT = 16

Config.default_opts = {
  enabled = true,

  edit_win_config = {
    relative = "editor",

    width = WIDTH,
    height = HEIGHT,
    col = vim.o.columns - WIDTH,
    row = vim.o.lines - 3 - vim.o.cmdheight - 16,

    style = "minimal",
    border = "rounded",

    noautocmd = true,
  },
}

Config.options = Config.default_opts

return Config
