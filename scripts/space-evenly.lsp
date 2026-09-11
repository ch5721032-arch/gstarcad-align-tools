;; space-evenly.lsp - Space objects evenly between two ends
;; Command: SPACEEVEN
;; Usage: pick the first and last object, then select everything to space out
(defun c:SPACEEVEN ( / e1 e2 x1 x2 ss i lst en ed p n gap )
  (vl-load-com)
  (setq e1 (car (entsel "\nPick first object: ")))
  (setq e2 (car (entsel "\nPick last object: ")))
  (if (and e1 e2)
    (progn
      (setq x1 (car (cdr (assoc 10 (entget e1))))
            x2 (car (cdr (assoc 10 (entget e2)))))
      (setq ss (ssget '((0 . "TEXT,MTEXT,INSERT"))))
      (if ss
        (progn
          (setq i 0 lst nil)
          (repeat (sslength ss)
            (setq lst (cons (ssname ss i) lst)
                  i (1+ i))
          )
          (setq lst (vl-sort lst
                     (function
                       (lambda (a b)
                         (< (car (cdr (assoc 10 (entget a))))
                            (car (cdr (assoc 10 (entget b)))))))) )
          (if (> (length lst) 2)
            (progn
              (setq n (length lst)
                    gap (/ (- x2 x1) (float (1- n)))
                    i 0)
              (foreach en lst
                (setq ed (entget en)
                      p (cdr (assoc 10 ed)))
                (setq ed (subst (cons 10 (list (+ x1 (* gap i))
                                               (cadr p) (caddr p)))
                                (assoc 10 ed) ed))
                (entmod ed)
                (setq i (1+ i))
              )
              (princ "\nSpaced evenly.")
            )
            (princ "\nNeed at least three objects.")
          )
        )
      )
    )
  )
  (princ)
)
