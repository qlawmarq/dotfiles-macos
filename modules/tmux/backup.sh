#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
COMMON_DIR="$DOTFILES_DIR/modules/common"

. "$DOTFILES_DIR/lib/utils.sh"

check_macos

print_info "Backing up tmux configuration to common"
echo "========================================"

# Check if config exists
if [ ! -f "$HOME/.tmux.conf" ]; then
    warning "No .tmux.conf found in home directory"
    exit 0
fi

# Backup to common
cp "$HOME/.tmux.conf" "$COMMON_DIR/tmux/.tmux.conf"
success "tmux configuration backed up to common/tmux/"

warning "Remember to commit and push changes in common submodule:"
info "  cd $COMMON_DIR"
info "  git add tmux/.tmux.conf"
info "  git commit -m 'Update tmux configuration'"
info "  git push"
