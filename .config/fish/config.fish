# theme
set -U fish_greeting ''
set -g fish_prompt_pwd_dir_length 1
set -g theme_color_scheme 'Catppuccin Mocha'
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# vi mode
fish_vi_key_bindings
set -U fish_vi_force_cursor true
set -U fish_cursor_default block
set -U fish_cursor_insert line
set -U fish_cursor_replace_one underscore
set -U fish_cursor_visual block


## env
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx EDITOR nvim
set -gx TERM wezterm # enable undercurl (~/.terminfo/w/wezterm)

fish_add_path -g ~/.local/bin
fish_add_path -g ~/.bun/bin
fish_add_path -g ~/.cache/.bun/bin # NOTE: or ~/.bun/install/cache
fish_add_path -g ~/.cargo/bin
fish_add_path -g ~/.local/share/fnm && type -q fnm && fnm env --use-on-cd --shell=fish --version-file-strategy=recursive | source
set -gx PNPM_HOME "$HOME/.local/share/pnpm" && fish_add_path -g "$PNPM_HOME"


## aliases
alias cp 'cp -iv'
alias mv 'mv -iv'
alias rm 'rm -iv'
alias mkdir 'mkdir -pv'
alias which 'type -a'
alias ls 'ls -Gp'
alias la 'ls -lA'
alias vi nvim
alias g git
alias cat bat
type -q eza && alias l 'eza -laU --icons --no-filesize --no-user --group-directories-first'


## keymaps
bind \cd false
bind -M insert \cd false
bind -M visual \cd false

bind -M insert jj 'commandline -P && commandline -f cancel || set fish_bind_mode default && commandline -f backward-char repaint-mode'
bind -M default \cq exit # close session

bind L end-of-line
bind H beginning-of-line
bind -M visual L end-of-line
bind -M visual H beginning-of-line
