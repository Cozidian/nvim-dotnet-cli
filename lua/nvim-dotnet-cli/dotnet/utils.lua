local M = {}

local function ensure_treesitter_and_csharp_parser()
	if not pcall(require, "vim.treesitter") then
		return false, "Tree-sitter is not available in this Neovim installation."
	end

	local parser_list = require("vim.treesitter.query").get("c_sharp", "highlights")
	if #parser_list == 0 then
		return false, "The C# Tree-sitter parser is not installed."
	end

	return true, ""
end

function M.find_current_method_name()
	local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	for i = current_line, 1, -1 do
		if lines[i]:match("^%s*%[%w+%]%s*$") then
			if lines[i + 1] then
				local words = vim.split(lines[i + 1], "%s+")
				local lastWord = words[#words]:gsub("%(%)$", "")

				if lastWord and lastWord ~= "" then
					return lastWord
				else
				end
			end
		end
	end

	return nil
end

function M.find_current_class_name()
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	for i = current_line, 1, -1 do
		local line = lines[i]
		local match = line:match("^%s*public%s+class%s+(%w+)")
		if match then
			return match
		end
	end

	return nil
end

function M.find_current_method_name2()
	local ok, err = ensure_treesitter_and_csharp_parser()
	if not ok then
		print(err)
		return nil
	end

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
