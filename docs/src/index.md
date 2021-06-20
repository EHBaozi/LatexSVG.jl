# LatexSVG.jl

This is a small package that renders $LaTeX$ as SVG using the native LaTeX installation on your computer, instead of javascript-based solutions such as `MathJax` or `KaTeX`. As a result, it accepts a much wider range of LaTeX input and is significantly more customizable, but is also quite a bit slower. If your use case is already well served by `MathJax` or `KaTeX` (such as rendering simple formulas on your website), you should keep using them. However if they do not provide the features you need (such as using LaTeX packages that are not available as `MathJax` extensions or using your favorite math font), this package can hopefully fill that role.

Head over to [Installation](man/installation.md) for installation instructions.
