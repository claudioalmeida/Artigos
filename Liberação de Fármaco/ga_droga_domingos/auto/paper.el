(TeX-add-style-hook "paper"
 (lambda ()
    (LaTeX-add-labels
     "sec:intro"
     "meth:higuchi"
     "meth:ga"
     "eq:higuchi")
    (TeX-run-style-hooks
     "dcolumn"
     "graphicx"
     "amssymb"
     "amsmath"
     "latex2e"
     "revtex410"
     "revtex4"
     "superbib"
     "showpacs"
     "aps"
     "preprint")))

