-- ============================================================================
-- LAZY.NVIM BOOTSTRAP
-- ============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
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

-- ============================================================================
-- GLOBAL SETTINGS
-- ============================================================================

vim.o.termguicolors = true

-- Disable unused language providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Disable netrw because NvimTree is used
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set Space as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- PLUGINS
-- ============================================================================

require("lazy").setup({

    -- Lazy.nvim
    "folke/lazy.nvim",

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            require("ibl").setup({
                indent = {
                    char = "│",
                },
                scope = {
                    enabled = true,
                },
                exclude = {
                    filetypes = {
                        "dashboard",
                        "alpha",
                        "starter",
                        "lazy",
                    },
                },
            })
        end,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",

        config = function()
            require("nvim-treesitter").setup()

            require("nvim-treesitter").install({
                "python",
                "bash",
                "cpp",
                "lua",
                "c",
                "json",
                "css",
                "cmake",
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "python",
                    "bash",
                    "cpp",
                    "lua",
                    "c",
                    "json",
                    "css",
                    "cmake",
                },
                callback = function()
                    vim.treesitter.start()
                end,
            })
        end,
    },

    -- Treesitter context
    "nvim-treesitter/nvim-treesitter-context",

    -- Dashboard
    {
        "glepnir/dashboard-nvim",
        event = "VimEnter",
        opts = {
            theme = "hyper",
        },
    },

    -- Colorscheme
    {
        "drazil100/dusklight.vim",
        config = function()
            vim.cmd("colorscheme dusklight")
        end,
    },

    -- Color highlighter
    {
        "catgoose/nvim-colorizer.lua",
        event = "BufReadPre",
        opts = {},
    },

    -- File explorer
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {},
    },

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {},
    },

    -- Mason
    {
        "mason-org/mason.nvim",
        opts = {},
    },

    -- Mason LSP integration
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                "pyright",
                "clangd",
                "bashls",
                "lua_ls",
                "cssls",
                "jsonls",
            },
            automatic_enable = false,
        },
    },

    -- LSP configuration
    "neovim/nvim-lspconfig",

    -- Bufferline
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {},
    },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
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
                    -- Select next completion item or jump to next snippet field
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    -- Select previous completion item or jump to previous snippet field
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    -- Confirm completion
                    ["<CR>"] = cmp.mapping.confirm({
                        select = true,
                    }),
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

    -- Which-Key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            triggers = {
                { "<auto>", mode = "nixsotc" },
            },
        },
    },

    -- Rainbow delimiters
    {
        "HiPhish/rainbow-delimiters.nvim",
        config = function()
            local rainbow = require("rainbow-delimiters")

            vim.g.rainbow_delimiters = {
                strategy = {
                    [""] = rainbow.strategy.global,
                },

                query = {
                    [""] = "rainbow-delimiters",
                },

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
    },

    -- Automatic bracket pairing
    {
        "windwp/nvim-autopairs",
        opts = {},
    },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                theme = "auto",
                section_separators = "",
                component_separators = "",
            },
        },
    },

    -- Tagbar
    "majutsushi/tagbar",
})

-- ============================================================================
-- EDITOR OPTIONS
-- ============================================================================

vim.wo.number = true

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.mouse = "a"

-- Use 4 spaces for indentation
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- Open splits in predictable directions
vim.o.splitbelow = true
vim.o.splitright = true

-- ============================================================================
-- UI HIGHLIGHTS
-- ============================================================================

vim.cmd([[
    hi Normal guibg=NONE
    hi NormalNC guibg=NONE
    hi VertSplit guibg=NONE
    hi StatusLine guibg=NONE
    hi LineNr guibg=NONE
    hi SignColumn guibg=NONE
    hi CursorLineNr guibg=NONE
]])

-- ============================================================================
-- AUTOCOMMANDS
-- ============================================================================

local autocmd_group = vim.api.nvim_create_augroup("UserConfig", {
    clear = true,
})

-- Highlight copied text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = autocmd_group,
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 500,
        })
    end,
})

-- Remove trailing whitespace before saving
vim.api.nvim_create_autocmd("BufWritePre", {
    group = autocmd_group,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- ============================================================================
-- KEYMAP OPTIONS
-- ============================================================================

local opts = {
    noremap = true,
    silent = true,
}

-- ============================================================================
-- TELESCOPE
-- ============================================================================

-- Find files
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", {
    desc = "Find Files",
})

-- Search text across the project
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", {
    desc = "Live Grep",
})

-- Show open buffers
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", {
    desc = "Find Buffers",
})

-- Show recently opened files
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", {
    desc = "Recent Files",
})

