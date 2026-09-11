;; align-horizontal.lsp - Align texts and blocks to one Y value
;; Command: ALIGNH
;; Usage: ALIGNH -> pick reference object -> select objects to align
(defun c:ALIGNH ( / ref ry ss i en ed p )
  (setq ref (entsel "\nPick reference object: "))
  (if ref
    (progn
      (setq ry (cadr (cdr (assoc 10 (entget (car ref))))))
      (setq ss (ssget '((0 . "TEXT,MTEXT,INSERT"))))
      (if ss
        (progn
          (setq i 0)
          (repeat (sslength ss)
            (setq en (ssname ss i)
                  ed (entget en)
                  p (cdr (assoc 10 ed)))
            (setq ed (subst (cons 10 (list (car p) ry (caddr p)))
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
