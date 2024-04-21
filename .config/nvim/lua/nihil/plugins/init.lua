---@diagnostic disable: no-unknown
return {
    { 'nvim-lua/plenary.nvim', name = 'plenary', lazy = true },
    { 'eandrju/cellular-automaton.nvim', cmd = 'CellularAutomaton make_it_rain' },

    -- measure startuptime
    {
        'dstein64/vim-startuptime',
        cmd = 'StartupTime',
        config = function() vim.g.startuptime_tries = 10 end,
    },

    -- Session management. This saves your session in the background,
    -- keeping track of open buffers, window arrangement, and more.
    -- You can restore sessions when returning through the dashboard.
    {
        'folke/persistence.nvim',
        event = 'BufReadPre',
        opts = { options = vim.opt.sessionoptions:get() },
        keys = {
            { '<leader>qs', function() require('persistence').load() end, desc = 'Restore Session' },
            { '<leader>ql', function() require('persistence').load { last = true } end, desc = 'Restore Last Session' },
            { '<leader>qd', function() require('persistence').stop() end, desc = "Don't Save Current Session" },
        },
    },
}
