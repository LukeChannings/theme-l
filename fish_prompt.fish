# name: L
function _git_branch_name
    echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
    echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end
set -l shortened_hostname hostname | sed -ne 's,^\(.\).*\(.\)$,\1\2,p' | tr '[:upper:]' '[:lower:]'

function fish_prompt
    set -l blue (set_color blue)
    set -l green (set_color green)
    set -l normal (set_color normal)

    set -l lambda "λ"
    set -l shortened_hostname hostname | sed -ne 's,^\(.\).*\(.\)$,\1\2,p' | tr '[:upper:]' '[:lower:]'
    set -l cwd $blue(basename (prompt_pwd))

    if [ (_git_branch_name) ]
        set git_info $green(_git_branch_name)
        set git_info ":$git_info"

        if [ (_is_git_dirty) ]
            set -l dirty "*"
            set git_info "$git_info$dirty"
        end
    end

    if [ "$SSH_TTY" ]
        set -l arrow "$lambda$shortened_hostname."
    else
        set -l arrow $lambda
    end

    echo -n -s $cwd $git_info $normal ' ' $arrow ' '
end
