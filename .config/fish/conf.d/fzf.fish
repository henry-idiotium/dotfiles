bind -M insert \ce __fzf_search_directory
bind -M insert \cd '__fzf_search_base_directory ~/.config/dotfiles/'
bind -M insert \cn '__fzf_search_base_directory ~/documents/notes/'
bind -M insert \cp '__fzf_search_base_directory ~/documents/projects/'
bind -M insert \ct '__fzf_search_base_directory ~/documents/throwaways/'


set -U fzf_cmd fzf \
    --header-first --ansi --cycle --reverse \
    --preview-window right:50%,hidden \
    --color header:italic,gutter:-1 \
    --color bg+:#313244,spinner:#f5e0dc,hl:#f38ba8 \
    --color fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --bind ctrl-l:accept \
    --bind ctrl-i:ignore,P:toggle-preview,ctrl-z:toggle-preview-wrap \
    --bind ctrl-u:preview-up,ctrl-d:preview-down \
    --bind ctrl-alt-u:preview-page-up,ctrl-alt-d:preview-page-down \
    --bind "ctrl-y:execute-silent(readlink -f {} | $CLIPBOARD)"

if [ -n "$TMUX" ]
    set -a fzf_cmd \
        --bind 'ctrl-alt-n:execute-silent(tmux new-window -dc (dirname (readpath {})))' \
        --bind 'ctrl-alt-v:execute-silent(tmux split-window dirname (readpath {}))'
end

set -U fzf_fd_cmd fd \
    --hidden \
    --no-ignore \
    --color always \
    --exclude .git \
    --exclude .next \
    --exclude dist \
    --exclude node_modules


# --------------------------------------------------
#		Helpers & Widgets
# -----------------------------
function __fzf_open_dir
    set -f cmd $argv; and [ -z "$cmd" ]; and return

    [ -d "$cmd" ]; and set -p cmd cd #> directory
    [ -f "$cmd" ]; and set -p cmd $EDITOR #> file

    begin # add command to the shell history list
        flock 1
        echo -- '- cmd:' (string replace -- \n \\n (string join ' ' $cmd) | string replace \\ \\\\)
        date +'  when: %s'
    end >>$__fish_user_data_dir/fish_history
    history merge

    eval "$cmd"
    commandline -t '' # clear token
    commandline -f repaint
end

function __fzf_preview_file -d 'Print a preview for the given file based on its file type.'
    set -f file_path $argv

    # notify user and recurse on the target of the symlink,
    # which can be any of these file types
    if test -L "$file_path" #> symlink
        set -l target_path (realpath "$file_path")
        printf "'$file_path' is a symlink to '$target_path'.\n\n"
        __fzf_preview_file "$target_path"

    else if test -f "$file_path" #> regular file
        bat "$file_path" --color always --style plain,numbers

    else if test -d "$file_path" #> directory
        eza "$file_path" \
            --color always -laU --icons \
            --no-filesize --no-user \
            --group-directories-first

    else #> unrecognizable
        printf "Cannot preview '$file_path'.\n\n"

    end
end

function __fzf_search_directory -d 'Search files and directories'
    set -f token (commandline --current-token)
    # expand vars or leading tidle
    set -f expanded_token (eval echo -- "$token")
    # remove backslashes (e.g, 'path/dumb \foo/' -> 'path/dumb foo/')
    set -f unescaped_exp_token (string unescape -- $expanded_token)

    # If the current token is a directory and has a trailing slash,
    # then use it as fd's base directory.
    if string match -q -- "*/" $unescaped_exp_token && test -d "$unescaped_exp_token"
        set -a fzf_fd_cmd --base-directory $unescaped_exp_token
        set -a fzf_cmd \
            --prompt " $unescaped_exp_token> " \
            --preview "__fzf_preview_file $expanded_token{}"
        set -f result $unescaped_exp_token($fzf_fd_cmd | $fzf_cmd)
    else
        set -a fzf_cmd \
            --prompt " > " \
            --query "$unescaped_exp_token" \
            --preview "__fzf_preview_file {}"
        set -f result ($fzf_fd_cmd 2>/dev/null | $fzf_cmd)
    end

    __fzf_open_dir $result
end

function __fzf_search_base_directory -d "Search files and directories with specify base directory (for keybindings)."
    set -f base_dir $argv
    set -f expanded_dir (eval echo -- $base_dir)
    set -f unescaped_exp_dir (string unescape -- $expanded_dir)

    set -a fzf_fd_cmd --base-directory "$unescaped_exp_dir"
    set -a fzf_cmd --prompt " $(basename $unescaped_exp_dir)> " \
        --preview "__fzf_preview_file $expanded_dir{}" \
        --bind 'ctrl-o:clear-query+put()+print-query'

    set -f result $unescaped_exp_dir($fzf_fd_cmd | $fzf_cmd)

    __fzf_open_dir $result
end