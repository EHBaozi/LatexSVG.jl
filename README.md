# LatexSVG

This is a small package that renders LaTeX as SVG, by utilizing the `dvisvgm` executable bundled with all major LaTeX distributions. It allows you to set custom preambles and is capable of rendering any LaTeX code that is considered valid by `pdflatex` or `xelatex` engine, and is thus much more flexible and powerful than js-based alternatives like `mathjax` or `KaTeX`.

> Currently `lualatex` is not supported: `dvisvgm` is capable of cropping the svg to a tightly bounded area around the LaTeX content, but only when it deals with dvi files, and `lualatex`'s dvi output can be problematic.
