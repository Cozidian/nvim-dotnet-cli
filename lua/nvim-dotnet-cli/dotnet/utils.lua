local M = {}

function M.find_current_class_name()
	local parser = vim.treesitter.get_parser(0, "c_sharp")
	local tree = parser:parse()[1]
	local root = tree:root()

	local current_line, _ = unpack(vim.api.nvim_win_get_cursor(0))
	current_line = current_line - 1

	local query = vim.treesitter.query.parse(
		"c_sharp",
		[[
        (class_declaration
            name: (identifier) @classname
        )
    ]]
	)

	local start_row, _, end_row, _ = root:range()

	for id, node in query:iter_captures(root, 0, start_row, end_row) do
		local name = query.captures[id]
		if name == "classname" then
			if start_row <= current_line and current_line <= end_row then
				return vim.treesitter.get_node_text(node, 0)
			end
		end
	end

	return nil
end

function M.find_current_method_name()
	local parser = vim.treesitter.get_parser(0, "c_sharp")
	local tree = parser:parse()[1]
	local root = tree:root()

	local current_line, _ = unpack(vim.api.nvim_win_get_cursor(0))
	current_line = current_line - 1

	local query = vim.treesitter.query.parse(
		"c_sharp",
		[[
        (method_declaration
            name: (identifier) @methodname
        )
    ]]
	)

	local start_row, _, end_row, _ = root:range()

	for id, node in query:iter_captures(root, 0, start_row, end_row) do
		local name = query.captures[id]
		if name == "methodname" then
			if start_row <= current_line and current_line <= end_row then
				return vim.treesitter.get_node_text(node, 0)
			end
		end
	end

	return nil
end

return M
