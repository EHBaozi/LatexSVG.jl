function _to_fixed_decimal(num_str::AbstractString)
    num = parse(Float64, String(num_str))
    return FixedDecimal{Int,6}(num)
end

function _adjust_dim(num_str::AbstractString)
    num = _to_fixed_decimal(num_str[begin:end - 2])
    return string(num + 1) * "pt"
end

function _adjust_viewbox(viewbox_str::AbstractString)
    x, y, width, height = split(viewbox_str, " ")
    x = string(_to_fixed_decimal(x) - 0.5)
    y = string(_to_fixed_decimal(y) - 0.5)
    width = string(_to_fixed_decimal(width) + 1)
    height = string(_to_fixed_decimal(height) + 1)

    return join([x, y, width, height], " ")
end

function _adjust_web_svg(svg_str::String)
    svgobject = parse_string(svg_str)
    svgroot = root(svgobject)

    # add 1pt to both dimensions
    width = attribute(svgroot, "width")
    set_attribute(svgroot, "width", _adjust_dim(width))
    set_attribute(svgroot, "height", "auto")

    viewbox = attribute(svgroot, "viewBox")
    set_attribute(svgroot, "viewBox", _adjust_viewbox(viewbox))

    # centers the svg in an HTML environment
    set_attribute(svgroot, "style", "display: block; margin: auto")
    set_attribute(svgroot, "class", "latexsvg-displaystyle-svg")

    return string(svgobject)
end
