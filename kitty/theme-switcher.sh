#!/bin/bash

# Theme lists
DARK_THEMES=(
  "Catppuccin-Macchiato"
  "Adventure Time"
  "Alucard"
  "Aquarium Dark"
  "Atelier Sulphurpool Dark"
  "Ayaka"
  "Base2Tone Pool Dark"
  "Base2Tone Field Dark"
  "Base2Tone Suburb Dark"
  "Duskfox"
  "Eldritch"
  "Fideloper"
  "Kanagawa"
  "Kaolin Galaxy"
  "Mayukai"
  "Mellow"
  "moonlight"
  "Pencil Dark"
  "Rose Pine"
  "Seafoam Pastel"
  "shadotheme"
  "Terafox"
  "Tokyo Night Moon"
  "Vaughn"
)

LIGHT_THEMES=(
  "Aquarium Light"
  "Catppuccin-Latte"
  "Dawnfox"
  "Everforest Light Medium"
  "Github"
  "Novel"
  "Ocean"
  "Selenized Light"
  "Selenized White"
  "seoulbones_light"
  "Spring"
  "Tokyo Night Day"
)

# NvChad theme mappings
NVCHAD_DARK_THEMES=(
  "catppuccin" # Catppuccin-Macchiato
  "chadracula" # Adventure Time
  "chadracula" # Alucard
  "aquarium" # Aquarium Dark
  "tundra" # Atelier Sulphurpool Dark
  "kanagawa" # Ayaka
  "tundra" # Base2Tone Pool Dark
  "decay" # Base2Tone Field Dark
  "onedark" # Base2Tone Suburb Dark
  "rosepine" # Duskfox
  "chadracula" # Eldritch
  "github_dark" # Fideloper
  "kanagawa" # Kanagawa
  "nightfox" # Kaolin Galaxy
  "vscode_dark" # Mayukai
  "gruvbox" # Mellow
  "nightowl" # moonlight
  "gruvchad" # Pencil Dark
  "rosepine" # Rose Pine
  "everforest" # Seafoam Pastel
  "onedark" # shadotheme
  "rxyhn" # Terafox
  "tokyonight" # Tokyo Night Moon
  "decay" # Vaughn
)

NVCHAD_LIGHT_THEMES=(
  "oceanic-light" # Aquarium Light
  "oceanic-light" # Catppuccin-Latte
  "blossom_light" # Dawnfox
  "oceanic-light" # Everforest Light Medium
  "github_light" # Github
  "oceanic-light" # Novel
  "oceanic-light" # Ocean
  "oceanic-light" # Selenized Light
  "oceanic-light" # Selenized White
  "oceanic-light" # seoulbones_light
  "oceanic-light" # Spring
  "github_light" # Tokyo Night Day
)

# Check macOS appearance setting
check_dark_mode() {
  if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q "Dark"; then
    return 0
  else
    return 1
  fi
}

