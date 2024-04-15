function __bind -d 'Alternative bind function. (e.g., __bind -m default,insert \cc do_smth)'
    argparse -n __bind 'm/modes=' -- $argv
    or return

    set -f key $argv[1]
    set -f action $argv[2..]
    set -f modes $_flag_modes
    [ -z "$_flag_modes" ] && set modes default

    for mode in $modes
        bind -M $mode $key $action
    end
end