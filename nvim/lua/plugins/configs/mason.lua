local options = {
  ensure_installed = {
    "lua-language-server",
    "bash-language-server",
    "css-lsp",
    "eslint-lsp",
    "emmet-language-server",
    "haskell-language-server",
    "html-lsp",
    "json-lsp",
    "next-ls",
    "rust-analyzer",
    "svelte-language-tools",
    "tailwindcss-language-server",
    "typescript-language-server",
  }, -- not an option from mason.nvim

  PATH = "skip",

  ui = {
    icons = {
      package_pending = " ",
      package_installed = "󰄳 ",
      package_uninstalled = " 󰚌",
    },

    keymaps = {
      toggle_server_expand = "<CR>",
      install_server = "i",
      update_server = "u",
      check_server_version = "c",
      update_all_servers = "U",
      check_outdated_servers = "C",
      uninstall_server = "X",
      cancel_installation = "<C-c>",
    },
  },

  max_concurrent_installers = 10,
}

return options
