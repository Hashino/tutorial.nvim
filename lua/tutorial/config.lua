local Config = {}

local WIDTH = 40
local HEIGHT = 16

---@class TutorialOptions
---@field enabled boolean whether the plugin is enabled
---@field ignored_buffers string[]|fun():string[] ignored buffers
---@field float_win_config table configuration for the edit window
Config.default_opts = {
  enabled = true,

  -- doesn"t display on buffers that match filetype/filename/filepath to
  -- entries. can be either a string array or a function that returns a
  -- string array. filepath can be relative to cwd or absolute
  ignored_buffers = {
    "nofile",
    "quickfix",
    "help",
    "prompt",
    "popup",
  },

  -- window configs of the floating Tutorial buffer
  -- see :h nvim_open_win() for available options
  float_win_config = {
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
