--- Global variables for nihil user
_G.nihil = {
    debug = not vim.g.vscode,

    --- Env about current os
    os = {
        darwin = vim.fn.has 'macunix' == 1,
        linux = vim.fn.has 'unix' == 1 and vim.fn.has 'wsl' == 0,
        wsl = vim.fn.has 'wsl' == 1,
        win = vim.fn.has 'win32' == 1,
    },

    utils = {}, --- Utility function modules
}

return {}
