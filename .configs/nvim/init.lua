-- keybind list

-- NORMAL MODE
-- ctrl + x → Toggle NvimTree
-- F8 → Toggle Tagbar
-- ctrl + v → Vertical split
-- ctrl + h → Horizontal split
-- ctrl + Left → Resize vertical split smaller
-- ctrl + Right → Resize vertical split larger
-- ctrl + Up → Resize horizontal split smaller
-- ctrl + Down → Resize horizontal split larger
-- shift + s → Save buffer
-- shift + q → Quit buffer
-- ctrl + s → Save buffer
-- ctrl + q → Quit buffer
-- ctrl + e → Previous tab
-- ctrl + r → Next tab
-- ctrl + w → New tab
-- ; → Command mode (:)
-- ctrl + d → Duplicate line
-- alt + t → Toggle floating terminal
-- ctrl + c → Copy selected text
-- ctrl + x → Cut selected text
-- ctrl + v → Paste from system clipboard
-- ctrl + a → Select all text

-- INSERT MODE
-- ctrl + s → Save buffer
-- ctrl + q → Exit insert mode
-- ctrl + d → Duplicate line
-- ctrl + v → Paste from system clipboard
-- ctrl + a → Select all text

-- TERMINAL MODE
-- ctrl + t → Toggle floating terminal

-- NvimTree Keys
-- o → Open file/folder
-- Enter → Open file/folder
-- v → Vertical split open
-- h → Horizontal split open
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

-- Completion (nvim-cmp)
-- Tab → Next completion / Expand snippet
-- shift + Tab → Previous completion / Jump to previous snippet
-- Enter → Confirm completion
--
-- Tagbar
-- Enter → Jump to item
-- o or space → Expand/Collapse node
-- ctrl + q → Quit Tagbar window

-- ===================================
-- PACKER PLUGINS
-- ===================================
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- package manager itself

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

  -- Treesitter context
  use 'nvim-treesitter/nvim-treesitter-context'

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

  -- use 'lunarvim/colorschemes'

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

  -- Treesitter & extensions
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'HiPhish/rainbow-delimiters.nvim'

  -- Autopairs & icons
  use 'windwp/nvim-autopairs'
  use 'kyazdani42/nvim-web-devicons'

  -- UI plugins
  use 'majutsushi/tagbar'
  use 'nvim-lualine/lualine.nvim'
end)


-- ===================================
-- OPTIONS AND SETTINGS
-- ===================================
vim.o.termguicolors = true
vim.cmd('colorscheme onedark')

-- UI options
vim.wo.number = true
vim.o.ignorecase = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.cindent = true
vim.o.mouse = "a"
vim.cmd('syntax enable')
vim.opt.clipboard = "unnamedplus"

-- Tabs as 4 spaces
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.ruler = true
vim.o.showcmd = true
vim.o.laststatus = 2
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.encoding = "utf-8"
vim.opt.clipboard = "unnamedplus"

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

-- Highlighting
-- vim.cmd [[
  -- hi CursorLine guibg=#2c2c2c
  -- hi Comment gui=italic
  -- hi Function gui=bold
  -- hi Keyword gui=bold
-- ]]

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


-- ===================================
-- KEYMAPS
-- ===================================

local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', opts)
vim.keymap.set('n', '<F8>', ':TagbarToggle<CR>', opts)

vim.keymap.set('n', '<C-j>', ':vsplit<CR>', opts)
vim.keymap.set('n', '<C-k>', ':split<CR>', opts)

vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', opts)
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', opts)

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

-- Tabs 1–9
for i = 1, 9 do
  vim.api.nvim_set_keymap('n', '<C-'..i..'>', ':tabn '..i..'<CR>', opts)
end


-- ===================================
-- MASON SETUP
-- ===================================
require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "pyright", "clangd", "bashls", "lua_ls", "cssls", "jsonls" },
}

-- ===================================
-- LSP CONFIGURATION
-- ===================================
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = { "pyright", "clangd", "bashls", "lua_ls" }

for _, server in ipairs(servers) do
  lspconfig[server].setup {
    capabilities = capabilities,
  }
end


-- ===================================
-- COMPLETION (nvim-cmp)
-- ===================================
local cmp = require'cmp'
local luasnip = require'luasnip'

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
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
-- AUTOPAIRS
-- ===================================
require('nvim-autopairs').setup{}


-- ===================================
-- TREESITTER CONFIG
-- ===================================
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


-- ===================================
-- LUALINE
-- ===================================
require('lualine').setup {
  options = {
    theme = 'auto',
    section_separators = '',
    component_separators = ''
  }
}


-- ===================================
-- DIAGNOSTICS
-- ===================================
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
})


-- ===================================
-- FLOATING TERMINAL
-- ===================================
function _G.toggle_floating_terminal()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      if name:match("term://") then
        local wins = vim.fn.win_findbuf(buf)
        for _, win in ipairs(wins) do
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
            return
          end
        end
      end
    end
  end

  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.4)
  local row = math.floor((vim.o.lines - height) / 2 - 1)
  local col = math.floor((vim.o.columns - width) / 2)

  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  vim.fn.termopen(vim.o.shell)
  vim.cmd("startinsert")
end

vim.keymap.set('n', '<C-t>', "<cmd>lua _G.toggle_floating_terminal()<CR>", { noremap = true, silent = true })
vim.keymap.set('t', '<C-t>', [[<C-\><C-n>:lua _G.toggle_floating_terminal()<CR>]], { noremap = true, silent = true })

-- ===================================
-- RAINBOW DELIMITERS
-- ===================================
vim.g.rainbow_delimiters = {
  strategy = {
    [''] = require('rainbow-delimiters.strategy.global'),
  },
  query = {
    [''] = 'rainbow-delimiters',
  },
  highlight = {
    'RainbowDelimiterRed',
    'RainbowDelimiterYellow',
    'RainbowDelimiterBlue',
    'RainbowDelimiterOrange',
    'RainbowDelimiterGreen',
    'RainbowDelimiterViolet',
    'RainbowDelimiterCyan',
  },
}

