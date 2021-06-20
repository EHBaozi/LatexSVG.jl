# Usage

```@setup out
using Documenter.Utilities.DOM
@tags span img

function svgout(path, size)
    span[:style => "display: inline-block; width: 100%"](
        img[
            :style => "display: block; margin: auto; verticle-align: middle; height: " * string(size) * "em",
            :src => path
        ]()
    )
end
```

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

The [`latexsvg`](@ref) function is the main api of this package. Here with the most simple usage, we pass a string of LaTeX code and `latexsvg` outputs a [`LaTeXSVG`](@ref) object that contains the SVG, which is automatically captured by `Documenter.jl` and rendered inline in this webpage. You can get inline rendering with any SVG-capable display environment, such as Jupyter, VS Code, or `Pluto.jl`.

Notice that the SVG output you see above is not center-aligned and its size doesn't really look good. This is because it's exactly what this package intends to accomplish: outputting plain SVGs. Accordingly, the flexibility of the SVG format affords you incredible power, but it also means that regardless of what your use case is you likely need to do a bit of extra work to make it look nice. As an example, section [Embedding in a webpage](@ref) below gives some instructions about embedding and styling SVG outputs in a webpage (and in `Documenter.jl`). We will also use those instructions to style the SVGs in this documentation so that they are more comparable to `MathJax` and `KaTeX` outputs.

If you are in an environment that cannot display SVG natively, such as the Julia REPL, this is what you'll see:

```@repl 1
svg_output = latexsvg(latex_code)
```

As you can see, the output also captures the LaTeX code and the preamble. In this case you can either load an SVG-capable display ([`ElectronDisplay.jl`](https://github.com/queryverse/ElectronDisplay.jl) is quite good for REPL usage) or save the output directly to a file:

```julia=repl
julia> savesvg("/path/to/file.svg", svg_output)
```

Now let's start customizing the output. The above example is quite boring as it simply uses the default LaTeX font which is also available in `MathJax` and `KaTeX`. Let's customize the preamble to load some LaTeX fonts:

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
savesvg("example1.svg", svg_output); nothing # hide
```

```@example out
svgout("example1.svg", 2.5) # hide
```

Now it has a much more distinct look.

## Customize the preamble

## Changing LaTeX engine

## Embedding in a webpage

```html
<span style="display: inline-block; width: 100%">
    <img style="display: block; margin: auto; verticle-align: middle; height: 2.5em", src="example1.svg" />
</span>
```
