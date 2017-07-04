set -e fish_greeting
set -gx EDITOR emacs
set -gx LESS '-R'

# Ssh-agent
set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh
