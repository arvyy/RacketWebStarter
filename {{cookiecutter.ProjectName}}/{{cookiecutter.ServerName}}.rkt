#lang racket

(require json
		 net/uri-codec
		 web-server/servlet
		 web-server/servlet-env
		 web-server/templates
		 web-server/page
		 web-server/http/xexpr
		 web-server/configuration/responders)

(define start 
  (let-values ([(dispatcher url) 
			   (dispatch-rules
				 (("") index))])
	(lambda (request)
	  (dispatcher request))))

(define (index request)
  (let ([name (get-binding 'name request)])
	(render-template (include-template "tpl/index.html"))))

(define (render-template tpl)
  (response/full
	200 #"Okay"
	(current-seconds) TEXT/HTML-MIME-TYPE
	empty
	(list (string->bytes/utf-8 tpl))))

(serve/servlet
  start
  #:port 8080
  #:command-line? #t
  #:listen-ip #f
  #:extra-files-paths (list "static")
  #:stateless? #t
  #:servlets-root (current-directory)
  #:file-not-found-responder (gen-file-not-found-responder "./static/notfound.html")
  #:servlet-responder (gen-servlet-responder "./static/error.html")
  #:servlet-regexp #rx"")
