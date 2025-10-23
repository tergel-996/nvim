# Neovim Configuration

A modern, standalone Neovim configuration focused on Go, Lua, TypeScript/JavaScript, and SQL development. Built with Lazy.nvim plugin manager, this configuration provides a complete IDE-like experience with LSP, formatting, linting, and git integration.

## Features

- 🎨 **Theme**: Kanagawa (dragon variant - darker)
- 📦 **Plugin Manager**: Lazy.nvim
- 🔧 **LSP**: Full language server support via nvim-lspconfig
- ✨ **Formatting**: Auto-format on save with conform.nvim
- 🌳 **File Explorer**: nvim-tree with icon support
- 🔍 **Fuzzy Finder**: Telescope for files, buffers, and grep
- 📊 **Git Integration**: Gitsigns for git status in signcolumn
- 🎯 **Completion**: nvim-cmp with LSP support
- ⚡ **Fast Navigation**: Flash.nvim for enhanced f/t/s motions
- 🖥️ **Tmux Integration**: Seamless navigation between tmux panes and vim windows

## Prerequisites

### Required

1. **Neovim 0.10+**
   ```bash
   nvim --version
   ```

2. **Nerd Font** - Required for icons to display properly
   - Recommended: [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)
   - [FiraCode Nerd Font](https://www.nerdfonts.com/font-downloads)
   - [Hack Nerd Font](https://www.nerdfonts.com/font-downloads)

3. **Git**
   ```bash
   git --version
   ```

### Optional (for full functionality)

- **ripgrep** - For Telescope live_grep
  ```bash
  brew install ripgrep  # macOS
  ```

- **fd** - For faster file finding
  ```bash
  brew install fd  # macOS
  ```

## Installation

1. **Backup your existing config** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   mv ~/.local/share/nvim ~/.local/share/nvim.backup
   ```

2. **Clone this configuration**:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

3. **Start Neovim**:
   ```bash
   nvim
   ```
   Lazy.nvim will automatically install all plugins on first launch.

4. **Install LSP servers and tools**:
   Mason will auto-install tools on startup. You can also manually run:
   ```vim
   :Mason
   ```

## Language Support & Tools

### Auto-installed Tools (via Mason)

The following tools are automatically installed on first startup:

#### Go Development
- **gopls** - Go language server
- **golangci-lint-langserver** - Linting language server
- **golangci-lint** - Go linter
- **gofumpt** - Stricter gofmt
- **golines** - Line length formatter (max 140 chars)

#### Lua Development
- **lua-language-server** - Lua LSP
- **stylua** - Lua formatter

#### TypeScript/JavaScript
- **typescript-language-server** - TypeScript/JavaScript LSP

#### SQL
- **sql-formatter** - SQL formatter (PostgreSQL dialect)

## LSP Configuration

LSP servers are configured in `lua/configs/lspconfig.lua`.

### Supported Languages

| Language   | LSP Server                | Auto-installed | Notes                          |
|------------|---------------------------|----------------|--------------------------------|
| Go         | gopls                     | ✅             | Full Go support                |
| Go         | golangci-lint-langserver  | ✅             | Linting integration            |
| Lua        | lua_ls                    | ✅             | Neovim API support included    |
| TypeScript | ts_ls                     | ✅             | TypeScript & JavaScript        |
| JavaScript | ts_ls                     | ✅             | Same as TypeScript             |

### Adding New LSP Servers

1. Add the server name to the `servers` table in `lua/configs/lspconfig.lua`:
   ```lua
   local servers = { "gopls", "ts_ls", "lua_ls", "your_new_server" }
   ```

2. Add the server to Mason auto-install in `lua/plugins/init.lua`:
   ```lua
   ensure_installed = {
     "your-new-lsp-server",
   }
   ```

3. Restart Neovim and run `:Mason` to verify installation.

### LSP Keybindings

| Key          | Action                    |
|--------------|---------------------------|
| `gd`         | Go to definition          |
| `gD`         | Go to declaration         |
| `gi`         | Go to implementation      |
| `gr`         | Show references           |
| `K`          | Hover documentation       |
| `<leader>ra` | Rename symbol             |
| `<leader>ca` | Code action               |
| `<leader>sh` | Signature help            |
| `<leader>D`  | Type definition           |
| `gl`         | Show line diagnostics     |
| `[d`         | Previous diagnostic       |
| `]d`         | Next diagnostic           |

## Formatting Configuration (conform.nvim)

Formatters are configured in `lua/configs/conform.lua` with **format-on-save** enabled.

### Current Formatters

| Language | Formatters               | Configuration                          |
|----------|--------------------------|----------------------------------------|
| Lua      | stylua                   | Default config                         |
| Go       | goimports → golines      | Max line length: 140, base: gofumpt   |
| SQL      | sql-formatter            | PostgreSQL dialect, UPPERCASE keywords |

### Adding New Formatters

1. Install the formatter via Mason:
   ```vim
   :Mason
   ```

2. Add configuration to `lua/configs/conform.lua`:
   ```lua
   formatters_by_ft = {
     python = { "black", "isort" },
   }
   ```

3. Configure formatter options (if needed):
   ```lua
   formatters = {
     black = {
       command = "black",
       args = { "--line-length", "100", "-" },
     },
   }
   ```

### Format on Save

Format on save is **enabled by default** with a 2-second timeout. To disable:

```lua
-- In lua/configs/conform.lua
format_on_save = false,  -- Change this line
```

### Manual Formatting

Format current buffer: `<leader>fm` (if you add the keybinding) or:
```vim
:lua require("conform").format()
```

## Shell Configuration

### PATH Setup (Critical for Formatters & Linters!)

**⚠️ Important**: Without this PATH configuration, formatters and linters installed via Mason will not work properly. This is the most common cause of "formatter not found" or "linter not working" issues.

#### What This Fixes:
- Conform.nvim formatters not running
- LSP linters not detecting issues
- Mason-installed tools not accessible
- "command not found" errors for formatters

#### Configuration Steps:

**For Zsh** (Add to `~/.zshrc`):
```bash
# Neovim Mason tools - Add this line at the end of your .zshrc
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
```

**For Bash** (Add to `~/.bashrc` or `~/.bash_profile`):
```bash
# Neovim Mason tools - Add this line at the end of your config
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
```

**For Fish** (Add to `~/.config/fish/config.fish`):
```fish
# Neovim Mason tools
fish_add_path $HOME/.local/share/nvim/mason/bin
```

#### Apply the Changes:

**Reload your shell configuration**:
```bash
# For Zsh
source ~/.zshrc

# For Bash
source ~/.bashrc  # or source ~/.bash_profile

# For Fish
source ~/.config/fish/config.fish
```

**Verify the PATH is set correctly**:
```bash
echo $PATH | grep mason
# Should output: /Users/your-username/.local/share/nvim/mason/bin
```

**Test formatter/linter availability**:
```bash
# Test if formatters are accessible
which stylua      # Should show: /Users/your-username/.local/share/nvim/mason/bin/stylua
which gofumpt     # Should show the mason bin path
which golangci-lint
```

#### Troubleshooting:

If formatters still don't work after adding to PATH:

1. **Restart your terminal completely** (not just the tab)
2. **Verify PATH in Neovim**:
   ```vim
   :echo $PATH
   ```
   Should include `/Users/your-username/.local/share/nvim/mason/bin`

3. **Check Mason installation**:
   ```vim
   :Mason
   ```
   Verify tools are installed (green checkmark)

4. **Check tool availability from Neovim**:
   ```vim
   :!which stylua
   ```

5. **Re-install the tool if needed**:
   ```vim
   :Mason
   " Press 'X' on the tool to uninstall
   " Press 'i' to install again
   ```

## Key Mappings

### General

| Key          | Action                           |
|--------------|----------------------------------|
| `<Space>`    | Leader key                       |
| `<leader>w`  | Save file                        |
| `<leader>q`  | Close buffer (go to last edited) |
| `<Esc>`      | Clear search highlights          |

### Buffer Navigation

| Key          | Action                           |
|--------------|----------------------------------|
| `<Tab>`      | Next buffer                      |
| `<Shift-Tab>`| Previous buffer                  |
| `<Shift-h>`  | Previous buffer                  |
| `<Shift-l>`  | Next buffer                      |
| `[b`         | Previous buffer                  |
| `]b`         | Next buffer                      |

### Window Navigation

| Key      | Action                    |
|----------|---------------------------|
| `<C-h>`  | Move to left window       |
| `<C-j>`  | Move to bottom window     |
| `<C-k>`  | Move to top window        |
| `<C-l>`  | Move to right window      |

**Note**: If in tmux, these navigate between tmux panes seamlessly.

### File Explorer (nvim-tree)

| Key          | Action                    |
|--------------|---------------------------|
| `<C-n>`      | Toggle file explorer      |
| `<leader>e`  | Focus file explorer       |

### Telescope (Fuzzy Finder)

| Key          | Action                    |
|--------------|---------------------------|
| `<leader>ff` | Find files                |
| `<leader>fa` | Find all files (hidden)   |
| `<leader>fw` | Live grep (search text)   |
| `<leader>fb` | Find buffers              |
| `<leader>fh` | Help tags                 |
| `<leader>fo` | Recent files              |
| `<leader>fz` | Fuzzy find in buffer      |
| `<leader>cm` | Git commits               |
| `<leader>gt` | Git status                |

### Git (Gitsigns)

| Key           | Action                    |
|---------------|---------------------------|
| `]h`          | Next hunk                 |
| `[h`          | Previous hunk             |
| `<leader>ghs` | Stage hunk                |
| `<leader>ghr` | Reset hunk                |
| `<leader>ghS` | Stage buffer              |
| `<leader>ghR` | Reset buffer              |
| `<leader>ghp` | Preview hunk inline       |
| `<leader>ghb` | Blame line                |
| `<leader>ghd` | Diff this                 |

### Flash (Enhanced Navigation)

| Key  | Mode    | Action                    |
|------|---------|---------------------------|
| `s`  | n/x/o   | Flash jump                |
| `S`  | n/x/o   | Flash treesitter          |
| `r`  | o       | Remote flash              |
| `R`  | o/x     | Treesitter search         |

### Editing

| Key  | Mode    | Action                    |
|------|---------|---------------------------|
| `J`  | visual  | Move line down            |
| `K`  | visual  | Move line up              |
| `<`  | visual  | Indent left               |
| `>`  | visual  | Indent right              |
| `p`  | visual  | Paste without yank        |

## Plugin List

### UI & Appearance
- **kanagawa.nvim** - Dark colorscheme
- **lualine.nvim** - Statusline
- **bufferline.nvim** - Buffer tabs
- **nvim-web-devicons** - File icons
- **mini.indentscope** - Indent scope animation
- **mini.animate** - Cursor & scroll animation

### Navigation & Editing
- **telescope.nvim** - Fuzzy finder
- **nvim-tree.lua** - File explorer
- **flash.nvim** - Enhanced navigation
- **nvim-surround** - Surround text objects
- **vim-tmux-navigator** - Tmux integration
- **Comment.nvim** - Easy commenting
- **nvim-autopairs** - Auto pairs

### LSP & Completion
- **nvim-lspconfig** - LSP configurations
- **nvim-cmp** - Completion engine
- **cmp-nvim-lsp** - LSP completion source
- **cmp-buffer** - Buffer completion
- **cmp-path** - Path completion
- **mason.nvim** - LSP/tool installer
- **mason-tool-installer.nvim** - Auto-install tools

### Formatting & Linting
- **conform.nvim** - Formatter with format-on-save

### Git
- **gitsigns.nvim** - Git decorations & actions

### Treesitter
- **nvim-treesitter** - Syntax highlighting & more

### Utilities
- **which-key.nvim** - Keybinding hints
- **plenary.nvim** - Lua utility library

## Troubleshooting

### Icons not showing
- Ensure you're using a Nerd Font in your terminal
- Verify font is set correctly in terminal settings

### LSP not working
- Check LSP status: `:LspInfo`
- Verify server installed: `:Mason`
- Check PATH includes Mason bin directory

### Formatter not working
1. Verify formatter installed: `:Mason`
2. Check PATH: `:echo $PATH` (should include mason/bin)
3. Test formatter manually:
   ```bash
   which stylua  # or your formatter
   ```

### Format on save not working
- Verify `format_on_save` is enabled in `lua/configs/conform.lua`
- Check for errors: `:messages`
- Test manual format: `:lua require("conform").format()`

## Customization

### Changing Theme

Edit `lua/plugins/init.lua` and modify the colorscheme plugin:

```lua
-- Available kanagawa variants:
-- "kanagawa-wave" (dark blue tones)
-- "kanagawa-dragon" (darker, current theme)
-- "kanagawa-lotus" (light theme)
vim.cmd [[colorscheme kanagawa-dragon]]
```

### Modifying Keybindings

Edit `lua/mappings.lua`:

```lua
map("n", "<leader>your_key", "<cmd>YourCommand<CR>", { desc = "Description" })
```

### Adding Plugins

Add to `lua/plugins/init.lua`:

```lua
{
  "username/plugin-name",
  lazy = false,  -- or event/cmd/keys for lazy loading
  config = function()
    -- Plugin setup
  end,
}
```

## File Structure

```
~/.config/nvim/
├── init.lua                      # Entry point
├── lua/
│   ├── options.lua              # Neovim options
│   ├── mappings.lua             # Keybindings
│   ├── plugins/
│   │   └── init.lua             # Plugin definitions
│   └── configs/
│       ├── lspconfig.lua        # LSP configuration
│       ├── conform.lua          # Formatter configuration
│       ├── telescope.lua        # Telescope settings
│       ├── nvimtree.lua         # File explorer settings
│       ├── lualine.lua          # Statusline config
│       ├── bufferline.lua       # Bufferline config
│       ├── cmp.lua              # Completion config
│       ├── gitsigns.lua         # Git config
│       ├── miniindentscope.lua  # Indent animation
│       └── minianimate.lua      # Cursor animation
└── README.md                     # This file
```

## License

MIT License - See LICENSE file for details.

## Credits

Originally based on NvChad, now fully standalone. Special thanks to:
- NvChad for the initial inspiration
- All plugin authors for their amazing work
