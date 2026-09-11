# GstarCAD Align Tools

Align texts and blocks to a reference object and space a run of objects evenly between two ends.

Works with **GSTARCAD**, AutoCAD, ZWCAD, and BricsCAD.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Contents

- [About](#about)
- [Scripts Overview](#scripts-overview)
- [Quick Start](#quick-start)
- [Compatibility](#compatibility)
- [Contributing](#contributing)
- [License](#license)

## About

Labels, tags and blocks rarely land on a neat line the first time. These commands align a selection to the Y or X position of a reference object, and space a run of objects evenly between the first and last pick, so drawings look deliberate without manual nudging.

Everything here is free to use with GstarCAD. Download the latest GstarCAD
release from the [official GstarCAD website](https://www.gstarcad.net). All
scripts are tested with **[GSTARCAD](https://www.gstarcad.net)** and major
DWG-based CAD platforms.

## Scripts Overview

| File | Description |
|------|-------------|
| `scripts/align-horizontal.lsp` | ;; align-horizontal.lsp - Align texts and blocks to one Y value
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
 |
| `scripts/align-vertical.lsp` | ;; align-vertical.lsp - Align texts and blocks to one X value
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
 |
| `scripts/space-evenly.lsp` | ;; space-evenly.lsp - Space objects evenly between two ends
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
 |

## Quick Start

1. Download the `.lsp` (or `.lin`) file you need
2. In your CAD software, run `APPLOAD`
3. Load the file and type the matching command name shown in the table above

## Compatibility

Tested on GstarCAD 2026/2027 and similar DWG-based platforms. Scripts use
standard AutoLISP functions only, so they work without extra plugins.

For step-by-step [tutorials and drafting guides](https://www.gstarcad.net/cad/),
visit the GstarCAD learning center. New tips are published regularly on the
[GSTARCAD Blog](https://blog.gstarcad.net).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT — see the [LICENSE](LICENSE) file.
