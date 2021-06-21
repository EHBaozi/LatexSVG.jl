# Usage

## A simple example

Let's begin by rendering a simple formula:

```@example 1
using LatexSVG

latex_code = raw"""
\[
i \hbar \frac{\mathrm{d}}{\mathrm{d} t} | \phi(t) \rangle = \hat{\mathcal{H}} | \phi(t) \rangle
\]
"""

svg_output = latexsvg(latex_code)
```

The [`latexsvg`](@ref) function is the main api of this package. Here with the most simple usage, we pass a string of LaTeX code and `latexsvg` outputs a [`LaTeXSVG`](@ref) object that contains the SVG, which is automatically captured by `Documenter.jl` and rendered inline in this webpage. You can get inline rendering with any SVG- or HTML-capable display environment, such as `Documenter.jl`, Jupyter, VS Code, and `Pluto.jl`.

If you are in an environment that cannot display SVG/HTML natively, such as the Julia REPL, this is what you'll see:

```@repl 1
svg_output = latexsvg(latex_code)
```

As you can see, the output also captures the LaTeX code and the preamble. In this case you can either load an SVG/HTML-capable display ([`ElectronDisplay.jl`](https://github.com/queryverse/ElectronDisplay.jl) is quite good for REPL usage) or save the output directly to a file:

```julia=repl
julia> savesvg("/path/to/file.svg", svg_output)
```

Now let's add some style. The above example is quite boring as it simply uses the default LaTeX font. Let's customize the preamble to load some LaTeX fonts:

```@example 1
add_preamble!(
    raw"\usepackage{tgpagella}",  # load the TeX Gyre Pagella font
    raw"\usepackage{eulervm}"     # load the euler math font
)

latex_code = raw"""
\[
i \hbar \frac{\mathrm{d}}{\mathrm{d} t} | \phi(t) \rangle = \hat{\mathcal{H}} | \phi(t) \rangle
\]
"""

svg_output = latexsvg(latex_code)
```

Now it has a much more distinct look.

## Customize the preamble

## Changing LaTeX engine

## Embedding in a webpage

```html
<span style="display: inline-block; width: 100%">
    <img style="display: block; margin: auto" src="example1.svg" />
</span>
```
