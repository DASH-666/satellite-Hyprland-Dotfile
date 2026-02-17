-- Normal Mode
-- Ctrl + n → Toggle NvimTree
-- F8 → Toggle Tagbar
-- Ctrl + j → Vertical split
-- Ctrl + k → Horizontal split
-- Ctrl + Shift + Left → Resize vertical split smaller
-- Ctrl + Shift + Right → Resize vertical split larger
-- Ctrl + Shift + Up → Resize horizontal split smaller
-- Ctrl + Down → Resize horizontal split larger
-- Ctrl + Left → Change focus horizontal left
-- Ctrl + Right → Change focus horizontal right
-- Ctrl + Up → Change focus vertical up
-- Ctrl + Down → Change focus vertical done
-- Shift + s → Save buffer
-- Shift + q → Quit buffer
-- Ctrl + s → Save buffer
-- Ctrl + q → Quit buffer
-- Ctrl + e → Previous tab
-- Ctrl + r → Next tab
-- Ctrl + w → New tab
-- ; → Command mode (:)
-- Ctrl + d → Duplicate line
-- Ctrl + c → Copy selected text
-- Ctrl + x → Cut selected text
-- Ctrl + v → Paste from system clipboard
-- Ctrl + a → Select all text
-- Ctrl + 1–9 → Switch to tab 1–9

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

-- ToggleTerm Default Keys
-- Alt + t → Toggle floating terminal

-- Completion (nvim-cmp)
-- Tab → Next completion / Expand snippet
-- Shift + Tab → Previous completion / Jump to previous snippet
-- Enter → Confirm completion

-- Insert Mode
-- Ctrl + v → Paste from system clipboard
-- Ctrl + s → Save buffer
-- Ctrl + q → Exit insert mode
-- Ctrl + d → Duplicate line
-- Ctrl + a → Select all text

-- ===================================
-- PACKER PLUGINS
-- ===================================
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Indent guides
  use {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup {
        indent = { char = "│" },
        scope = { enabled = true }
      }
    end
  }

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter-context',
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = { "python", "bash", "cpp", "lua", "c", "json", "css" },
        highlight = { enable = true },
        additional_vim_regex_highlighting = false,
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = 1000,
        }
      }
    end
  }

  -- Colorschemes
  use {
    "navarasu/onedark.nvim",
    config = function()
      require('onedark').setup {
        style = 'deep',
        transparent = true,
      }
      require('onedark').load()
    end
  }

  -- Colorizer (رنگ کد‌ها)
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require'colorizer'.setup(
        { '*' },
        {
          RGB = true,
          RRGGBB = true,
          names = true,
          RRGGBBAA = true,
          css = true,
          css_fn = true,
        }
      )
    end
  }

  -- File explorer
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('nvim-tree').setup {}
    end
  }

  -- LSP & Mason
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'

  -- Completion
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'saadparwaiz1/cmp_luasnip',
    }
  }

  -- Snippets
  use 'L3MON4D3/LuaSnip'

  -- Rainbow delimiters
  use {
    'HiPhish/rainbow-delimiters.nvim',
    config = function()
      vim.g.rainbow_delimiters = {
        strategy = { [''] = require('rainbow-delimiters.strategy.global') },
        query = { [''] = 'rainbow-delimiters' },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        }
      }
    end
  }

  -- Autopairs
  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup{}
    end
  }

  -- Lualine
  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup {
        options = {
          theme = 'auto',
          section_separators = '',
          component_separators = ''
        }
      }
    end
  }

  -- Tagbar
  use 'majutsushi/tagbar'

  -- Toggleterm
  use {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup{
        size = function(term)
          return math.floor(vim.o.lines / 3)
        end,
        open_mapping = [[<A-t>]],
        direction = "horizontal",
        hide_numbers = true,
        shade_terminals = true,
        start_in_insert = true,
        persist_size = true,
        close_on_exit = true,
      }
    end
  }
end)

-- ===================================
-- OPTIONS AND SETTINGS
-- ===================================
vim.o.termguicolors = true
vim.cmd('colorscheme onedark')

