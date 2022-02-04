function _adjust_web_svg_dim(num_str::AbstractString)
    num = parse(Float64, String(num_str[begin:end - 2]))
    return @sprintf("%.6f", num / 10) * "rem"
end

function _adjust_web_svg_display(svg_str::String)
    svgobject = parsexml(svg_str)
    svgroot = root(svgobject)

    height = svgroot["height"]
    svgroot["height"] = _adjust_web_svg_dim(height)
    delete!(svgroot, "width")

    svgroot["class"] = "latexsvg-display"
    svgroot["style"] = "display: block; margin: auto; max-width: 80%"

    return string(svgobject)
end

function _adjust_web_svg_inline(svg_str::String)
    svgobject = parsexml(svg_str)
    svgroot = root(svgobject)

    height = svgroot["height"]
    svgroot["height"] = _adjust_web_svg_dim(height)
    delete!(svgroot, "width")

    svgroot["class"] = "latexsvg-inline"
    svgroot["style"] = "vertical-align: middle"

    return string(svgobject)
end

function Base.show(io::IO, ::MIME"text/html", svg::LaTeXSVG)
    write(io, "<p><span class=\"latexsvg-display-container\" style=\"display: inline-block; width: 100%\">\n")
    write(io, _adjust_web_svg_display(svg.svg))
    write(io, "</span></p>")
end

function Base.show(io::IO, ::MIME"juliavscode/html", svg::LaTeXSVG)
    write(io, """
    <script>
    let head = document.getElementsByTagName("head")[0];
    let style = document.createElement("style");
    let stylestr = document.createTextNode(".vscode-dark .latexsvg-display{fill:#fff}");
    style.append(stylestr);
    head.append(style);
    </script>
    """)
    write(io, "<p><span class=\"latexsvg-display-container\" style=\"display: inline-block; width: 100%\">\n")
    write(io, _adjust_web_svg_display(svg.svg))
    write(io, "</span></p>")
end

Base.show(io::IO, ::Union{MIME"application/juno+plotpane", MIME"application/prs.juno.plotpane+html"}, svg::LaTeXSVG) =
    Base.show(io, MIME"text/html"(), svg)
