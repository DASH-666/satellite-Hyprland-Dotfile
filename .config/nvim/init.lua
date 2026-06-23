-- Normal Mode
-- Ctrl + n → Toggle NvimTree
-- F8 → Toggle Tagbar
-- Ctrl + j → Vertical split
-- Ctrl + k → Horizontal split
-- Ctrl + Shift + Left → Resize vertical split smaller
-- Ctrl + Shift + Right → Resize vertical split larger
-- Ctrl + Shift + Up → Resize horizontal split smaller
-- Ctrl + Shift + Down → Resize horizontal split larger
-- Ctrl + Left → Change focus horizontal left
-- Ctrl + Right → Change focus horizontal right
-- Ctrl + Up → Change focus vertical up
-- Ctrl + Down → Change focus vertical down
-- Shift + s → Save buffer
-- Shift + q → Quit buffer
-- Ctrl + s → Save buffer
-- Ctrl + q → Quit buffer
-- Ctrl + e → Previous tab
-- Ctrl + r → Next tab
-- Ctrl + w → New tab
-- ; → Command mode (:)
-- Ctrl + d → Duplicate line
-- Ctrl + / → Comment line (Toggle)
-- Ctrl + i → Show which-key menu
-- Ctrl + Space → Telescope find files
-- Alt + t → Toggle terminal
-- Ctrl + c → Copy selected text
-- Ctrl + x → Cut selected text
-- Ctrl + v → Paste from system clipboard
-- Ctrl + a → Select all text
-- Ctrl + 1–9 → Switch to tab 1–9

-- Insert Mode
-- Ctrl + v → Paste from system clipboard
-- Ctrl + s → Save buffer
-- Ctrl + q → Exit insert mode
-- Ctrl + d → Duplicate line
-- Ctrl + a → Select all text
-- Ctrl + n → Toggle NvimTree
-- Ctrl + e → Previous tab
-- Ctrl + r → Next tab
-- Ctrl + w → New tab
-- F8 → Toggle Tagbar
-- Ctrl + j → Vertical split
-- Ctrl + k → Horizontal split
-- Ctrl + / → Comment line (Toggle)
-- Ctrl + i → Show which-key menu
-- Ctrl + Space → Telescope find files
-- Alt + t → Toggle terminal
-- Ctrl + 1–9 → Switch to tab 1–9

-- Visual Mode
-- Ctrl + c → Copy selected text
-- Ctrl + x → Cut selected text
-- Ctrl + v → Paste from system clipboard
-- Ctrl + a → Select all text

-- NvimTree Default Keys
-- o / Enter → Open file/folder
-- v → Open in vertical split
-- h → Open in horizontal split
-- i → Toggle info view
-- r → Rename
-- a → New file
-- d → Delete
-- x → Cut
-- c → Copy
-- p → Paste
-- s → Sort files
-- R → Refresh tree
-- ? → Help

-- Tagbar Default Keys
-- Enter → Jump to item
-- o / Space → Expand/Collapse node
-- Ctrl + q → Quit Tagbar window

-- Completion (nvim-cmp)
-- Tab → Next completion / Expand snippet
-- Shift + Tab → Previous completion / Jump to previous snippet
-- Enter → Confirm completion

-- ===================================
-- BOOTSTRAP LAZY.NVIM
-- ===================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ===================================
-- BASIC SETTINGS
-- ===================================
vim.o.termguicolors = true

