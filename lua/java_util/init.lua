local M = {}

M.getSet = function()
  local get_set = function(type, name)
    local format_type = string.gsub(type, ";$", "")
    local format_name = string.gsub(name, ";$", "")
    local code = string.format([[
    public %s get%s() {
      return this.%s;
    }

    public void set%s(%s %s) {
      this.%s = %s;
    }
    ]], format_type, format_name:sub(1, 1):upper() .. format_name:sub(2), format_name,
      format_name:sub(1, 1):upper() .. format_name:sub(2), format_type, format_name, format_name, format_name)
    return code
  end
  local buff = vim.api.nvim_get_current_buf()
  local currentLine = vim.api.nvim_get_current_line()
  currentLine = string.match(currentLine, "^%s*(.-)%s*$")
  local pushvector = {}
  for word in string.gmatch(currentLine, "%S+") do
    table.insert(pushvector, word)
  end
  local generate_code = get_set(pushvector[1], pushvector[2])
  local lines = {}
  for line in string.gmatch(generate_code, "([^\n]*)\n?") do
    table.insert(lines, line)
  end
  vim.api.nvim_buf_set_lines(buff, -1, -1, false, lines)
end

return M