-- Show diagnostics
vim.keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", {
    desc = "Find Diagnostics",
})

-- Search keymaps
vim.keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", {
    desc = "Find Keymaps",
})

-- Search commands
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope commands<CR>", {
    desc = "Find Commands",
})

-- Search help tags
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", {
    desc = "Find Help",
})

-- ============================================================================
-- NVIM-TREE
-- ============================================================================

-- Toggle file explorer
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", {
    desc = "Toggle File Explorer",
})

-- ============================================================================
-- BUFFERS
-- ============================================================================

-- Go to next buffer
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", {
    desc = "Next Buffer",
})

-- Go to previous buffer
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", {
    desc = "Previous Buffer",
})

-- Delete current buffer
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", {
    desc = "Delete Buffer",
})

-- Go to first buffer
vim.keymap.set("n", "<leader>bf", "<cmd>bfirst<CR>", {
    desc = "First Buffer",
})

-- Go to last buffer
vim.keymap.set("n", "<leader>bl", "<cmd>blast<CR>", {
    desc = "Last Buffer",
})

-- Show buffers with Telescope
vim.keymap.set("n", "<leader>bb", "<cmd>Telescope buffers<CR>", {
    desc = "List Buffers",
})

-- ============================================================================
-- WINDOWS
-- ============================================================================

-- Create horizontal split
vim.keymap.set("n", "<leader>ws", "<cmd>split<CR>", {
    desc = "Horizontal Split",
})

-- Create vertical split
vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<CR>", {
    desc = "Vertical Split",
})

-- Close current window
vim.keymap.set("n", "<leader>wc", "<cmd>close<CR>", {
    desc = "Close Window",
})

-- ============================================================================
-- TABS
-- ============================================================================

-- Open a new tab
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", {
    desc = "New Tab",
})

-- Close current tab
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", {
    desc = "Close Tab",
})

-- Go to next tab
vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<CR>", {
    desc = "Next Tab",
})

-- Go to previous tab
vim.keymap.set("n", "<leader>tp", "<cmd>tabprevious<CR>", {
    desc = "Previous Tab",
})

-- ============================================================================
-- LSP
-- ============================================================================

-- LSP mappings are added per buffer in the LSP on_attach function.

-- ============================================================================
-- DIAGNOSTICS
-- ============================================================================

-- Show diagnostic information
vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, {
    desc = "Show Diagnostic",
})

-- Go to next diagnostic
vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, {
    desc = "Next Diagnostic",
})

-- Go to previous diagnostic
vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, {
    desc = "Previous Diagnostic",
})

-- ============================================================================
-- LSP CONFIGURATION
-- ============================================================================

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = {
    -- Python
    pyright = {},

    -- C / C++
    clangd = {
        cmd = {
            "clangd",
            "--compile-commands-dir=build",
            "--background-index",
        },
    },

    -- Bash
    bashls = {},

    -- Lua
    lua_ls = {
        settings = {
            Lua = {
                diagnostics = {
                    globals = {
                        "vim",
                    },
                },
            },
        },
    },

    -- CSS
    cssls = {},

    -- JSON
    jsonls = {},
}

-- Configure each LSP server
for server_name, server_config in pairs(servers) do
    server_config.capabilities = capabilities

    server_config.on_attach = function(_, bufnr)
        local bufopts = {
            noremap = true,
            silent = true,
            buffer = bufnr,
        }

        -- Go to definition
        vim.keymap.set(
            "n",
            "gd",
            vim.lsp.buf.definition,
            bufopts
        )

        -- Show hover information
        vim.keymap.set(
            "n",
            "K",
            vim.lsp.buf.hover,
            bufopts
        )

        -- Rename symbol
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, {
            noremap = true,
            silent = true,
            buffer = bufnr,
            desc = "Rename Symbol",
        })

        -- Show code actions
        vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, {
            noremap = true,
            silent = true,
            buffer = bufnr,
            desc = "Code Action",
        })

        -- Show references
        vim.keymap.set(
            "n",
            "gr",
            vim.lsp.buf.references,
            bufopts
        )
    end

    vim.lsp.config(server_name, server_config)
end

-- Enable configured LSP servers
for server_name in pairs(servers) do
    vim.lsp.enable(server_name)
end

-- ============================================================================
-- DIAGNOSTICS
-- ============================================================================

vim.diagnostic.config({
    -- Disable inline diagnostic text
    virtual_text = false,

    -- Show diagnostic signs in the sign column
    signs = true,

    -- Do not update diagnostics while typing
    update_in_insert = false,

    -- Underline problematic code
    underline = true,

    -- Sort diagnostics by severity
    severity_sort = true,
})
