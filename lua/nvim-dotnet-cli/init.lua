local commands = require("nvim-dotnet-cli.dotnet.commands")
local M = {}

function M.run_all_tests()
	commands.run_all_tests()
end
function M.run_with_filter(filter)
	commands.run_tests_with_filter(filter)
end
function M.run_test_under_cursor()
	commands.run_test_for_current_method()
end
function M.run_tests_in_class()
	commands.run_tests_for_current_class()
end

function M.setup_key_mappings()
	local map = vim.api.nvim_set_keymap
	local opts = { noremap = true, silent = true }

	map("n", "<leader>cta", ":RunAllTests<CR>", opts)
	map("n", "<leader>ctf", ":RunTestsWithFilter ", opts)
	map("n", "<leader>ctm", ":RunTestUnderCursor<CR>", opts)
	map("n", "<leader>ctc", ":RunTestsInClass<CR>", opts)
end

vim.api.nvim_create_user_command("RunAllTests", M.run_all_tests, { nargs = 0 })
vim.api.nvim_create_user_command("RunTestsWithFilter", function(opts)
	M.run_with_filter(opts.args)
end, { nargs = 1 })

vim.api.nvim_create_user_command("RunTestUnderCursor", M.run_test_under_cursor, { nargs = 0 })
vim.api.nvim_create_user_command("RunTestsInClass", M.run_tests_in_class, { nargs = 0 })

-- Automatically set up the key mappings when the plugin is loaded
M.setup_key_mappings()
return M