-- ===================================
-- PLUGINS
-- ===================================
require("lazy").setup({

  -- lazy.nvim
  "folke/lazy.nvim",

  -- indent-blankline.nvim
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = { char = "│" },
        scope = { enabled = true },
        exclude = {
          filetypes = { "dashboard", "alpha", "starter", "lazy" },
        },
      })
    end,
  },

  -- nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    init = function()
      vim.defer_fn(function()
        pcall(function()
          require("nvim-treesitter.configs").setup({
            ensure_installed = { "python", "bash", "cpp", "lua", "c", "json", "css", "cmake" },
            highlight = { enable = true },
            additional_vim_regex_highlighting = false,
            rainbow = {
              enable = true,
              extended_mode = true,
              max_file_lines = 1000,
            },
          })
        end)
      end, 500)
    end,
  },

  -- nvim-treesitter-context
  "nvim-treesitter/nvim-treesitter-context",

  -- dashboard-nvim
  {
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    config = function()
      require("dashboard").setup({
        theme = "hyper",
      })
    end,
  },

  -- dusklight.vim
  {
    "drazil100/dusklight.vim",
    config = function()
      vim.cmd("colorscheme dusklight")
    end,
  },

  -- nvim-colorizer.lua
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        "*",
      }, {
        RGB = true,
        RRGGBB = true,
        names = true,
        RRGGBBAA = true,
        css = true,
        css_fn = true,
      })
    end,
  },

  -- nvim-tree.lua
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({})
    end,
  },

  -- which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 100,
      preset = "modern",
    },
    config = function()
      local wk = require("which-key")
      wk.setup({ delay = 100, preset = "modern" })
    end,
  },
  
  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({})
    end,
  },

  -- mason.nvim
  "williamboman/mason.nvim",

  -- mason-lspconfig.nvim
  "williamboman/mason-lspconfig.nvim",

  -- nvim-lspconfig
  "neovim/nvim-lspconfig",

  -- bufferline
  {
  	'akinsho/bufferline.nvim', 
  	version = "*", 
  	dependencies = 'nvim-tree/nvim-web-devicons',
  	config = function()
  	  require("bufferline").setup({})
  	end,
  },
  
  -- nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },

  -- rainbow-delimiters.nvim (disabled)
  --[[{
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      vim.g.rainbow_delimiters = {
        strategy = { ["*"] = require("rainbow-delimiters.strategy.global") },
        query = { ["*"] = "rainbow-delimiters" },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },]]--

  -- nvim-autopairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- coment
  {
      "numToStr/Comment.nvim",
      config = function()
        require('Comment').setup({})
       end,
      opts = {
          -- add any options here
      }
  },

  -- lualine.nvim
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          section_separators = "",
          component_separators = "",
        },
      })
    end,
  },

  -- tagbar
  "majutsushi/tagbar",

  -- toggleterm.nvim
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        size = function(term) return math.floor(vim.o.lines / 3) end,
        open_mapping = [[<A-t>]],
        direction = "horizontal",
        hide_numbers = true,
        shade_terminals = true,
        start_in_insert = true,
        persist_size = true,
        close_on_exit = true,
      })
    end,
  },
})

-- ===================================
-- OPTIONS AND SETTINGS
-- ===================================
vim.cmd("colorscheme dusklight")
--vim.opt.termguicolors = true

vim.wo.number = true
vim.o.ignorecase = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.cindent = true
vim.o.mouse = "a"
vim.cmd("syntax enable")

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.ruler = true
vim.o.showcmd = true
vim.o.laststatus = 2
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.encoding = "utf-8"

-- Transparent background
vim.cmd([[
  hi Normal guibg=NONE
  hi NormalNC guibg=NONE
  hi VertSplit guibg=NONE
  hi StatusLine guibg=NONE
  hi LineNr guibg=NONE
  hi SignColumn guibg=NONE
  hi CursorLineNr guibg=NONE
]])

-- Yank highlight
vim.cmd([[
  augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank { higroup="IncSearch", timeout=500 }
  augroup END
]])

-- Remove trailing whitespace on save
vim.cmd([[
  autocmd BufWritePre * %s/\s\+$//e
]])

