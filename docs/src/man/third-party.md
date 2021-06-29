# Use with other packages

## LaTeXStrings.jl

[LaTeXStrings.jl](https://github.com/stevengj/LaTeXStrings.jl) is a convenience package for writing LaTeX strings in Julia. It works with LatexSVG.jl out of the box. As an example,

```@example 1
using LatexSVG # hide
using LaTeXStrings

latexsvg(L"$$\frac{\mathrm{d}}{\mathrm{d}x} \sin x = \cos x$$")
```

## Latexify.jl

[Latexify.jl](https://github.com/korsbo/Latexify.jl) is a very powerful package that produces LaTeX from Julia objects. It also works with LatexSVG.jl out of the box. As an example,

```@example 1
using Latexify

latexify([2//3 "e^(-c*t)" 1+3im; :(x/(x+k_1)) "gamma(n)" :(log10(x))], starred=true) |> latexsvg
```
