---@diagnostic disable: unused-local
local M = {}

local api = vim.api

------------------
-- Constants
------
M.AUGROUPS = {
    LSP = 'LspFormat',
}
M.LSP_ITEM_KINDS = {
    Text = '',
    Method = '',
    Function = '',
    Constructor = '',
    Field = '',
    Variable = '',
    Class = '',
    Interface = '',
    Module = '',
    Property = '',
    Unit = '',
    Value = '',
    Enum = '',
    Keyword = '',
    Snippet = '',
    Color = '',
    File = '',
    Reference = '',
    Folder = '',
    EnumMember = '',
    Constant = '',
    Struct = '',
    Event = '',
    Operator = '',
    TypeParameter = ' ',
}
M.FILE_TYPES = {
    'html',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'css',
    'sass',
    'scss',
    'json',
    'jsonc',
    'markdown',
    'python',
    'lua',
}

------------------
-- Auto Command
------
M.auto_format = {}

M.auto_format.lsp = function(client, bufnr)
    if not client.server_capabilities.documentFormattingProvider then return end

    api.nvim_create_autocmd('BufWritePre', {
        group = api.nvim_create_augroup(M.AUGROUPS.LSP, { clear = true }),
        buffer = bufnr,
        callback = function() vim.lsp.buf.format { bufnr = bufnr } end,
    })
end

------------------
-- User Command
------
M.user_cmds = {}

local function lsp_toggle_logging(type, state)
    --
    print(string.format('%s [LSP] %s!!', type, state and 'enable' or 'disable'))
end

M.user_cmds.toggle_diagnostic = function(client, bufnr)
    if not client.server_capabilities.documentSymbolProvider then return end

    vim.g.lsp_diagnostic_enable = true
    api.nvim_create_user_command('LspDiagnosticToggle', function()
        local type = vim.g.lsp_diagnostic_enable and 'disable' or 'enable'

        vim.diagnostic[type](0)
        vim.g.lsp_diagnostic_enable = not vim.g.lsp_diagnostic_enable

        lsp_toggle_logging('Diagnostic', vim.g.lsp_diagnostic_enable)
    end, { nargs = 0 })
end

M.user_cmds.toggle_auto_format = function(client, bufnr)
    if not client.server_capabilities.documentFormattingProvider then return end

    vim.g.lsp_auto_format_enable = true
    api.nvim_create_user_command('LspAutoFormatToggle', function()
        if vim.g.lsp_auto_format_enable then
            pcall(api.nvim_del_augroup_by_name, M.AUGROUPS.LSP)
        else
            M.auto_format.lsp(client, bufnr)
        end

        vim.g.lsp_auto_format_enable = not vim.g.lsp_auto_format_enable

        lsp_toggle_logging('Auto format', vim.g.lsp_auto_format_enable)
    end, { nargs = 0 })
end

return M
