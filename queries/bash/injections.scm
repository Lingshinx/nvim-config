(heredoc_redirect
  (heredoc_start)
  (comment) @injection.language
  (heredoc_body) @injection.content
  (#gsub! @injection.language "#%s+([%w%p]+%s*)" "%1")
  (#set! injection.combine))

