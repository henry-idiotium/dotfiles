--- Move cursor out of wrapper
return {
    'abecodes/tabout.nvim',
    opts = {
        tabkey = '<tab>',
        backwards_tabkey = '<s-tab>',
        act_as_tab = true,
        act_as_shift_tab = true,
        default_tab = '<c-t>',       -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
        default_shift_tab = '<c-d>', -- reverse shift default action,
        enable_backwards = true,
        completion = true,           -- if the tabkey is used in a completion pum
        tabouts = {
            { open = "'", close = "'" },
            { open = '"', close = '"' },
            { open = '`', close = '`' },
            { open = '<', close = '>' },
            { open = '(', close = ')' },
            { open = '[', close = ']' },
            { open = '{', close = '}' }
        },
        ignore_beginning = true, -- if the cursor is at the beginning of a filled element it will rather tab out than shift the content
        exclude = {} -- tabout will ignore these filetypes
    }
}
