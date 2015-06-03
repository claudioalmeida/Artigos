(TeX-add-style-hook "beamer_listings"
 (lambda ()
    (TeX-add-symbols
     "maketitle")
    (TeX-run-style-hooks
     "graphicx"
     "color"
     "listings")))

