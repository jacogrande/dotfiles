# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

- No formal build/test commands (dotfiles configuration repository)
- Manual testing: Check configurations load properly in respective applications

## Style Guidelines

- **Neovim Lua**:
  - Return tables as modules (`M = {}`)
  - Group mappings by mode (n, v, i, t)
  - Leader-based mapping patterns (`<leader>fm` for format)
- **Zsh**:
  - Functions: snake_case with descriptive names
  - Variables: Locals within functions, UPPERCASE for env vars
  - Aliases: Short, mnemonic abbreviations (gs, gc, gp)
  - Error handling: Validate inputs, provide help messages
- **General**:
  - Modular organization with functionality-specific files
  - Clean separation between default and custom configurations
  - Consistent comment style with function documentation
  - Shell commands should use command substitution `$(command)`
  - Git commit style: Follows conventional commit format
