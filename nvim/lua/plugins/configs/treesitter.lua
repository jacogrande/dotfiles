local options = {
  ensure_installed = {
    "lua",
    "typescript",
    "bash",
    "css",
    "diff",
    "html",
    "javascript",
    "json",
    "markdown",
    "regex",
    "rust",
    "sql",
    "svelte",
    "typescript",
    "yaml",
    "go",
    "tsx",
  },

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = { enable = true },

  context_commentstring = {
    config = {
      javascript = {
        __default = '// %s',
        jsx_element = '{/* %s */}',
        jsx_fragment = '{/* %s */}',
        jsx_attribute = '// %s',
        comment = '// %s',
      },
      typescript = { __default = '// %s', __multiline = '/* %s */' },
    }
  }
}

return options
