;; extends

((comment) @injection.language
  .
  (pipeline
    (pipe_element
      [
        (val_string
          (raw_string_begin)
          (string_content) @injection.content
          (raw_string_end))
        (command
          (val_string
            (raw_string_begin)
            (string_content) @injection.content
            (raw_string_end)))
      ]))
  (#gsub! @injection.language "#%s+([%w%p]+)%s*" "%1")
  (#set! injection.combined))
