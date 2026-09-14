#!/bin/bash

# Import <profile name>.terminal and make it the default and startup profile
#
# Measured behaviour of Terminal.app that shapes this script:
# - `open X.terminal` imports the profile under the file name and opens a
#   window with it. Opening it again adds no duplicate but opens another window.
# - Importing over an existing profile of the same name does not update it.
# - Deleting a profile that open windows still use leaves a "<name> 1" copy
#   behind, so an existing profile is never replaced automatically.

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

PROFILE_FILE=""
for f in "$SCRIPT_DIR"/*.terminal; do
    [ -e "$f" ] || continue
    if [ -n "$PROFILE_FILE" ]; then
        print_error "More than one .terminal file in $SCRIPT_DIR - keep only one"
        exit 1
    fi
    PROFILE_FILE="$f"
done
if [ -z "$PROFILE_FILE" ]; then
    print_warning "No .terminal file found. Run backup.sh first to export a profile."
    exit 1
fi
PROFILE=$(basename "$PROFILE_FILE" .terminal)

# Profile names go through argv so quotes in a name cannot break the script.
terminal_script() {
    osascript - "$@" <<'OSA'
on run argv
    set action to item 1 of argv
    set profileName to item 2 of argv
    tell application "Terminal"
        if action is "exists" then
            return exists settings set profileName
        else if action is "set-default" then
            set default settings to settings set profileName
            set startup settings to settings set profileName
            return "ok"
        end if
    end tell
end run
OSA
}

echo "Setting up Terminal profile '$PROFILE'..."

if [ "$(terminal_script exists "$PROFILE")" = "true" ]; then
    TMP_DOMAIN=$(mktemp)
    TMP_PROFILE=$(mktemp)
    trap 'rm -f "$TMP_DOMAIN" "$TMP_PROFILE"' EXIT
    defaults export com.apple.Terminal "$TMP_DOMAIN"
    "$PLISTBUDDY" -x -c "Print ':Window Settings:$PROFILE'" "$TMP_DOMAIN" > "$TMP_PROFILE"
    if cmp -s "$TMP_PROFILE" "$PROFILE_FILE"; then
        print_info "Profile '$PROFILE' is already up to date"
    else
        print_warning "Profile '$PROFILE' exists and differs from $(basename "$PROFILE_FILE")"
        print_info "Terminal does not update a profile on re-import. To replace it:"
        print_info "  1. Close windows using '$PROFILE', or switch them to another profile"
        print_info "  2. Terminal > Settings > Profiles: select '$PROFILE' and click (-)"
        print_info "  3. Run this script again"
    fi
else
    open "$PROFILE_FILE"
    for _ in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
        [ "$(terminal_script exists "$PROFILE")" = "true" ] && break
        sleep 0.5
    done
    if [ "$(terminal_script exists "$PROFILE")" != "true" ]; then
        print_error "Terminal did not import $(basename "$PROFILE_FILE")"
        exit 1
    fi
    print_success "Imported profile '$PROFILE' (Terminal opened a window with it)"
fi

if terminal_script set-default "$PROFILE" >/dev/null; then
    print_success "'$PROFILE' is now the default and startup profile"
else
    print_error "Failed to set '$PROFILE' as the default profile"
    exit 1
fi
