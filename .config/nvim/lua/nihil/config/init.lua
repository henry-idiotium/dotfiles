require 'nihil.config.settings'
require 'nihil.config.options'
require 'nihil.config.keymaps'
require 'nihil.config.autocmds'
require 'nihil.config.usercmds'
require 'nihil.config.lazy'

vim.cmd.colorscheme(Nihil.settings.theme)
