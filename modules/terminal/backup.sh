#!/bin/bash

# Export the default Terminal.app profile to <profile name>.terminal
#
# Apple documents only the GUI export (Settings > Profiles > Export), so the
# profile dictionary is read from the preferences instead. Terminal imports a
# .terminal file under its file name, and the dictionary written here differs
# from what an import stores only in its `name` key, which is the same name.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
if [ -f "$DOTFILES_DIR/lib/utils.sh" ]; then
    source "$DOTFILES_DIR/lib/utils.sh"
else
    echo "Error: utils.sh not found at $DOTFILES_DIR/lib/utils.sh"
    exit 1
fi

check_macos

PLISTBUDDY=/usr/libexec/PlistBuddy

PROFILE=$(defaults read com.apple.Terminal "Default Window Settings" 2>/dev/null)
if [ -z "$PROFILE" ]; then
    print_error "No default Terminal profile found"
    exit 1
fi

# Read through cfprefsd; the plist file on disk can lag behind it.
TMP_DOMAIN=$(mktemp)
trap 'rm -f "$TMP_DOMAIN"' EXIT
defaults export com.apple.Terminal "$TMP_DOMAIN"

OUT="$SCRIPT_DIR/$PROFILE.terminal"
if ! "$PLISTBUDDY" -x -c "Print ':Window Settings:$PROFILE'" "$TMP_DOMAIN" > "$OUT.tmp"; then
    rm -f "$OUT.tmp"
    print_error "Could not read profile '$PROFILE'"
    exit 1
fi

# Keep exactly one profile: apply.sh makes it the default.
for f in "$SCRIPT_DIR"/*.terminal; do
    [ -e "$f" ] && [ "$f" != "$OUT" ] && rm -f "$f" && print_info "Removed stale profile: $(basename "$f")"
done
mv "$OUT.tmp" "$OUT"

print_success "Terminal profile '$PROFILE' exported to $(basename "$OUT")"
