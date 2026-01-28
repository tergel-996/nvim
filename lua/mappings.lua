local map = vim.keymap.set

-- General mappings
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save File" })
map("n", "<leader>q", function()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })

  -- If only one buffer, just delete it
  if #buffers <= 1 then
    vim.cmd("bd")
    return
  end

  -- Try to go to alternate buffer (last edited)
  local alt_buf = vim.fn.bufnr("#")

  -- Check if alternate buffer is valid and listed
  if alt_buf ~= -1 and alt_buf ~= current_buf and vim.fn.buflisted(alt_buf) == 1 then
    vim.api.nvim_set_current_buf(alt_buf)
    vim.cmd("bd " .. current_buf)
  else
    -- Fallback: find next valid buffer
    local next_buf = nil
    for i, buf in ipairs(buffers) do
      if buf.bufnr == current_buf then
        if i < #buffers then
          next_buf = buffers[i + 1].bufnr
        else
          next_buf = buffers[1].bufnr
        end
        break
      end
    end

    if next_buf then
      vim.api.nvim_set_current_buf(next_buf)
      vim.cmd("bd " .. current_buf)
    end
  end
end, { desc = "Close buffer and go to last edited" })

-- Prevent visual paste from overwriting the yank register
map("v", "p", '"_dP', { desc = "Paste without overwriting yank" })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Tmux navigation (override window navigation if in tmux)
if os.getenv "TMUX" then
  map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Tmux navigate left" })
  map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Tmux navigate down" })
  map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Tmux navigate up" })
  map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Tmux navigate right" })
  map("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", { desc = "Tmux navigate previous" })
end

-- Resize windows with arrows
map("n", "<Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Move lines up/down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Better indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Diagnostic keymaps
map("n", "gl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- Telescope keymaps
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>", { desc = "Find all files" })
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Fuzzy find in buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "Git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "Git status" })

-- NvimTree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer" })

-- Database UI
map("n", "<leader>db", function()
  -- Check if DBUI is already open
  local dbui_open = false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "dbui" then
      dbui_open = true
      vim.api.nvim_set_current_win(win)
      break
    end
  end

  -- If not open, toggle it
  if not dbui_open then
    vim.cmd("DBUIToggle")
  end
end, { desc = "Show and focus Database UI" })

-- Comment (handled by Comment.nvim plugin with default keymaps)
-- gcc - line comment
-- gbc - block comment
-- gc in visual mode - comment selection
