local config = require("tutorial.config")

local Utils = {}

---checks whether the current window/buffer should display the plugin
function Utils.should_display()
  -- once a window gets checked once, a variable is set to tell doing
  -- if it should render itself in it
  -- this avoids redoing the checking on every update
  if vim.b.tutorial_should_display then
    return vim.b.tutorial_should_display
  end

  if vim.bo.buftype == "popup" or vim.bo.buftype == "prompt" or vim.fn.win_gettype() ~= "" then
    -- saves result to a buffer variable
    vim.b.tutorial_should_display = false
    return false
  end

  local ignore = config.options.ignored_buffers
  ignore = type(ignore) == "function" and ignore() or ignore

  local home_path_abs = tostring(os.getenv("HOME"))
  local curr = vim.fn.expand("%:p")

  ---@diagnostic disable-next-line: param-type-mismatch
  for _, exclude in ipairs(ignore) do
    -- checks if exclude is a relative filepath and expands it
    if exclude:sub(1, 2) == "./" or exclude:sub(1, 2) == ".\\" then
      exclude = vim.fn.getcwd() .. exclude:sub(2, -1)
    end

    if
        vim.bo.filetype:find(exclude)          -- match filetype
        or exclude == vim.fn.expand("%")       -- match filename
        or exclude:gsub("~", home_path_abs) == curr -- match filepath
    then
      -- saves result to a buffer variable
      vim.b.tutorial_should_display = false
      return false
    end
  end

  -- saves result to a buffer variable
  vim.b.tutorial_should_display = true
  return true
end

return Utils
