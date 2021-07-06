# Installation

## LaTeX

Make sure you have a working LaTeX installation on your computer. TeX Live and MikTeX are both fine. Also make sure that executables `xelatex`, `pdflatex`, `lualatex`, and most importantly `dvisvgm` (which does all the heavy-lifting) are available in your `PATH`.

By default `LatexSVG.jl` loads LaTeX packages `amsmath`, `amsthm`, `amssymb`, and `color`. They should already come prepackaged in your LaTeX distribution, but if not, install them first. If you use the MiKTeX distribution, you can also configure it to automatically install missing LaTeX packages. Alternatively, the [usage guide](usage.md) details how you can configure what LaTeX packages are loaded by default.

## LatexSVG.jl

Once you have a working LaTeX installation, go ahead and install this package in the Julia REPL:
```julia-repl
julia> using Pkg
julia> Pkg.add("LatexSVG")
```