-- ===================================
-- KEYMAPS
-- ===================================
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", opts)
vim.keymap.set("n", "<F8>", ":TagbarToggle<CR>", opts)
vim.keymap.set("n", "<C-j>", ":vsplit<CR>", opts)
vim.keymap.set("n", "<C-k>", ":split<CR>", opts)
vim.keymap.set("n", "<C-S-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-S-Right>", ":vertical resize +2<CR>", opts)
vim.keymap.set("n", "<C-S-Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<C-S-Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<C-Left>", "<C-w>h", opts)
vim.keymap.set("n", "<C-Right>", "<C-w>l", opts)
vim.keymap.set("n", "<C-Up>", "<C-w>k", opts)
vim.keymap.set("n", "<C-Down>", "<C-w>j", opts)
vim.keymap.set("n", "<S-s>", ":w<CR>", opts)
vim.keymap.set("n", "<S-q>", ":q<CR>", opts)
vim.keymap.set("n", "<C-s>", ":w<CR>", opts)
vim.keymap.set("n", "<C-q>", ":q!<CR>", opts)
vim.keymap.set("n", "<C-e>", ":tabprevious<CR>", opts)
vim.keymap.set("n", "<C-r>", ":tabnext<CR>", opts)
vim.keymap.set("n", "<C-w>", ":tabnew<CR>", opts)
vim.keymap.set("n", ";", ":", opts)
vim.keymap.set("n", "<C-d>", "Yp", opts)
vim.keymap.set("n", "<C-/>", "gcc", { remap = true })
vim.keymap.set({ "n", "i" }, "<C-i>", function() require("which-key").show({ global = true }) end, { desc = "Show which-key" })
vim.keymap.set({ "n", "i" }, "<C-Space>", function() require("telescope.builtin").find_files() end, { desc = "Find files" })
vim.keymap.set({ "n", "i" }, "<A-t>", function() require("toggleterm").toggle() end, { desc = "Toggle terminal" })
vim.keymap.set({ "n", "v" }, "<C-c>", '"+y', opts)
vim.keymap.set({ "n", "v" }, "<C-x>", '"+d', opts)
vim.keymap.set({ "n", "v" }, "<C-v>", '"+p', opts)
vim.keymap.set({ "n", "v" }, "<C-a>", "ggVG", opts)
vim.keymap.set("i", "<C-v>", "<C-r>+", opts)
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", opts)
vim.keymap.set("i", "<C-q>", "<Esc>", opts)
vim.keymap.set("i", "<C-d>", "<Esc>YpA", opts)
vim.keymap.set("i", "<C-a>", "<Esc>ggVG", opts)
vim.keymap.set("i", "<C-n>", "<Esc>:NvimTreeToggle<CR>", opts)
vim.keymap.set("i", "<C-e>", "<Esc>:tabprevious<CR>", opts)
vim.keymap.set("i", "<C-r>", "<Esc>:tabnext<CR>", opts)
vim.keymap.set("i", "<C-w>", "<Esc>:tabnew<CR>", opts)
vim.keymap.set("i", "<F8>", "<Esc>:TagbarToggle<CR>", opts)
vim.keymap.set("i", "<C-j>", "<Esc>:vsplit<CR>", opts)
vim.keymap.set("i", "<C-k>", "<Esc>:split<CR>", opts)
vim.keymap.set("i", "<C-/>", "<Esc>gcca", { remap = true })

for i = 1, 9 do
  vim.keymap.set("n", "<C-" .. i .. ">", ":tabn " .. i .. "<CR>", opts)
end

for i = 1, 9 do
  vim.keymap.set("i", "<C-" .. i .. ">", "<Esc>:tabn " .. i .. "<CR>", opts)
end

-- ===================================
-- MASON & LSP
-- ===================================
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "pyright", "clangd", "bashls", "lua_ls", "cssls", "jsonls", "neocmakelsp" },
  automatic_installation = true,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_capabilities = pcall(require, "cmp_nvim_lsp")
if has_cmp then
  capabilities = cmp_capabilities.default_capabilities()
end

local servers = {
  pyright = {},
  clangd = {
  	cmd = {
  	      "clangd",
  	      "--compile-commands-dir=build",  -- یا مسیر کامل
  	      "--background-index",
  	    }
  },
  bashls = {},
  lua_ls = {},
  cssls = {},
  jsonls = {},
  neocmakelsp = {},
}

for server_name, server_config in pairs(servers) do
  server_config.capabilities = capabilities
  server_config.on_attach = function(client, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  end

  vim.lsp.config[server_name] = server_config
end

for server_name, _ in pairs(servers) do
  pcall(function()
    vim.lsp.enable(server_name)
  end)
end

-- ===================================
-- DIAGNOSTICS
-- ===================================
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
})
