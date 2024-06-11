---@diagnostic disable: no-unknown
return {
    { -- Completion
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        version = false,
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline',
            'saadparwaiz1/cmp_luasnip',
            'L3MON4D3/LuaSnip',
            {
                'rafamadriz/friendly-snippets',
                config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
            },
            {
                'roobert/tailwindcss-colorizer-cmp.nvim',
                opts = { color_square_width = 2 },
            },
        },
        opts = {
            completion = {
                -- autocomplete = false,
                completeopt = 'menu,menuone,noinsert',
            },
            snippet = {
                expand = function(args) require('luasnip').lsp_expand(args.body) end,
            },
            window = {
                completion = { border = 'rounded' },
                documentation = { border = 'rounded' },
            },
            experimental = {
                ghost_text = false,
            },
        },

        config = function(_, opts)
            local cmp = require 'cmp'

            ---- UI, Icon
            local icons = Nihil.settings.icons.kinds
            opts.formatting = { ---@type cmp.FormattingConfig
                expandable_indicator = false,
                fields = { 'kind', 'abbr', 'menu' },
                format = function(entry, item)
                    local tw = require('tailwindcss-colorizer-cmp').formatter(entry, item)
                    if tw.kind == 'XX' then return tw end

                    item.menu = item.menu or item.kind or ''
                    item.kind = icons[item.kind] or ''

                    return item
                end,
            }

            ---- Keybinds
            local cmp_select = { behavior = cmp.SelectBehavior.Select }
            local cmp_close = {
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }
            opts.mapping = cmp.mapping.preset.insert {
                ['<c-space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                ['<c-j>'] = cmp.mapping.select_next_item(cmp_select),
                ['<c-k>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<c-y>'] = cmp.mapping.confirm { select = true },
                ['<cr>'] = cmp.mapping.confirm { select = true },
                ['<c-q>'] = cmp_close,
                ['<c-e>'] = cmp_close,

                ['<c-g>'] = function() return cmp.visible_docs() and cmp.close_docs() or cmp.open_docs() end,
                ['<tab>'] = function(fallback)
                    local sm = require 'supermaven-nvim.completion_preview'
                    local ls = require 'luasnip'

                    if not cmp.visible() and sm.has_suggestion() then
                        sm.on_accept_suggestion()
                    elseif cmp.visible() then
                        if ls.expandable() then
                            ls.expand()
                        else
                            cmp.confirm { select = true }
                        end
                    else
                        fallback()
                    end
                end,
            }

            ---- Sources
            opts.sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
                { name = 'path' },
            })

            ---- Order/Sorting
            local compare = cmp.config.compare
            local cmp_lsp_kind = require('cmp.types').lsp.CompletionItemKind
            local kinds_priority = Nihil.settings.kinds.priority
            opts.sorting = { ---@type cmp.SortingConfig
                priority_weight = 1,
                comparators = {
                    compare.exact,
                    compare.locality,
                    compare.recently_used,

                    function(entry1, entry2) -- kind priority
                        local prio1 = kinds_priority[cmp_lsp_kind[entry1:get_kind()]]
                        local prio2 = kinds_priority[cmp_lsp_kind[entry2:get_kind()]]
                        if not (prio1 or prio2) and prio1 == prio2 then return end
                        local diff = prio1 - prio2
                        return diff > 0
                    end,

                    compare.offset,
                    compare.score,
                    compare.order,
                    compare.kind,
                    compare.sort_text,
                },
            }

            cmp.setup(opts)
        end,
    },

    {
        'supermaven-inc/supermaven-nvim',
        event = 'VeryLazy',
        lazy = false,
        keys = {
            { '<leader>us', '<cmd>SupermavenToggle <cr>', desc = 'Toggle Smart Suggestion' },
        },
        opts = {
            disable_inline_completion = false,
            disable_keymaps = true,
            ignore_filetypes = {},
        },
    },
}
