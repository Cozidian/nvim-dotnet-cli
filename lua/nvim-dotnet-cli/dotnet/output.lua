local M = {}

M.output_win = nil

function M.create_output_buffer()
	if M.output_buf and vim.api.nvim_buf_is_valid(M.output_buf) then
		if not M.output_win or not vim.api.nvim_win_is_valid(M.output_win) then
			vim.api.nvim_command("vsplit")
			M.output_win = vim.api.nvim_get_current_win()
			vim.api.nvim_win_set_buf(M.output_win, M.output_buf)
		end
		return M.output_buf
	end

	M.output_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_command("vsplit")
	M.output_win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(M.output_win, M.output_buf)
	return M.output_buf
end

function M.append_data(buf, data)
	if not data or #data == 0 then
		return
	end
	data = vim.tbl_filter(function(value)
		return value ~= nil and value ~= ""
	end, data)

	if next(data) ~= nil then
		M.clear_buffer(buf)
		vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
	end
end

function M.clear_buffer(buf)
	if not buf or buf < 1 then
		error("Invalid buffer ID.")
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
end

return M
