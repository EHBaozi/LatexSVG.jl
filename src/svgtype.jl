"""
    LaTeXSVG(latex::AbstractString, svg::String; standalone::Bool=false)

This type contains the LaTeX code to be rendered, the preamble, and the rendered svg string. Objects of type `LaTeXSVG` can be rendered by any svg-capable display.

`LaTeXSVG` objects contain 4 fields:
- `latex` contains the LaTeX code to be rendered.
- `standalone` indicates whether `latex` is a complete LaTeX document. If `standalone=true` then `pre` is empty.
- `pre` is a vector of strings containing the preamble, which is recorded from the global preamble when a `LaTeXSVG` instance is contructed, namely when [`latexsvg`](@ref) is called.
- `svg` contains the rendered svg string.

Access these fields with the usual dot syntax.

You should not need to contruct a `LaTeXSVG` object yourself; instead, render your LaTeX code with the `latexsvg` function, which returns a `LaTeXSVG` object.
"""
struct LaTeXSVG
    latex::AbstractString
    standalone::Bool
    pre::Vector{String}
    svg::String
    function LaTeXSVG(latex::AbstractString, svg::String; standalone::Bool=false)
        if standalone
            return new(latex, true, String[], svg)
        else
            return new(latex, false, deepcopy(current_preamble()), svg)
        end
    end
end

function Base.print(io::IO, svg::LaTeXSVG)
    print(io, "LaTeXSVG\n    LaTeX: ")
    latex_split = split(svg.latex, "\n")
    print(io, latex_split[begin] * "\n")
    for line in latex_split[begin + 1:end]
        print(io, "           $(line)\n")
    end
    if !svg.standalone
        print(io, "    preamble: $(svg.pre[begin])")
        for pre in svg.pre[begin + 1:end]
            print(io, "\n              " * pre)
        end
    end
end

Base.show(io::IO, ::MIME"text/plain", svg::LaTeXSVG) = print(io, svg)
Base.show(io::IO, ::MIME"image/svg+xml", svg::LaTeXSVG) = write(io, svg.svg)

function Base.show(io::IO, ::MIME"text/html", svg::LaTeXSVG)
    write(io, "<p><span style=\"display: inline-block; width: 100%\">\n")
    write(io, _adjust_web_svg(svg.svg))
    write(io, "</span></p>")
end
