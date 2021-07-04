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
savesvg
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

Here, we have:

```@repl 1
preamble()
```

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

By default the [`XeLaTeX`](@ref) engine is used. You can choose from the available options with [`texengine!`](@ref):

```@docs
texengine!
texengine
XeLaTeX
PDFLaTeX
LuaLaTeX
```

Additionally, you have already seen that you can pass your LaTeX engine of choice directly to the [`latexsvg`](@ref) function, and pass extra arguments to it.

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

## Embedding in a webpage

If you use one of the Julia packages that capture and display HTML output directly from Julia code (like `Documenter.jl` and `Weave.jl`), you should be all set: this package defines HTML display methods that nicely center-aligns the SVG, much like what you are seeing in this page. However if you are using the output SVG file directly in an HTML file, here is what you can do:

### Display style

1. Paste the SVG into your HTML.

2. Either in the SVG code itself or through CSS, add styles `"display: block; margin: auto"` to the outermost `<svg>` tag.

3. In your HTML file, wrap the SVG in `<span></span>` tags, and add styles `display: inline-block; width: 100%` to `<span>`. (You can put these inside `<p></p>` if you want.) You can give it a class attribute so that you can use CSS for this purpose.

4. The resulting HTML should look like this:

```html
<span style="display: inline-block; width: 100%">
<svg style="display: block; margin: auto">
</svg>
</span>
```

You can alternatively embed the SVG using an `<img />` tag and attach these styles to it; however this way you lose the ability to customize the SVG directly through CSS (which can be useful if, for instance, you want to change the `fill` color for light/dark mode.)

### Inline style

You may also want to display the SVG inline, right alongside text. In this case, simply add a `vertical-align: middle` style to the SVG and paste it inside `<span></span>`:

```html
<p>This is an inline
<span><svg style="vertical-align: middle">
</svg></span>
svg generated by LatexSVG.jl.
</p>
```

These are just the most basic instructions; the SVG format is very powerful and there is room for a lot of customizations.

!!! note
    Sadly, there is no way to do inline-style display automatically in `Documenter.jl` or `Weave.jl`: the former is unable to evaluate and capture inline code (such as `Lsvg"$abc$"`), while the latter can (with the syntax ``` `j Lsvg"$abc$` ```) but either captures only plain text or wraps the output in a standalone paragraph. This means that, as mentioned in the [introduction](../index.md), this package can't yet function as a complete replacement for `mathjax` or `KaTeX` in these environments without some user effort.

!!! note
    Continuing the point above, one way to replace `mathjax` with this package is to use `pandoc` filters. You can simply write a filter that replaces all inline and display math elements in your markdown document with raw HTML code blocks that contain the SVG output from this package. Downside being, of course, that `pandoc` does not (officially) recognize the Julia flavor of markdown so you may face some problems if you are using this flavor (although I have not tried this yet), and the fact that there isn't yet a Julia package that facilitates writing pandoc filters (although it's nothing more than manipulating JSON so it shouldn't be too hard in principle.)
