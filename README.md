# dotfiles

Personal configuration for zsh, neovim (NvChad), kitty, and starship.

---

## Quick Setup (New Machine)

### 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Clone this repo

```bash
git clone https://github.com/yourusername/dotfiles ~/.config/dotfiles
```

### 3. Install packages via Brewfile

```bash
brew bundle --file=~/.config/dotfiles/Brewfile
```

This installs the core toolchain. See [Brewfile contents](#brewfile) below for the full list.

### 4. Create symlinks

```bash
# Neovim (NvChad)
ln -s ~/.config/dotfiles/nvim ~/.config/nvim

# Kitty
ln -s ~/.config/dotfiles/kitty ~/.config/kitty

# Starship
ln -s ~/.config/dotfiles/starship.toml ~/.config/starship.toml
```

### 5. Configure your shell

Add the following to `~/.zshrc`:

```zsh
# autojump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# Secrets (API keys, tokens — not committed to git)
[ -f "$HOME/.secrets" ] && source "$HOME/.secrets"

# Dotfiles
export DOTFILE_PATH="$HOME/.config/dotfiles/zsh"
for file in "$DOTFILE_PATH"/*.zsh; do
  source "$file"
done
```

API keys and tokens go in `~/.secrets` (never committed):

```zsh
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="..."
```

### 6. Set up asdf (runtime versions)

```bash
# Install asdf (if not already via Brewfile)
brew install asdf

# Add plugins
asdf plugin add nodejs
asdf plugin add elixir
asdf plugin add erlang
asdf plugin add gleam
asdf plugin add java
asdf plugin add pnpm

# Install versions (from .tool-versions or manually)
asdf install nodejs 22.0.0
asdf install elixir 1.17.3-otp-27
asdf install erlang 27.1.2
asdf install gleam nightly
asdf install java openjdk-21.0.2
```

### 7. Optional: silence the last login message

```bash
touch ~/.hushlogin
```

---

## Brewfile

The `Brewfile` captures the full toolchain. Run `brew bundle --file=Brewfile` to install everything at once. Key packages:

### Shell & Terminal
| Package | Purpose |
|---|---|
| `autojump` | Jump to frecent directories (`j project`) |
| `zsh-autosuggestions` | Fish-style command suggestions |
| `zsh-autocomplete` | Real-time tab completions |
| `fzf` | Fuzzy finder (used by many tools) |
| `gum` | Pretty interactive shell prompts |
| `thefuck` | Auto-correct mistyped commands |
| `lsd` | Modern `ls` with icons and color |
| `bat` | `cat` with syntax highlighting |
| `ripgrep` | Fast recursive grep (used by nvim) |
| `starship` | Cross-shell prompt |

### Development
| Package | Purpose |
|---|---|
| `neovim` | Editor |
| `gh` | GitHub CLI |
| `jq` | JSON processor |
| `watchman` | File watcher (used by some LSPs) |
| `uv` | Fast Python package manager |
| `pnpm` | Fast Node.js package manager |
| `maven` | Java build tool |
| `scc` | Fast code line counter |
| `tmux` | Terminal multiplexer |

### Fonts & Apps (Casks)
| Cask | Purpose |
|---|---|
| `font-hack-nerd-font` | Nerd Font for icons in nvim/kitty |
| `tomatobar` | Pomodoro timer in the menu bar |
| `calibre` | E-book manager |
| `codex` | OpenAI Codex CLI |

### Additional Casks to Install Manually

These aren't in the Brewfile but are part of the full setup:

```bash
brew install --cask kitty          # Terminal emulator
brew install --cask claude         # Claude desktop app
```

---

## Configuration Details

### Neovim

Built on [NvChad](https://nvchad.com/). After symlinking `nvim/`, open nvim and let lazy.nvim install plugins automatically.

Notable plugins: harpoon2, oil.nvim, nvim-dap, neotest, conform.nvim, nvim-lint, obsidian.nvim, render-markdown, diffview.nvim, telescope, noice.nvim.

LSP servers are managed by Mason. Key ones: `lua_ls`, `gopls`, `elixirls`, `gleam`, `svelte`, `marksman`.

### Kitty

Theme switching is handled by `kitty/theme-switcher.sh`, which syncs the kitty theme and the NvChad theme together. It auto-detects macOS light/dark mode on startup.

Aliases for theme switching:
```zsh
ktl        # switch to light theme
ktd        # switch to dark theme
ktr        # random theme (auto mode)
ktheme     # run theme switcher directly
ktcurrent  # show currently active theme
```

The custom tab bar (`tab_bar.py`) shows a clock, date, and battery percentage.

### Starship

Minimal prompt showing directory, git branch/status, command duration, and Python virtualenv.

### Quotes

The `fun.zsh` file includes a `quote` function. Call it to add a new quote to `quotes.json`. Use the `-p` flag to reuse the previous author. `get_random_quote` runs on shell startup.
