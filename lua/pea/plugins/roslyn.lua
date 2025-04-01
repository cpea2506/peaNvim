return {
	"seblyng/roslyn.nvim",
	ft = "cs",
	opts = function()
		local function apply_vs_text_edit(edit)
			local bufnr = vim.api.nvim_get_current_buf()
			local start_line = edit.range.start.line
			local start_char = edit.range.start.character
			local end_line = edit.range["end"].line
			local end_char = edit.range["end"].character

			local newText = string.gsub(edit.newText, "\r", "")
			local lines = vim.split(newText, "\n")
			local placeholder_row = -1
			local placeholder_col = -1

			for i, line in ipairs(lines) do
				local placeholder = string.find(line, "%$0")

				if placeholder then
					lines[i] = string.gsub(line, "%$0", "", 1)
					placeholder_row = start_line + i - 1
					placeholder_col = placeholder - 1

					break
				end
			end

			vim.api.nvim_buf_set_text(bufnr, start_line, start_char, end_line, end_char, lines)

			if placeholder_row ~= -1 and placeholder_col ~= -1 then
				local win = vim.api.nvim_get_current_win()
				vim.api.nvim_win_set_cursor(win, { placeholder_row + 1, placeholder_col })
			end
		end

		vim.api.nvim_create_autocmd("InsertCharPre", {
			pattern = "*.cs",
			callback = function()
				local char = vim.v.char

				if char ~= "/" then
					return
				end

				local row, col = unpack(vim.api.nvim_win_get_cursor(0))
				row, col = row - 1, col + 1
				local bufnr = vim.api.nvim_get_current_buf()
				local uri = vim.uri_from_bufnr(bufnr)

				local params = {
					_vs_textDocument = { uri = uri },
					_vs_position = { line = row, character = col },
					_vs_ch = char,
					_vs_options = { tabSize = 4, insertSpaces = true },
				}

				-- NOTE: we should send textDocument/_vs_onAutoInsert request only after buffer has changed.
				vim.defer_fn(function()
					vim.lsp.buf_request(bufnr, "textDocument/_vs_onAutoInsert", params)
				end, 1)
			end,
		})

		return {
			config = {
				settings = {
					["csharp|inlay_hints"] = {
						csharp_enable_inlay_hints_for_implicit_object_creation = true,
						csharp_enable_inlay_hints_for_implicit_variable_types = true,
						csharp_enable_inlay_hints_for_lambda_parameter_types = true,
						csharp_enable_inlay_hints_for_types = true,
						dotnet_enable_inlay_hints_for_indexer_parameters = true,
						dotnet_enable_inlay_hints_for_literal_parameters = true,
						dotnet_enable_inlay_hints_for_object_creation_parameters = true,
						dotnet_enable_inlay_hints_for_other_parameters = true,
						dotnet_enable_inlay_hints_for_parameters = true,
						dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
					},
					["csharp|code_lens"] = {
						dotnet_enable_references_code_lens = true,
					},
					["csharp|completion"] = {
						dotnet_show_completion_items_from_unimported_namespaces = true,
						dotnet_show_name_completion_suggestions = true,
					},
					["csharp|symbol_search"] = {
						dotnet_search_reference_assemblies = true,
					},
				},
				capabilities = {
					textDocument = {
						_vs_onAutoInsert = { dynamicRegistration = false },
					},
				},
				handlers = {
					["textDocument/_vs_onAutoInsert"] = function(err, result, _)
						if err or not result then
							return
						end
						apply_vs_text_edit(result._vs_textEdit)
					end,
				},
				on_attach = function(client, _)
					if client.is_hacked then
						return
					end

					client.is_hacked = true

					-- let the runtime know the server can do semanticTokens/full now
					client.server_capabilities = vim.tbl_deep_extend("force", client.server_capabilities, {
						semanticTokensProvider = {
							full = true,
						},
					})

					-- monkey patch the request proxy
					local request_inner = client.request

					function client:request(method, params, handler, req_bufnr)
						if method ~= vim.lsp.protocol.Methods.textDocument_semanticTokens_full then
							return request_inner(self, method, params, handler)
						end

						local target_bufnr = vim.uri_to_bufnr(params.textDocument.uri)
						local line_count = vim.api.nvim_buf_line_count(target_bufnr)
						local last_line = vim.api.nvim_buf_get_lines(target_bufnr, line_count - 1, line_count, true)[1]

						return request_inner(self, "textDocument/semanticTokens/range", {
							textDocument = params.textDocument,
							range = {
								["start"] = {
									line = 0,
									character = 0,
								},
								["end"] = {
									line = line_count - 1,
									character = string.len(last_line) - 1,
								},
							},
						}, handler, req_bufnr)
					end
				end,
			},
			filewatching = "roslyn",
		}
	end,
}
