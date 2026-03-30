#!/bin/bash
# Manages kitty tab title indicators for Claude Code sessions.
# Captures the tab title on first call so custom names (set via
# cmd+shift+t) are preserved. Also detects mid-session renames by
# tracking the last title we set — if the current title differs,
# the user must have renamed it.
#
# Cache format (two lines):
#   line 1: base title (the user's name, without our ● prefix)
#   line 2: last title we set (so we can detect external changes)
#
# Usage: claude-tab-title.sh <working|done|end>

set -euo pipefail

ACTION="${1:?Usage: claude-tab-title.sh <working|done|end>}"
CACHE="/tmp/kitty-claude-tab-${KITTY_WINDOW_ID:-unknown}"

get_tab_title() {
    kitty @ --to "$KITTY_LISTEN_ON" ls 2>/dev/null | python3 -c "
import json, sys
data = json.load(sys.stdin)
wid = int(sys.argv[1])
for os_win in data:
    for tab in os_win.get('tabs', []):
        for win in tab.get('windows', []):
            if win.get('id') == wid:
                print(tab.get('title', ''))
                sys.exit(0)
print('')
" "$KITTY_WINDOW_ID"
}

set_title() {
    kitty @ --to "$KITTY_LISTEN_ON" set-tab-title --match "id:$KITTY_WINDOW_ID" "$1"
}

CURRENT=$(get_tab_title)

if [ -f "$CACHE" ]; then
    BASE=$(sed -n '1p' "$CACHE")
    LAST_SET=$(sed -n '2p' "$CACHE")

    # If current title doesn't match what we last set, the user renamed it
    if [ "$CURRENT" != "$LAST_SET" ]; then
        BASE="${CURRENT#● }"
        [ -z "$BASE" ] && BASE="Claude Code"
    fi
else
    # First invocation — capture whatever the tab is currently called
    BASE="${CURRENT#● }"
    [ -z "$BASE" ] && BASE="Claude Code"
fi

case "$ACTION" in
    working)
        NEW_TITLE="$BASE"
        ;;
    done)
        NEW_TITLE="● $BASE"
        ;;
    end)
        # Restore original custom title, or clear if it was the default
        if [ "$BASE" != "Claude Code" ]; then
            NEW_TITLE="$BASE"
        else
            NEW_TITLE=""
        fi
        set_title "$NEW_TITLE"
        rm -f "$CACHE"
        exit 0
        ;;
esac

# Update cache and set the title
printf '%s\n%s' "$BASE" "$NEW_TITLE" > "$CACHE"
set_title "$NEW_TITLE"
