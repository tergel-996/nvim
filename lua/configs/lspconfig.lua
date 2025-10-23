-- LSP capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Check if cmp_nvim_lsp is available and enhance capabilities
local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- On attach function
local on_attach = function(_, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc, noremap = true, silent = true }
  end

  local map = vim.keymap.set

  -- LSP actions
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  map("n", "gr", vim.lsp.buf.references, opts "Show references")
  map("n", "K", vim.lsp.buf.hover, opts "Hover documentation")
  map("n", "<leader>ra", vim.lsp.buf.rename, opts "Rename symbol")
  map("n", "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
  map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Signature help")
  map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Type definition")
end

-- LSP servers configuration
local servers = { "gopls", "ts_ls", "golangci_lint_ls", "lua_ls" }

for _, name in ipairs(servers) do
  local config = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- Special configuration for golangci-lint-langserver
  if name == "golangci_lint_ls" then
    config.cmd = { "golangci-lint-langserver" }
    config.init_options = {
      command = {
        "golangci-lint",
        "run",
        "--output.json.path",
        "stdout",
        "--show-stats=false",
        "--issues-exit-code=1",
      },
    }
  end

  -- Special configuration for lua_ls
  if name == "lua_ls" then
    config.settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            vim.fn.expand "$VIMRUNTIME/lua",
            vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
            vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    }
  end

  vim.lsp.config[name] = config
  vim.lsp.enable(name)
end
