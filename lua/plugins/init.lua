return {
  -- Colorscheme
  {
    "slugbyte/lackluster.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("lackluster").setup {}
      vim.cmd [[colorscheme lackluster-hack]]
    end,
  },

  -- Icons (ascii, monochrome)
  {
    "echasnovski/mini.icons",
    lazy = false,
    priority = 999,
    opts = {
      style = "ascii",
    },
    config = function(_, opts)
      require("mini.icons").setup(opts)
      local colors = { "Azure", "Blue", "Cyan", "Green", "Orange", "Purple", "Red", "Yellow" }
      for _, name in ipairs(colors) do
        vim.api.nvim_set_hl(0, "MiniIcons" .. name, { fg = "#a0a0a0" })
      end
      vim.api.nvim_set_hl(0, "MiniIconsGrey", { fg = "#cccccc" })
    end,
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "echasnovski/mini.icons" },
    lazy = false,
    opts = function()
      return require "configs.lualine"
    end,
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "echasnovski/mini.icons" },
    lazy = false,
    opts = function()
      return require "configs.bufferline"
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "echasnovski/mini.icons" },
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require("nvim-tree").setup(require "configs.nvimtree")
      vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = "#cccccc" })
      vim.api.nvim_set_hl(0, "NvimTreeFolderArrowClosed", { fg = "#cccccc" })
      vim.api.nvim_set_hl(0, "NvimTreeFolderArrowOpen", { fg = "#cccccc" })
    end,
  },

  -- Tmux navigation
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {}
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    opts = function()
      return require "configs.telescope"
    end,
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = function()
      return require "configs.gitsigns"
    end,
  },

  -- Indent scope animation
  {
    "echasnovski/mini.indentscope",
    version = "*",
    event = "BufReadPre",
    opts = require("configs.miniindentscope").opts,
    init = require("configs.miniindentscope").init,
  },

  -- Smooth scroll
  {
    "folke/snacks.nvim",
    lazy = false,
    opts = {
      scroll = {},
    },
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "go",
        "gomod",
        "gosum",
        "javascript",
        "typescript",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Mason
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    build = ":MasonUpdate",
    opts = {},
  },

  -- Mason tool installer
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
      run_on_start = true,
      auto_update = false,
    },
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      require "configs.cmp"
    end,
  },

  -- Flash (enhanced f/t)
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

  -- Which-key (for showing keybindings)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Comment
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
}
