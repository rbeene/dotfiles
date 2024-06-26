local M = {}

function M.setup_command_alias(input, output)
  vim.cmd(string.format([[
    cnoreabbrev <expr> %s ((getcmdtype() == ':' and getcmdline() == '%s') ? '%s' : '%s')
  ]], vim.fn.escape(input, '\\'), input, output, input))
end

function M.setup_aliases()
  M.setup_command_alias("grep", "GrepperGrep")
  -- Add more aliases as needed
end

return M

