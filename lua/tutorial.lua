local config = require("tutorial.config")

local Tutorial = {
  buf = nil,
  win = nil,
  enabled = true,
}

local content = {
  ["normal"] = {
    "`:h` - Help",
    "`:q` - Quit",
    "`:w` - Save",
    "`:x` - Save and Quit",
    "`:Tutor` - Start Vim Tutor",
    "`:Tutorial toggle` - hide/show this",
    "",
    "`h/j/k/l` move cursor",
    "",
    "`a` insert mode after cursor",
    "`A` insert mode at line start",
    "`i` insert mode before cursor",
    "`I` insert mode at line end",
    "`v` visual mode",
    "`V` visual line mode",
    "`<C-v>` visual block mode",
  },
  ["insert"] = {
    "`<Esc>` exit insert mode",
    "`<C-o>` execute one normal mode command",
    "",
    "type to insert text"
  },
  ["visual"] = {
    "`<Esc>` to exit visual mode",
    "",
    "`h/j/k/l` move cursor",
    "",
    "`y` yank (copy) the selected text",
    "`d` delete the selected text",
    "`c` change the selected text",
    "`p` paste the yanked text",
  }
}

function Tutorial.open()
  if Tutorial.enabled then
    Tutorial.buf = vim.api.nvim_create_buf(false, true)
    Tutorial.win = vim.api.nvim_open_win(Tutorial.buf, false, config.options.edit_win_config)

    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = Tutorial.buf, })
    vim.api.nvim_set_option_value("swapfile", false, { buf = Tutorial.buf, })
    vim.api.nvim_set_option_value("filetype", "markdown", { buf = Tutorial.buf, })

    vim.api.nvim_buf_set_lines(Tutorial.buf, 0, -1, false, content["normal"])
  end
end

function Tutorial.setup(opts)
  config.options = vim.tbl_deep_extend("force", config.default_opts, opts or {})
  Tutorial.enabled = config.options.enabled

  vim.api.nvim_create_autocmd({ "BufEnter", }, {
    callback = Tutorial.open,
  })

  vim.api.nvim_create_autocmd({ "ModeChanged", }, {
    callback = function()
      if Tutorial.enabled then
        local mode_names = {
          n = "NORMAL",
          i = "INSERT",
          v = "VISUAL",
          V = "VISUAL LINE",
          ['\22'] = "VISUAL BLOCK", -- Ctrl+V (blockwise visual)
        }

        local mode = mode_names[vim.fn.mode()]

        local lines = {}

        if mode == "NORMAL" then
          lines = content["normal"]
        elseif mode == "INSERT" then
          lines = content["insert"]
        elseif mode == "VISUAL" or mode == "VISUAL LINE" or mode == "VISUAL BLOCK" then
          lines = content["visual"]
        else
          vim.api.nvim_win_close(Tutorial.win, false)
          Tutorial.win = nil
          return
        end

        if Tutorial.win == nil then
          Tutorial.open()
        end

        vim.api.nvim_buf_set_lines(Tutorial.buf, 0, -1, false, lines)
      end
    end,
  })
end

function Tutorial.toggle()
  if Tutorial.enabled then
    Tutorial.enabled = false
    vim.api.nvim_win_close(Tutorial.win, true)
  else
    Tutorial.enabled = true
    Tutorial.open()
  end
end

return Tutorial
