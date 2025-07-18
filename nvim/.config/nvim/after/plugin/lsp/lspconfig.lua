-- import lspconfig plugin safely
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

local configs = require("lspconfig.configs")

local keymap = vim.keymap -- for conciseness

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
	-- auto import packages or remove packages from go files
	vim.cmd(
		"autocmd BufWritePre *.go lua vim.lsp.buf.code_action({context = {only = {'source.organizeImports' }}, apply = true})"
	)

	-- keybind options
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- set keybinds
	keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
	keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
	--	commenting peek_definition since it's colliding with pasting `p`.
	--	Due to this mapping, editor waits for some time for another letter thus, slowing pasting speed.
	--	keymap.set("n", "pd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
	keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts) -- go to the file and see definition
	keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
	keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
	keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
	keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
	keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
	keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
	keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
	keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
	keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", opts) -- see outline on right hand side
	keymap.set("n", "<space>f", function()
		vim.lsp.buf.format({ async = true })
	end, opts)
	keymap.set("n", "gr", vim.lsp.buf.references, opts)

	-- typescript specific keymaps (e.g. rename file and update imports)
	if client.name == "tsserver" then
		keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>") -- rename file and update imports
		keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>") -- organize imports (not in youtube nvim video)
		keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables (not in youtube nvim video)
	end
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Change the Diagnostic symbols in the sign column (gutter)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- configure html server
lspconfig["html"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure typescript server with plugin
lspconfig.ts_ls.setup({
	server = {
		capabilities = capabilities,
		on_attach = on_attach,
	},
})

-- configure css server
lspconfig["cssls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure tailwinnpm install -g @angular/language-serverdcss server
lspconfig["tailwindcss"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
-- configure go server
lspconfig["gopls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		gopls = {
			gofumpt = true,
			experimentalPostfixCompletions = true,
			analyses = {
				unusedparams = true,
				shadow = true,
			},
			staticcheck = true,
		},
	},
})

-- configure emmet language server
lspconfig["emmet_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
})

-- configure lua server (with special settings)
lspconfig["lua_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		-- custom settings for lua
		Lua = {
			-- make the language server recognize "vim" global
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- make language server aware of runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})

lspconfig["pyright"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "python" },
})

lspconfig["clangd"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- lspconfig["solargraph"].setup({
-- 	cmd = { "bundle", "exec", "solargraph", "stdio" },
-- 	on_attach = on_attach,
-- 	capabilities = capabilities,
-- 	settings = {
-- 		solargraph = {
-- 			diagnostics = true,
-- 			autoformat = false,
-- 			completion = true,
-- 			folding = true,
-- 			references = true,
-- 			rename = true,
-- 			symbols = true,
-- 			hover = true,
-- 		},
-- 	},
-- })

lspconfig.ruby_lsp.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	init_options = {
		formatter = "standard",
		linters = { "standard" },
		addonSettings = {
			["Ruby LSP Rails"] = {
				enablePendingMigrationsPrompt = false,
			},
		},
	},
})

if not configs.fuzzy_ls then
	configs.fuzzy_ls = {
		default_config = {
			cmd = { "fuzzy" },
			filetypes = { "ruby" },
			root_dir = function(fname)
				return lspconfig.util.find_git_ancestor(fname)
			end,
			settings = {},
			init_options = {
				allocationType = "ram",
				indexGems = true,
				reportDiagnostics = true,
			},
		},
	}
end

-- Copy the binary for respective machine from https://github.com/doompling/fuzzy_ruby_server/tree/master/bin
-- Make it executable, rename it to "fuzzy"
-- Move it to location in PATH eg: /local/bin
lspconfig.fuzzy_ls.setup({
	on_attach = on_attach,
})

lspconfig["angularls"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = {
		"ngserver",
		"--stdio",
		"--tsProbeLocations",
		"./node_modules",
		"--ngProbeLocations",
		"./node_modules",
	},
})
