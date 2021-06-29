# LatexSVG.jl

This is a small package that renders LaTeX as SVG using the native LaTeX installation on your computer, instead of javascript-based solutions such as `mathjax` or `KaTeX`. As a result, it accepts a much wider range of LaTeX input and is significantly more powerful, but is also quite a bit slower.

Depending on your use case, this package may or may not be what you want. Specifically, if you want to render math on a webpage, this package is not yet a full replacement of `mathjax` or `KaTeX` (not without a lot of manual work from the end user, anyway); on the other hand, use cases such as building vector graphics and animations should be served much better by this package.

Head over to [Installation](man/installation.md) for installation instructions.
