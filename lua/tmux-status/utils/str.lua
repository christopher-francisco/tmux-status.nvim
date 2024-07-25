local M = {}

---Split a sentence by the given delimiter
---@param sentence string
---@param delimiter string
---@return string[]
function M.split(sentence, delimiter)
  local words = {}
  for word in sentence:gmatch(delimiter) do table.insert(words, word) end
  return words
end

return M
