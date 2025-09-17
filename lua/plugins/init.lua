return {
  -- tmux vim-tmux-navigator
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  -- nvim surroung
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },

  -- telescope configs
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    opts = function()
      local tlsp = require "nvchad.configs.telescope"
      tlsp.pickers = vim.tbl_deep_extend("force", tlsp.pickers or {}, {
        find_files = {
          hidden = true, -- Show hidden files in find_files picker
        },
      })
      return tlsp
    end,
  },

  -- formatter and format on save
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  -- git stuff
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = function()
      return require "configs.gitsigns"
    end,
  },

  -- animate the indentscope
  {
    "echasnovski/mini.indentscope",
    version = "*",
    lazy = false,
    opts = require("configs.miniindentscope").opts,
    init = require("configs.miniindentscope").init,
  },

  -- animate the cursor and scrolling
  {
    "echasnovski/mini.animate",
    version = "*",
    lazy = false,
    opts = require "configs.minianimate",
  },

  -- lsp configs
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- lang syntax
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "go",
        "gomod",
        "gosum",
        "javascript",
      },
    },
  },

  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate", -- updates registry every time
    config = true, -- use default config for mason core
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        -- Go
        "gopls",
        "golangci-lint-langserver",
        "golangci-lint",
        "gofumpt",
        "golines",

        -- Lua
        "lua-language-server",
        "stylua",

        -- TypeScript / JS
        "typescript-language-server",

        -- SQL
        "sql-formatter",
      },
      run_on_start = true, -- install on startup if missing
      auto_update = false, -- disable auto updates (optional)
    },
  },
  -- flash plugin ench f and t
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },
}
