#!/bin/bash
# Manages kitty tab title indicators for Claude Code sessions.
# Completely stateless — reads the current tab title each time and
# toggles the ● prefix. No cache files, so no stale-state bugs
# when kitty reuses window IDs across sessions.
#
# Usage: claude-tab-title.sh <working|done|end>

set -euo pipefail

ACTION="${1:?Usage: claude-tab-title.sh <working|done|end>}"

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

case "$ACTION" in
    working)
        if [[ "$CURRENT" == "● "* ]]; then
            set_title "${CURRENT#● }"
        elif [ -z "$CURRENT" ]; then
            set_title "Claude Code"
        fi
        ;;
    done)
        if [[ "$CURRENT" != "● "* ]]; then
            set_title "● ${CURRENT:-Claude Code}"
        fi
        ;;
    end)
        BARE="${CURRENT#● }"
        if [ "$BARE" = "Claude Code" ]; then
            set_title ""
        else
            set_title "$BARE"
        fi
        ;;
esac
