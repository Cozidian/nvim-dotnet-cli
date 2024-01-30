local M = {}

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

	return nil -- No class found
end

return M