# Get a theme from the appropriate list
get_theme() {
  local mode=$1
  local index=$2  # No default value - will handle it below
  
  if [ "$mode" = "dark" ] || ([ "$mode" = "auto" ] && check_dark_mode); then
    # Dark mode
    THEMES=("${DARK_THEMES[@]}")
  else
    # Light mode
    THEMES=("${LIGHT_THEMES[@]}")
  fi
  
  # Handle when no index is specified or random selection
  if [ -z "$index" ] || [ "$index" = "random" ]; then
    index=$((RANDOM % ${#THEMES[@]}))
    # Export the random index so we can use it later
    export RANDOM_THEME_INDEX=$index
  fi
  
  # Ensure index is within bounds
  if [[ "$index" -ge "${#THEMES[@]}" ]]; then
    index=0
  fi
  
  echo "${THEMES[$index]}"
}

# Function to list available themes
list_themes() {
  echo "Dark themes:"
  for i in "${!DARK_THEMES[@]}"; do
    echo "  $i: ${DARK_THEMES[$i]}"
  done
  
  echo "Light themes:"
  for i in "${!LIGHT_THEMES[@]}"; do
    echo "  $i: ${LIGHT_THEMES[$i]}"
  done
}

# Check for command line arguments
if [ "$1" = "list" ]; then
  list_themes
  exit 0
elif [ "$1" = "dark" ] || [ "$1" = "light" ]; then
  THEME=$(get_theme "$1" "$2")
else
  # Auto mode based on system setting
  THEME=$(get_theme "auto" "$1")
fi

# Function to update NvChad theme
update_nvchad_theme() {
  local mode=$1
  local index=$2
  local nvchad_theme=""
  local is_dark_mode=false

  # Determine if we should use dark mode
  if [ "$mode" = "dark" ]; then
    is_dark_mode=true
  elif [ "$mode" = "light" ]; then
    is_dark_mode=false
  elif [ "$mode" = "auto" ]; then
    if check_dark_mode; then
      is_dark_mode=true
    else
      is_dark_mode=false
    fi
  else
    # Default: check system setting
    if check_dark_mode; then
      is_dark_mode=true
    else
      is_dark_mode=false
    fi
  fi

  # Select the appropriate NvChad theme array
  if [ "$is_dark_mode" = "true" ]; then
    # Dark mode
    NVCHAD_THEMES=("${NVCHAD_DARK_THEMES[@]}")
  else
    # Light mode
    NVCHAD_THEMES=("${NVCHAD_LIGHT_THEMES[@]}")
  fi
  
  # Use the same index as the kitty theme
  nvchad_theme="${NVCHAD_THEMES[$index]}"
  
  # Check if nvchad theme is not empty
  if [ -n "$nvchad_theme" ]; then
    # Path to chadrc.lua
    local chadrc_path="$HOME/.config/dotfiles/nvim/lua/custom/chadrc.lua"
    
    # Update the theme in chadrc.lua using a more robust sed pattern
    sed -i '' "s/M\.ui = {theme = '[^']*'}/M.ui = {theme = '$nvchad_theme'}/" "$chadrc_path"
    
    echo "NvChad theme updated to: $nvchad_theme"
    
    # Find all running neovim instances and update them
    update_running_nvim_instances "$nvchad_theme"
  fi
}

# Function to update running Neovim instances with the new theme
update_running_nvim_instances() {
  local nvchad_theme=$1
  
  # Complete NvChad theme switching sequence (same as Telescope themes)
  local lua_cmd="vim.schedule(function() vim.g.nvchad_theme = '$nvchad_theme'; require('plenary.reload').reload_module('custom.chadrc'); require('base46').load_all_highlights(); vim.api.nvim_exec_autocmds('User', { pattern = 'NvChadThemeReload' }) end)"
  
  echo "Attempting to update running Neovim instances..."

  # For macOS, we directly send a command to Neovim through osascript (AppleScript)
  # This will work if Neovim is running in a terminal or iTerm2
  if [ "$(uname)" = "Darwin" ]; then
    # Try to use nvr if available (preferred method)
    if command -v nvr &> /dev/null; then
      echo "Using neovim-remote to update instances..."
      nvr --serverlist | while read -r server; do
        echo "Updating Neovim instance: $server"
        NVIM_LISTEN_ADDRESS="$server" nvr --remote-send ":lua $lua_cmd<CR>"
      done
    else
      # Try AppleScript approach
      echo "Trying AppleScript approach to update Neovim instances..."
      
      # Check if Neovim is running in kitty
      if pgrep -f "kitty.*nvim" > /dev/null; then
        echo "Detected Neovim running in kitty terminal"
        osascript -e "tell application \"kitty\" to tell window 1
          activate
          delay 0.1
          tell application \"System Events\" to keystroke \":lua require('base46').load_all_highlights()\" & return
        end tell" 2>/dev/null || true
      fi
      
      # If using Terminal.app
      if pgrep -f "Terminal.*nvim" > /dev/null; then
        echo "Detected Neovim running in Terminal.app"
        osascript -e "tell application \"Terminal\" to tell window 1
          activate
          delay 0.1
          tell application \"System Events\" to keystroke \":lua require('base46').load_all_highlights()\" & return
        end tell" 2>/dev/null || true
      fi
      
      # If using iTerm2
      if pgrep -f "iTerm2.*nvim" > /dev/null; then
        echo "Detected Neovim running in iTerm2"
        osascript -e "tell application \"iTerm2\" to tell current window
          activate
          delay 0.1
          tell application \"System Events\" to keystroke \":lua require('base46').load_all_highlights()\" & return
        end tell" 2>/dev/null || true
      fi
      
      echo "Note: Install neovim-remote (pip install neovim-remote) for more reliable updates:"
      echo "    pip3 install neovim-remote"
    fi
  else
    # Linux socket paths
    for socket_dir in "$HOME/.local/state/nvim" "/tmp"; do
      if [ -d "$socket_dir" ]; then
        for socket_file in "$socket_dir"/nvim*; do
          if [ -S "$socket_file" ]; then
            echo "Updating Neovim instance: $socket_file"
            if command -v socat &> /dev/null; then
              printf "\x1b:lua %s\r" "$lua_cmd" | socat - UNIX-CONNECT:"$socket_file" 2>/dev/null || true
            fi
          fi
        done
      fi
    done
  fi
}

# Apply the kitty theme
echo $THEME
kitten themes --reload-in=all "$THEME"

# Get the index of the selected theme for updating NvChad
theme_index=0
if [ "$1" = "dark" ] || [ "$1" = "light" ]; then
  if [[ "$2" =~ ^[0-9]+$ ]]; then
    theme_index=$2
  elif [ "$2" = "random" ] && [ -n "$RANDOM_THEME_INDEX" ]; then
    # Use the exported random index from get_theme
    theme_index=$RANDOM_THEME_INDEX
  fi
else
  # Auto mode
  if [[ "$1" =~ ^[0-9]+$ ]]; then
    theme_index=$1
  elif [ "$1" = "random" ] && [ -n "$RANDOM_THEME_INDEX" ]; then
    theme_index=$RANDOM_THEME_INDEX
  fi
fi

# Update NvChad theme
update_nvchad_theme "$1" "$theme_index"
