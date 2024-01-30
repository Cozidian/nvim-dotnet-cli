local M = {}

function M.create_output_buffer()
	if M.output_buf and vim.api.nvim_buf_is_valid(M.output_buf) then
		return M.output_buf
	end

	M.output_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_command("vsplit")
	vim.api.nvim_win_set_buf(0, M.output_buf)
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
		vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
	end
end

return M
