;; extends

(("and"             @keyword.function) (#set! conceal "&"))
(("return"          @keyword) (#set! conceal "ﰈ"))
(("then"            @conditional) (#set! conceal "↙"))
(("else"            @keyword) (#set! conceal "!"))
(("elseif"          @keyword) (#set! conceal "¿"))
(("for"             @repeat) (#set! conceal ""))
(("function"        @keyword) (#set! conceal ""))
(("end"             @keyword) (#set! conceal "–"))
(("do"              @keyword) (#set! conceal ""))
(("in"              @keyword) (#set! conceal "i"))
(("local"           @keyword) (#set! conceal "~"))
(("if"              @conditional) (#set! conceal "?"))
; (("comment_start"   @comment) (#set! conceal ""))

; ;; Function names
((function_call name: (identifier) @TSNote (#eq? @TSNote "require")) (#set! conceal ""))
((function_call name: (identifier) @TSNote (#eq? @TSNote "print"  )) (#set! conceal ""))
((function_call name: (identifier) @TSNote (#eq? @TSNote "pairs"  )) (#set! conceal "P"))
((function_call name: (identifier) @TSNote (#eq? @TSNote "ipairs" )) (#set! conceal "I"))

;; table.
((dot_index_expression table: (identifier) @keyword  (#eq? @keyword  "math" )) (#set! conceal ""))

;; vim.*
((function_call name: (identifier) @TSNote (#eq? @TSNote "map" )) (#set! conceal ""))
((function_call name: (identifier) @TSNote (#eq? @TSNote "lmap" )) (#set! conceal "⚿"))
