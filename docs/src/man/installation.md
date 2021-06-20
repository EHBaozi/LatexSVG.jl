# Installation

## LaTeX

Make sure you have a working LaTeX installation on your computer. TeX Live and MikTeX are both fine. Also make sure that executables `pdflatex`, `xelatex`, and most importantly `dvisvgm` (which does all the heavy-lifting) are available in your `PATH`.

By default `LatexSVG.jl` requires LaTeX packages `amsmath`, `amsthm`, `amssymb`, and `color`. They should already come prepackaged in your LaTeX distribution, but if not, install them first. If you use the MikTeX distribution, you can also configure it to automatically install missing LaTeX packages.

## LatexSVG.jl

Once you have a working LaTeX installation, go ahead and install this package in the Julia REPL:
```julia
using Pkg
Pkg.install("LatexSVG")
```
