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

The [`latexsvg`](@ref) function is the main api of this package. Here with the most simple usage, we pass a string of LaTeX code and `latexsvg` outputs a [`LaTeXSVG`](@ref) object that contains the SVG. Here it is automatically captured by `Documenter.jl` and rendered inline in this webpage. You can get inline rendering with any SVG- or HTML-capable display environment, such as `Documenter.jl`, Jupyter, VS Code, and `Pluto.jl`.

If you are in an environment that cannot display SVG/HTML natively, such as the Julia REPL, this is what you'll see:

```@repl 1
svg_output = latexsvg(raw"""
\[
i \hbar \frac{\mathrm{d}}{\mathrm{d} t} | \phi(t) \rangle = \hat{\mathcal{H}} | \phi(t) \rangle
\]
""")
```

Instead of rendering the SVG, the output captures the LaTeX code and the preamble. In this case you can either load an SVG/HTML-capable display or save the output directly to a file:

```julia-repl
julia> savesvg("/path/to/file.svg", svg_output)
```

Now let's load some LaTeX packages:

```@example 1
add_preamble!(
    "\\usepackage[no-math]{fontspec}",
    "\\setmainfont{TeX Gyre Pagella}",
    "\\usepackage[euler-hat-accent,euler-digits]{eulervm}",
    "\\usepackage{physics}"
)

svg_output = Lsvg"""
\[
i \hbar \dv{t} \ket{\phi(t)} = \hat{\mathcal{H}} \ket{\phi(t)}
\]
"""
```

Now the input is significantly more concise and the output has a much more distinct look. Notice here that we have used the [`@Lsvg_str`](@ref) macro. It is functionally equivalent to the [`latexsvg`](@ref) function but comes with a few nice features: you do not have to escape LaTeX special characters like `$` and `\` and you can interpolate variables with the `%$` syntax (see the api reference of [`@Lsvg_str`](@ref) for details.)

One more example, just for fun:

```@example 1
maxwell = Lsvg"""
\begin{align*}
\div{ \vb{E} }  &= \frac{\rho}{\epsilon_0} \\
\div{ \vb{B} }  &= 0                       \\  % someone please find
\curl{ \vb{E} } &= - \pdv{\vb{B}}{t}       \\  % the magnetic monopole
\curl{ \vb{B} } &= \mu_0 \vb{J} + \mu_0 \epsilon_0 \pdv{\vb{E}}{t}
\end{align*}
"""
```

## Configurations

### Customizing the preamble

In the above example, we have used [`add_preamble!`](@ref) to load additional LaTeX packages on top of the default, which is configured as
```latex
\usepackage{amsmath,amsthm,amssymb}
\usepackage{color}
```
You can obtain the complete preamble with [`preamble`](@ref):

```@repl 1
preamble()
```

If you want to reset the preamble to the default, simply call [`reset_preamble!`](@ref), or pass a keyword argument `reset=true` to `add_preamble!`.

### Changing LaTeX engine

By default the [`XeLaTeX`](@ref) engine is used. If you prefer [`PDFLaTeX`](@ref), simply do

```julia-repl
julia> texengine!(PDFLaTeX)
```

!!! note
    Currently we do not support `lualatex`. This is because we rely on the executable `dvisvgm` to crop the compiled document to remove all margins around the content, and it is only able to do this flexibly with `dvi` output, which `lualatex` does not handle well. If you have better suggestions, feel free to open an issue!

### Persisting the configurations

You can store your configurations and have them persist between Julia sessions using the [`config!`](@ref) function. When called without arguments, `config!()` stores the current state of your Julia session. In this example, we left `XeLaTeX` as the LaTeX engine and configured a number of preamble statements; as a result, `config!()` will create a `LocalPreferences.toml` file in our project with this content:

```toml
[LatexSVG]
preamble = ["\\usepackage{amsmath,amsthm,amssymb}", "\\usepackage{color}", "\\usepackage[no-math]{fontspec}", "\\setmainfont{TeX Gyre Pagella}", "\\usepackage[euler-hat-accent,euler-digits]{eulervm}", "\\usepackage{physics}"]
texengine = "XeLaTeX"
```

Then, every time we load this package in the future, these preferences get loaded as the default. Alternatively you can pass keyword arguments to `config!` explicitly:

```julia
config!(
    texengine=PDFLaTeX,
    preamble=[
        "\\usepackage{mathtools}",
        "\\usepackage{siunitx}"
    ]
)
```

## Embedding in a webpage

If you use one of the Julia packages that capture and display HTML output directly from Julia code (like `Documenter.jl` and `Weave.jl`), you should be all set: this package defines HTML display methods that nicely center-aligns the SVG, much like what you are seeing in this page. However if you are using the output SVG file directly in an HTML file, here is what you can do:

### Display style

1. Save the SVG file; then, either in the SVG file itself or through CSS, add styles `"display: block; margin: auto"`.

2. Copy paste the SVG into your HTML.

3. In your HTML file, wrap the SVG in `<span></span>` tags, and add styles `display: inline-block; width: 100%` to the `<span>` tags. (You can put these inside `<p>` if you want.) You can give it a class attribute so that you can use CSS for this purpose.

4. The resulting HTML should look like this:

```html
<span style="display: inline-block; width: 100%">
<svg style="display: block; margin: auto">
</svg>
</span>
```

You can alternatively embed the SVG using an `<img />` tag and attach the styles to it; however this way you lose the ability to customize the SVG directly through CSS.

### Inline style

You may also want to display the SVG inline, right alongside text. In this case, simply add a `vertical-align: middle` style to the SVG and copy-paste it inside `<span></span>`:

```html
<p>This is an inline
<span><svg style="vertical-align: middle">
</svg></span>
svg generated by <code>LatexSVG.jl</code>.
</p>
```

You can then take advantage of the flexibility of the SVG format and freely resize and style it. Specifically, if you are using this package in `Documenter.jl`, you can add the following CSS so that the SVG color respects dark mode:

```css
html.theme--documenter-dark svg {
    fill: #ffffff
}
```

!!! note
    Weirdly enough, there is actually no way to do inline display automatically in `Documenter.jl` or `Weave.jl`: the former is unable to evaluate and capture inline code (such as `Lsvg"$e^{\pi i} + 1 = 0$"`), while the latter can but either captures only plain text or wraps the output in a standalone paragraph all the time. This means that, as mentioned in the [Introduction](../index.md), this package can't yet function as a complete replacement for `mathjax` or `KaTeX` on the web.
