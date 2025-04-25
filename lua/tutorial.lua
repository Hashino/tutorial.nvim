local config = require("tutorial.config")

local Tutor = {
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

function Tutor.open()
  if Tutor.enabled then
    Tutor.buf = vim.api.nvim_create_buf(false, true)
    Tutor.win = vim.api.nvim_open_win(Tutor.buf, false, config.options.edit_win_config)

    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = Tutor.buf, })
    vim.api.nvim_set_option_value("swapfile", false, { buf = Tutor.buf, })
    vim.api.nvim_set_option_value("filetype", "markdown", { buf = Tutor.buf, })

    vim.api.nvim_buf_set_lines(Tutor.buf, 0, -1, false, content["normal"])
  end
end

function Tutor.setup(opts)
  config.options = vim.tbl_deep_extend("force", config.default_opts, opts or {})
  Tutor.enabled = config.options.enabled

  vim.api.nvim_create_autocmd({ "BufEnter", }, {
    callback = Tutor.open,
  })

  vim.api.nvim_create_autocmd({ "ModeChanged", }, {
    callback = function()
      if Tutor.enabled then
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
          vim.api.nvim_win_close(Tutor.win, false)
          Tutor.win = nil
          return
        end

        if Tutor.win == nil then
          Tutor.open()
        end

        vim.api.nvim_buf_set_lines(Tutor.buf, 0, -1, false, lines)
      end
    end,
  })
end

function Tutor.toggle()
  if Tutor.enabled then
    Tutor.enabled = false
    vim.api.nvim_win_close(Tutor.win, true)
  else
    Tutor.enabled = true
    Tutor.open()
  end
end

return Tutor
