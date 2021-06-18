"""
    LaTeXSVG(latex::AbstractString, svg::String)

This type contains the LaTeX code to be rendered, the preamble, and the rendered svg string. Objects of type `LaTeXSVG` can be rendered by any svg-capable display.

`LaTeXSVG` objects contain 3 fields: `latex` contains the LaTeX code to be rendered, `pre` contains the preamble, and `svg` contains the rendered svg string. Access them with the usual dot syntax.

You should not need to contruct a `LaTeXSVG` object yourself; instead, render your LaTeX code with the [`latexsvg`](@ref) function, which returns a `LaTeXSVG` object.
"""
struct LaTeXSVG
    latex::AbstractString
    pre::Vector{String}
    svg::String
    function LaTeXSVG(latex::AbstractString, svg::String)
        return new(latex, deepcopy(current_preamble()), svg)
    end
end

Base.show(io::IO, ::MIME"image/svg+xml", svg::LaTeXSVG) = write(io, svg.svg)

function Base.print(svg::LaTeXSVG)
    print("LaTeXSVG\n    LaTeX: $(svg.latex)\n    preamble: $(svg.pre[begin])")
    for pre in svg.pre[begin + 1:end]
        print("\n              " * pre)
    end
end
