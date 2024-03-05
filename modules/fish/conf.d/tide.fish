# use `normal` for transparent
set -l prompt_bg normal #1e1e24

# prompt config
set -U tide_prompt_add_newline_before false
set -U tide_prompt_color_frame_and_connection 6C6C6C
set -U tide_prompt_color_separator_same_color 949494
set -U tide_prompt_icon_connection ' '
set -U tide_prompt_min_cols 50
set -U tide_prompt_pad_items true # space between items

# prompt left
set -U tide_left_prompt_items pwd git newline character
set -U tide_left_prompt_separator_same_color 

# prompt righ
set -U tide_right_prompt_items cmd_duration context jobs direnv node python rustc java php pulumi ruby go gcloud kubectl distrobox toolbox terraform aws nix_shell crystal elixir zig
set -U tide_right_prompt_separator_same_color 

# character
set -U tide_character_color green
set -U tide_character_color_failure red
set -U tide_character_icon ❯
set -U tide_character_vi_icon_default ❮
set -U tide_character_vi_icon_replace R
set -U tide_character_vi_icon_visual V

# pwd
set -U tide_pwd_bg_color $prompt_bg
set -U tide_pwd_markers bzr citc git hg node version python version ruby version shorten_folder_marker svn terraform Cargo toml composer json CVS go mod package json build zig
set -U tide_pwd_color_anchors brblue
set -U tide_pwd_color_dirs blue
set -U tide_pwd_color_truncated_dirs BCBCBC
set -U tide_pwd_icon
set -U tide_pwd_icon_home
set -U tide_pwd_icon_unwritable 


# context
set -U tide_context_always_display false
set -U tide_context_bg_color $prompt_bg
set -U tide_context_color_default D7AF87
set -U tide_context_color_root $_tide_color_gold
set -U tide_context_color_ssh D7AF87
set -U tide_context_hostname_parts 1

# time
set -U tide_time_bg_color $prompt_bg
set -U tide_time_color 5F8787
set -U tide_time_format %T

# cmd_duration
set -U tide_cmd_duration_bg_color $prompt_bg
set -U tide_cmd_duration_color 87875F
set -U tide_cmd_duration_decimals 1
set -U tide_cmd_duration_icon
set -U tide_cmd_duration_threshold 100

# git
set -U tide_git_bg_color $prompt_bg
set -U tide_git_bg_color_unstable $prompt_bg
set -U tide_git_bg_color_urgent $prompt_bg
set -U tide_git_color_branch brwhite
set -U tide_git_color_conflicted brred
set -U tide_git_color_added magenta
set -U tide_git_color_deleted brred
set -U tide_git_color_modified yellow
set -U tide_git_color_renamed cyan
set -U tide_git_color_operation brmagenta
set -U tide_git_color_staged green
set -U tide_git_color_stash white
set -U tide_git_color_untracked brwhite
set -U tide_git_color_upstream brmagenta
