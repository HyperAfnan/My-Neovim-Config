local function find_node_ancestor(types, node)
  if not node then
    return nil
  end

  if vim.tbl_contains(types, node:type()) then
    return node
  end

  local parent = node:parent()

  return find_node_ancestor(types, parent)
end


local function add_async()

  vim.api.nvim_feedkeys('t', 'n', true)

  local text_before_cursor = vim.fn.getline('.'):sub(vim.fn.col '.' - 4, vim.fn.col '.' - 1)
  if text_before_cursor ~= 'awai' then
    return
  end

  local current_node = vim.treesitter.get_node { ignore_injections = false }
  local function_node = find_node_ancestor(
    { 'arrow_function', 'function_declaration', 'function' },
    current_node
  )
  if not function_node then
    return
  end

  local function_text = vim.treesitter.get_node_text(function_node, 0)
  if vim.startswith(function_text, 'async ') then
    return
  end

  local start_row, start_col = function_node:start()
  vim.api.nvim_buf_set_text(0, start_row, start_col, start_row, start_col, { 'async ' })
end

vim.keymap.set('i', 't', add_async, { buffer = true })

-- vim.api.nvim_create_autocmd("CursorMovedI", {
--    pattern = "*.js",
--    callback = function ()
--       -- get treesitter node at cursor 
--       local node = vim.treesitter.get_node { ignore_injections = false }
--          -- print(vim.treesitter.get_node_text(node, 0))
--       vim.inspect(node:named_children())
--    end
-- })
