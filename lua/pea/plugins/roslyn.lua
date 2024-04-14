return {
	"EnochMtzR/roslyn.nvim",
	event = "BufRead *.cs",
	config = function()
		local lsp = require("pea.plugins.lsp.utils")

		require("roslyn").setup({
			on_attach = lsp.on_attach,
			capabilities = vim.tbl_deep_extend("force", lsp.capabilities(), {
				workspace = {
					didChangeWatchedFiles = {
						dynamicRegistration = false,
					},
				},
			}),
			settings = {
				["csharp|inlay_hints"] = {
					["csharp_enable_inlay_hints_for_implicit_object_creation"] = true,
					["csharp_enable_inlay_hints_for_implicit_variable_types"] = true,
					["csharp_enable_inlay_hints_for_lambda_parameter_types"] = true,
					["csharp_enable_inlay_hints_for_types"] = true,
					["dotnet_enable_inlay_hints_for_indexer_parameters"] = true,
					["dotnet_enable_inlay_hints_for_literal_parameters"] = true,
					["dotnet_enable_inlay_hints_for_object_creation_parameters"] = true,
					["dotnet_enable_inlay_hints_for_other_parameters"] = true,
					["dotnet_enable_inlay_hints_for_parameters"] = true,
					["dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix"] = true,
					["dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name"] = true,
					["dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent"] = true,
				},
			},
		})
	end,
}
