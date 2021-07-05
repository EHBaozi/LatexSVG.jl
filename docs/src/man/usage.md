# Usage

## A simple example

Let's begin by rendering a simple formula:

```@example 1
using LatexSVG

svg_output = latexsvg(raw"""
\[
i \hbar \frac{\mathrm{d}}{\mathrm{d} t} | \phi(t) \rangle = \hat{\mathcal{H}} | \phi(t) \rangle
\]
""")
```

[`latexsvg`](@ref) is the main function of this package. Here with the most simple usage, we pass a string of LaTeX code and `latexsvg` outputs the SVG image. Here it is automatically captured by `Documenter.jl` and displayed inline in this webpage. Any SVG- or HTML-capable display environment, such as `Documenter.jl`, Jupyter, VS Code, and `Pluto.jl`, can display the SVG output.

In addition to the `latexsvg` function, you can also use the [`@Lsvg_str`](@ref) macro, which is functionally equivalent to `latexsvg`:

```@example 1
svg_output = Lsvg"""
\[
i \hbar \frac{\mathrm{d}}{\mathrm{d} t} | \phi(t) \rangle = \hat{\mathcal{H}} | \phi(t) \rangle
\]
"""
```

The output of `latexsvg` and `Lsvg"..."` is not just a string of SVG code; it is a [`LaTeXSVG`](@ref) object that contains the SVG as well as your LaTeX input and the preamble for record-keeping (You can customize the preamble; see the section [Customizing the preamble](@ref).) Thus, if you are in an environment that cannot display SVG/HTML natively, such as the Julia REPL, this is what you'll see:

```@repl 1
svg_output = latexsvg(raw"""
\[
i \hbar \frac{\mathrm{d}}{\mathrm{d} t} | \phi(t) \rangle = \hat{\mathcal{H}} | \phi(t) \rangle
\]
""")
```

In this case, you can either load an SVG/HTML-capable display or save the output directly to a file:

```julia-repl
julia> savesvg("/path/to/file.svg", svg_output)
```

---

The functions and macros introduced so far have a number of extra features. Here are the complete descriptions:

```@docs
latexsvg
@Lsvg_str
LaTeXSVG
```

## Configurations

### Customizing the preamble

By default, the preamble is populated with

```latex
\usepackage{amsmath,amsthm,amssymb}
\usepackage{color}
```

You can configure the preamble with [`add_preamble!`](@ref) and [`reset_preamble!`](@ref):

```@docs
add_preamble!
reset_preamble!
```

For example, here we can do

```@example 1
add_preamble!(
    "\\usepackage[no-math]{fontspec}",
    "\\setmainfont{texgyrepagella}[Extension=.otf,UprightFont=*-regular,ItalicFont=*-italic,BoldFont=*-bold,BoldItalicFont=*-bolditalic]",
    "\\usepackage[euler-hat-accent,euler-digits]{eulervm}",
    "\\usepackage{physics}"
)
```

You can inspect the complete preamble with [`preamble`](@ref):

```@docs
preamble
```

`add_preamble!` also returns the complete preamble immediately, as shown above.

Now let's render the same formula as the one in the previous section:

```@example 1
svg_output = Lsvg"""
\[
i \hbar \dv{t} \ket{\phi(t)} = \hat{\mathcal{H}} \ket{\phi(t)}
\]
"""
```

The input is now significantly more concise and the output has a much more distinct look.

One more example, just for fun:

```@example 1
maxwell = Lsvg"""
\begin{align*}
 \div{ \vb{E} } &= \frac{\rho}{\epsilon_0} \\
 \div{ \vb{B} } &= 0                       \\  % someone please find
\curl{ \vb{E} } &= - \pdv{\vb{B}}{t}       \\  % the magnetic monopole
\curl{ \vb{B} } &= \mu_0 \vb{J} + \mu_0 \epsilon_0 \pdv{\vb{E}}{t}
\end{align*}
"""
```

### Changing LaTeX engine

At load time, LatexSVG searches for `xelatex`, `pdflatex`, and `lualatex` in your PATH in order, and uses the first one it finds. You can also choose from the available options with [`texengine!`](@ref):

```@docs
texengine!
texengine
XeLaTeX
PDFLaTeX
LuaLaTeX
```

Additionally, you can pass your LaTeX engine of choice directly to [`latexsvg`](@ref), as shown in the previous section.

### Persisting the configurations

You can store your configurations and have them persist between Julia sessions using the [`config!`](@ref) function:

```@docs
config!
```

As another example, so far we've left `XeLaTeX` as the LaTeX engine and configured a number of preamble statements; as a result, when we call `config!()`, a `LocalPreferences.toml` file is created in our project with this content:

```toml
[LatexSVG]
preamble = ["\\usepackage{amsmath,amsthm,amssymb}", "\\usepackage{color}", "\\usepackage[no-math]{fontspec}", "\\setmainfont{texgyrepagella}[Extension=.otf,UprightFont=*-regular,ItalicFont=*-italic,BoldFont=*-bold,BoldItalicFont=*-bolditalic]", "\\usepackage[euler-hat-accent,euler-digits]{eulervm}", "\\usepackage{physics}"]
texengine = "XeLaTeX"
```

Then, every time we load this package in the future, these preferences get loaded as the default.

You can also inspect your config with [`config`](@ref):

```@docs
config
```

## Use with other packages

The [`latexsvg`](@ref) function accepts any `AbstractString` object as input. Notably, output from [LaTeXStrings.jl](https://github.com/stevengj/LaTeXStrings.jl) and [Latexify.jl](https://github.com/korsbo/Latexify.jl) work out of the box. For example, you can do

```julia
using Latexify, LatexSVG

latexify(
    [2//3  "e^(-c*t)" :(x/(x+k_1))
     1+3im "gamma(n)" :(log10(x))], starred=true
) |> latexsvg
```

and the latexified matrix will be nicely rendered as SVG.
