export PATH="$HOME/.local/bin:$PATH"
eval "$(mise activate zsh)"
eval "$(mise activate --shims)"
path_append ()  { path_remove $1; export PATH="$PATH:$1"; }
path_prepend () { path_remove $1; export PATH="$1:$PATH"; }
path_remove ()  { export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`; }

# Load environment secrets (API keys, tokens, etc.)
# This file should contain sensitive environment variables and is excluded from git
if [ -f "$HOME/.env_secrets" ]; then
    source "$HOME/.env_secrets"
fi
