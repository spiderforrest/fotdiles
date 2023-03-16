;; extends

(("export"                  @keyword)                   (#set! conceal "◄"))
; (("return"                  @function_call)             (#set! conceal "ﰈ"))
; (("comment_start"           @comment)                   (#set! conceal ""))
(("if"                      @conditional)               (#set! conceal "?"))
(("then"                    @conditional)               (#set! conceal "↙"))
(("else"                    @conditional)               (#set! conceal "!"))
(("elif"                    @conditional)               (#set! conceal "¿"))
(("fi"                      @keyword)                   (#set! conceal "/"))

((command name: (command_name) @cap2 (#eq? @cap2 "echo")) (#set! conceal "🕻"))
((command name: (command_name) @cap2 (#eq? @cap2 "return")) (#set! conceal "ﰈ"))
; ((command name: (command_name) @cap2 (#eq? @cap2 "return")) @keyword)
