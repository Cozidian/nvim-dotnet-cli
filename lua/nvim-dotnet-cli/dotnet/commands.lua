local output = require("nvim-dotnet-cli.dotnet.output")
local utils = require("nvim-dotnet-cli.dotnet.utils")

local M = {}

local function run_dotnet_command(cmd, success_message, fail_message)
	local output_buf = output.create_output_buffer()
	output.clear_buffer(output_buf)

	local on_exit = function(job_id, exit_code, event_type)
		local message = exit_code == 0 and success_message or fail_message
		output.append_data(output_buf, { message })
	end

	local opts = {
		on_stdout = function(job_id, data, event_type)
			output.append_data(output_buf, data)
		end,
		on_stderr = function(job_id, data, event_type)
			output.append_data(output_buf, data)
		end,
		on_exit = on_exit,
	}

	vim.fn.jobstart(cmd, opts)
end

function M.run_all_tests()
	local cmd = "dotnet test"
	local success_message = "Tests ran successfully:"
	local fail_message = "Test run failed:"

	run_dotnet_command(cmd, success_message, fail_message)
end

function M.run_tests_with_filter(filter)
	local cmd = "dotnet test --filter " .. filter
	local success_message = "Tests ran successfully:"
	local fail_message = "Test run failed:"
	run_dotnet_command(cmd, success_message, fail_message)
end

function M.run_test_for_current_method()
	local class_name = utils.find_current_class_name()
	local method_name = utils.find_current_method_name2()

	if not class_name then
		return
	end

	if not method_name then
		return
	end

	local filter = string.format("FullyQualifiedName~%s.%s", class_name, method_name)
	local cmd = "dotnet test --filter " .. filter
	local success_message = string.format("Test for method %s in class %s ran successfully:", method_name, class_name)
	local fail_message = string.format("Test for method %s in class %s failed:", method_name, class_name)

	run_dotnet_command(cmd, success_message, fail_message)
end

function M.run_tests_for_current_class()
	local class_name = utils.find_current_class_name()
	if not class_name then
		return
	end

	local filter = "FullyQualifiedName~" .. class_name
	local cmd = "dotnet test --filter " .. filter
	local success_message = "Tests for class " .. class_name .. " ran successfully:"
	local fail_message = "Tests for class " .. class_name .. " failed:"

	run_dotnet_command(cmd, success_message, fail_message)
end

return M