vim.wo.number = true
vim.o.ignorecase = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.cindent = true
vim.o.mouse = "a"
vim.cmd('syntax enable')

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
vim.cmd [[
  hi Normal guibg=NONE
  hi NormalNC guibg=NONE
  hi VertSplit guibg=NONE
  hi StatusLine guibg=NONE
  hi LineNr guibg=NONE
  hi SignColumn guibg=NONE
  hi CursorLineNr guibg=NONE
]]

-- Yank highlight
vim.cmd [[
  augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank { higroup="IncSearch", timeout=500 }
  augroup END
]]

-- Remove trailing whitespace on save
vim.cmd [[
  autocmd BufWritePre * %s/\s\+$//e
]]

-- Auto open toggleterm & NVIMTree
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      local main_win = vim.api.nvim_get_current_win()
      vim.cmd("ToggleTerm")
      vim.cmd("stopinsert")
      require("nvim-tree.api").tree.open()
      vim.api.nvim_set_current_win(main_win)
    end
  end,
})

-- ===================================
-- KEYMAPS
-- ===================================
local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', opts)
vim.keymap.set('n', '<F8>', ':TagbarToggle<CR>', opts)
vim.keymap.set('n', '<C-j>', ':vsplit<CR>', opts)
vim.keymap.set('n', '<C-k>', ':split<CR>', opts)
vim.keymap.set('n', '<C-S-Left>',  ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<C-S-Right>', ':vertical resize +2<CR>', opts)
vim.keymap.set('n', '<C-S-Up>',    ':resize -2<CR>', opts)
vim.keymap.set('n', '<C-S-Down>',  ':resize +2<CR>', opts)
vim.keymap.set('n', '<C-Left>',  '<C-w>h', opts)
vim.keymap.set('n', '<C-Right>', '<C-w>l', opts)
vim.keymap.set('n', '<C-Up>',    '<C-w>k', opts)
vim.keymap.set('n', '<C-Down>',  '<C-w>j', opts)
vim.keymap.set('n', '<S-s>', ':w<CR>', opts)
vim.keymap.set('n', '<S-q>', ':q<CR>', opts)
vim.keymap.set('n', '<C-s>', ':w<CR>', opts)
vim.keymap.set('n', '<C-q>', ':q!<CR>', opts)
vim.keymap.set('n', '<C-e>', ':tabprevious<CR>', opts)
vim.keymap.set('n', '<C-r>', ':tabnext<CR>', opts)
vim.keymap.set('n', '<C-w>', ':tabnew<CR>', opts)
vim.keymap.set('n', ';', ':', opts)
vim.keymap.set('n', '<C-d>', 'Yp', opts)
vim.keymap.set({'n','v'}, '<C-c>', '"+y', opts)
vim.keymap.set({'n','v'}, '<C-x>', '"+d', opts)
vim.keymap.set({'n','v'}, '<C-v>', '"+p', opts)
vim.keymap.set({'n','v'}, '<C-a>', 'ggVG', opts)
vim.keymap.set('i', '<C-v>', '<C-r>+', opts)
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>a', opts)
vim.keymap.set('i', '<C-q>', '<Esc>', opts)
vim.keymap.set('i', '<C-d>', '<Esc>YpA', opts)
vim.keymap.set('i', '<C-a>', '<Esc>ggVG', opts)
for i = 1, 9 do
  vim.api.nvim_set_keymap('n', '<C-'..i..'>', ':tabn '..i..'<CR>', opts)
end

-- ===================================
-- MASON & LSP
-- ===================================
require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "pyright", "clangd", "bashls", "lua_ls", "cssls", "jsonls" },
}

local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
if lspconfig_ok then
  local capabilities_ok, capabilities = pcall(require, 'cmp_nvim_lsp')
  local capabilities = capabilities_ok and capabilities.default_capabilities() or {}

  local servers = { "pyright", "clangd", "bashls", "lua_ls", "cssls", "jsonls" }
  for _, server in ipairs(servers) do
    if lspconfig[server] then
      lspconfig[server].setup { capabilities = capabilities }
    end
  end
end

-- ===================================
-- COMPLETION (nvim-cmp)
-- ===================================
local cmp = require'cmp'
local luasnip = require'luasnip'

cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  mapping = {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      else fallback() end
    end, {'i','s'}),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then luasnip.jump(-1)
      else fallback() end
    end, {'i','s'}),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
})

-- ===================================
-- DIAGNOSTICS
-- ===================================
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
})
