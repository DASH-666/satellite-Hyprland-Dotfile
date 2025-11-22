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
  use 'lunarvim/colorschemes'
  use { "scottmckendry/cyberdream.nvim" }

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
vim.cmd('colorscheme cyberdream')

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
vim.cmd [[
  hi CursorLine guibg=#2c2c2c
  hi Comment gui=italic
  hi Function gui=bold
  hi Keyword gui=bold
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


-- ===================================
-- KEYMAPS
-- ===================================
local opts = { noremap=true, silent=true }

-- Normal mode
vim.api.nvim_set_keymap('n', '<C-x>', ':NvimTreeToggle<CR>', opts)
vim.api.nvim_set_keymap('n', '<F8>', ':TagbarToggle<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-v>', ':vsplit<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-h>', ':split<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-Left>', ':vertical resize -2<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-Right>', ':vertical resize +2<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-Up>', ':resize -2<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-Down>', ':resize +2<CR>', opts)
vim.api.nvim_set_keymap('n', '<S-s>', ':w<CR>', opts)
vim.api.nvim_set_keymap('n', '<S-q>', ':q<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-q>', ':q<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-e>', ':tabprevious<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-r>', ':tabnext<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-w>', ':tabnew<CR>', opts)
vim.api.nvim_set_keymap('n', ';', ':', opts)
vim.api.nvim_set_keymap("n", "<C-d>", "Yp", opts)

-- Insert mode
vim.api.nvim_set_keymap('i', '<C-s>', '<Esc>:w<CR>a', opts)
vim.api.nvim_set_keymap('i', '<C-q>', '<Esc>', opts)
vim.api.nvim_set_keymap("i", "<C-d>", "<Esc>YpA", opts)

-- Tabs 1–9
for i = 1, 9 do
  vim.api.nvim_set_keymap('n', '<C-'..i..'>', ':tabn '..i..'<CR>', opts)
end


-- ===================================
-- MASON SETUP
-- ===================================
require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "pyright", "clangd", "bashls", "lua_ls" },
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
  ensure_installed = { "python", "bash", "cpp", "lua" },
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

vim.api.nvim_set_keymap('n', '<A-t>', "<cmd>lua _G.toggle_floating_terminal()<CR>", opts)
vim.api.nvim_set_keymap('t', '<M-t>', [[<C-\><C-n>:lua toggle_floating_terminal()<CR>]], opts)


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
