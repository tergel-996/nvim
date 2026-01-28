# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a standalone Neovim configuration using Lazy.nvim for plugin management. It targets Go, Lua, TypeScript/JavaScript, and SQL development with LSP, auto-formatting, and git integration.

## Architecture

**Entry point**: `init.lua` bootstraps Lazy.nvim, loads plugins from `lua/plugins/init.lua`, then loads `options.lua` and `mappings.lua`.

**Plugin configs**: Each major plugin has a dedicated config file in `lua/configs/`. Plugins reference these via `require "configs.<name>"`.

**LSP setup**: Uses the new `vim.lsp.config` and `vim.lsp.enable` API (Neovim 0.10+). Servers are defined in `lua/configs/lspconfig.lua`. To add a new LSP:
1. Add server name to `servers` table in `lua/configs/lspconfig.lua`
2. Add to Mason's `ensure_installed` in `lua/plugins/init.lua`

**Formatting**: Handled by conform.nvim with format-on-save enabled. Formatters configured in `lua/configs/conform.lua`.

## Key Files

| File | Purpose |
|------|---------|
| `lua/plugins/init.lua` | All plugin definitions with lazy-loading settings |
| `lua/mappings.lua` | All keybindings (leader = Space) |
| `lua/configs/lspconfig.lua` | LSP server setup and on_attach keybinds |
| `lua/configs/conform.lua` | Formatter configuration (goimports, golines, stylua, sql-formatter) |

## Language Support

- **Go**: gopls + golangci-lint-langserver for linting, goimports + golines (140 char max) for formatting
- **Lua**: lua_ls with Neovim API support, stylua for formatting
- **TypeScript/JS**: ts_ls
- **SQL**: sql-formatter (PostgreSQL dialect, uppercase keywords)

## Important Patterns

- Plugins default to `lazy = true`; eager-loaded plugins explicitly set `lazy = false`
- Window/buffer navigation uses vim-tmux-navigator when in tmux (C-h/j/k/l)
- `<leader>q` closes buffer and switches to last edited buffer (custom logic in mappings.lua)
- Mason tools path (`~/.local/share/nvim/mason/bin`) must be in shell PATH for formatters to work

## Testing Changes

Open nvim and verify:
- `:Lazy` - plugin status
- `:LspInfo` - LSP attachment
- `:Mason` - tool installation status
- `:checkhealth` - overall health check
