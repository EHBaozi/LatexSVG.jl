function _to_fixed_decimal(num_str::AbstractString)
    num = parse(Float64, String(num_str))
    return FixedDecimal{Int,6}(num)
end

function _adjust_web_svg_width(num_str::AbstractString)
    num = _to_fixed_decimal(num_str[begin:end - 2])
    return string(num / 10) * "rem"
end

function _adjust_web_svg(svg_str::String)
    svgobject = parse_string(svg_str)
    svgroot = root(svgobject)

    width = attribute(svgroot, "width")
    set_attribute(svgroot, "width", _adjust_web_svg_width(width))
    set_attribute(svgroot, "height", "auto")

    set_attribute(svgroot, "style", "display: block; margin: auto; max-width: 80%")
    set_attribute(svgroot, "class", "latexsvg-display")

    return string(svgobject)
end

function Base.show(io::IO, ::MIME"text/html", svg::LaTeXSVG)
    write(io, "<p><span class=\"latexsvg-display-container\" style=\"display: inline-block; width: 100%\">\n")
    write(io, _adjust_web_svg(svg.svg))
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
    write(io, _adjust_web_svg(svg.svg))
    write(io, "</span></p>")
end
