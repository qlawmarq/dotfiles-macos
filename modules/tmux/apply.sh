#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
COMMON_DIR="$DOTFILES_DIR/modules/common"

. "$DOTFILES_DIR/lib/utils.sh"

check_macos

print_info "tmux Configuration Setup (from common)"
echo "========================================"

# Verify submodule is initialized
if [ ! -f "$COMMON_DIR/tmux/.tmux.conf" ]; then
    error "Common submodule not initialized."
    info "Run: git submodule update --init"
    exit 1
fi

# Backup existing config
if [ -f "$HOME/.tmux.conf" ]; then
    backup="$HOME/.tmux.conf.$(date +%Y%m%d%H%M%S).bak"
    mv "$HOME/.tmux.conf" "$backup"
    info "Existing .tmux.conf backed up to $backup"
fi

# Deploy from common
cp "$COMMON_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
success "tmux configuration applied from common repository"

info ""
info "Note: Reload tmux with 'tmux source ~/.tmux.conf' if already running"
