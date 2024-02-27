local M = {}

M.output_win = nil
M.output_buffer = nil

function ResetBuffer()
	vim.api.nvim_buf_delete(M.output_buffer, { force = true })
	M.output_buffer = nil
end

function M.setup_highlighting(buf)
	-- Highlight groups defined elsewhere or here
	vim.cmd("highlight TestFail guifg=Red ctermfg=Red")
	vim.cmd("highlight TestPass guifg=Green ctermfg=Green")

	-- Get the entire buffer's content
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

	-- TODO: this could be optimized i think! Dont like the for loop
	for i, line in ipairs(lines) do
		-- Adjust the line index for 0-based API
		local line_index = i - 1

		-- Highlight "Failed!"
		-- if line:match("Failed!") then
		-- 	vim.api.nvim_buf_add_highlight(buf, -1, "TestFail", line_index, 0, -1)
		-- end
		if line:match("Failed") then
			vim.api.nvim_buf_add_highlight(buf, -1, "TestFail", line_index, 0, -1)
		end
		if line:match("Passed!") then
			vim.api.nvim_buf_add_highlight(buf, -1, "TestPass", line_index, 0, -1)
		end
	end
end

function M.create_output_buffer()
	if not M.output_buffer then
		M.output_buffer = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_command("vsplit")
		M.output_win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(M.output_win, M.output_buffer)
	end
	vim.api.nvim_buf_set_keymap(M.output_buffer, "n", "q", ":lua ResetBuffer()<CR>", { noremap = true, silent = true })

	return M.output_buffer
end

function M.append_data(buf, data)
	if not data or #data == 0 then
		return
	end
	data = vim.tbl_filter(function(value)
		return value ~= nil and value ~= ""
	end, data)

	if next(data) ~= nil then
		vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
	end
	M.setup_highlighting(M.output_buffer)
end

function M.clear_buffer(buf)
	if not buf or buf < 1 then
		error("Invalid buffer ID.")
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
end

return M
