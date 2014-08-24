;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; message-wide-reply-to-function setzen (leider etwas laenglich geworden)
;;
;; nette Lisp-Spielchen, aber komplett ueberfluessig
;; ich kannte "S W runs `gnus-summary-wide-reply-with-original'" nicht...
;; damit geht es auch wie gewuenscht, wenn message-wide-reply-to-function nil ist (Default)

(defun myself-removed (addr-list)
  (or (and (null addr-list) "")
      (if (string-match (concat "[^,]*" user-mail-address "[^,]*,?") addr-list)
          (let
              ((rpl (replace-match "" nil nil addr-list)))
            (if (string-match ", *$" rpl)
                (replace-match "" nil nil rpl)
              rpl))
        addr-list)))


(defun comma-concat-2 (s1 s2)
  "concat s1 and s2, put comma in between if both are non-empty"
  (if (string-match "^ *$" s1)
      s2
    (if (string-match "^ *$" s2)
	s1
      (concat s1 ", " s2))))


(defun comma-concat (&rest strings)
  (let
      (next-el
       (result ""))
    (progn
      (while (setq next-el (pop strings))
	(setq result (comma-concat-2 result next-el)))
      result)))


(setq message-wide-reply-to-function
      (lambda nil
	(let
	    ((xref (gnus-fetch-field "Xref")))
	  (if (string-match "^[^ ]* +\\([^:]*\\):" xref)
	      (let
		  ((group (match-string 1 xref)))
		(cond
		 ((string= group "mail.tu.dokverw")
		  (comma-concat
		   (myself-removed (gnus-fetch-field "From"))
		   (myself-removed (gnus-fetch-field "To"))
		   (myself-removed (gnus-fetch-field "cc"))))))))))

;; message-wide-reply-to-function setzen Ende
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
