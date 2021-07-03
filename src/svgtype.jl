"""
    LaTeXSVG(latex::AbstractString, svg::String; standalone::Bool=false)

This type contains the LaTeX code to be rendered, the preamble, and the rendered SVG string. Both [`latexsvg`](@ref) and [`@Lsvg_str`](@ref) return objects of this type.

`LaTeXSVG` objects contain 4 fields:
- `latex` contains the LaTeX input.
- `standalone` indicates whether `latex` is a complete LaTeX document. If `standalone=true` then `pre` is empty.
- `pre` is a vector of strings containing the preamble, which is recorded from the global preamble when a `LaTeXSVG` object is contructed, namely when `latexsvg` or `@Lsvg_str` is called.
- `svg` contains the SVG string.

You can access these fields with the usual dot syntax.

!!! note
    You should never need to contruct a `LaTeXSVG` object yourself.

!!! note
    If you are using VSCode, by default the color of the SVG displayed in the plot pane adapts to the color scheme of VSCode (black for light mode and white for dark mode.) Rest assured that this adaptive color is not written into the SVG itself. Also, if you defined custom colors in your LaTeX, it should be displayed (and saved to file) faithfully.
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
            return new(latex, false, deepcopy(preamble()), svg)
        end
    end
end

function _shorten(line::AbstractString, maxlength::Int)
    if length(line) <= maxlength
        return line
    else
        return line[begin:(begin+maxlength-4)] * "..."
    end
end

function Base.print(io::IO, svg::LaTeXSVG)
    print(io, "LaTeXSVG\n\n    SVG: ")

    delim = Sys.iswindows() ? "\r\n" : "\n"
    svg_split = split(svg.svg, delim, limit=8)
    line_length = length(svg_split[begin])
    print(io, svg_split[begin], "\n")
    for line in svg_split[begin + 1:end - 1]
        print(io, "         ", _shorten(line, line_length), "\n")
    end
    print(io, "         .........\n")

    print(io, "\n    LaTeX: ")
    latex_split = split(svg.latex, "\n")
    print(io, latex_split[begin], "\n")
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
    write(io, "<p><span class=\"latexsvg-displaystyle\" style=\"display: inline-block; width: 100%\">\n")
    write(io, _adjust_web_svg(svg.svg))
    write(io, "</span></p>")
end

# For the VSCode extension; the javascript adapts svg color to light/dark mode
function Base.show(io::IO, ::MIME"juliavscode/html", svg::LaTeXSVG)
    write(io, """
    <script>
    let head = document.getElementsByTagName("head")[0];
    let style = document.createElement("style");
    let stylestr = document.createTextNode(".vscode-dark .latexsvg-displaystyle-svg{fill:#fff}");
    style.append(stylestr);
    head.append(style);
    </script>
    """)
    write(io, "<p><span class=\"latexsvg-displaystyle\" style=\"display: inline-block; width: 100%\">\n")
    write(io, _adjust_web_svg(svg.svg))
    write(io, "</span></p>")
end
