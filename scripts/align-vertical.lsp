;; align-vertical.lsp - Align texts and blocks to one X value
;; Command: ALIGNV
;; Usage: ALIGNV -> pick reference object -> select objects to align
(defun c:ALIGNV ( / ref rx ss i en ed p )
  (setq ref (entsel "\nPick reference object: "))
  (if ref
    (progn
      (setq rx (car (cdr (assoc 10 (entget (car ref))))))
      (setq ss (ssget '((0 . "TEXT,MTEXT,INSERT"))))
      (if ss
        (progn
          (setq i 0)
          (repeat (sslength ss)
            (setq en (ssname ss i)
                  ed (entget en)
                  p (cdr (assoc 10 ed)))
            (setq ed (subst (cons 10 (list rx (cadr p) (caddr p)))
                            (assoc 10 ed) ed))
            (entmod ed)
            (setq i (1+ i))
          )
          (princ (strcat "\nAligned " (itoa (sslength ss)) " objects."))
        )
      )
    )
  )
  (princ)
)
