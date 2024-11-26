local M = {}

M.getSet = function()
  -- Define la función get_set antes de usarla
  local get_set = function(type, name)
    -- Genera el código y quita los puntos y comas innecesarios
    local code = string.format([[
public %s get%s() {
    return this.%s;
}

public void set%s(%s %s) {
    this.%s = %s;
}
]], type, name:sub(1, 1):upper() .. name:sub(2), name, name:sub(1, 1):upper() .. name:sub(2), type, name, name, name)

    code = string.gsub(code, ";", "")
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

M.setup = function()
  vim.keymap.set("n", "zz", function()
    M.getSet()
  end, {})
end

return M
