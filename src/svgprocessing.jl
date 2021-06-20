function _to_fixed_decimal(num_str::AbstractString)
    num = parse(Float64, String(num_str))
    return FixedDecimal{Int,6}(num)  # every number in the dvisvgm svg output has 6 decimal places
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

# So apparently the boundary of the svg image that dvisvgm calculates
# is a bit too tight and can cut into the glyphs; this adds 1pt in
# both directions to resolve this
function _adjust_svg(svg_str::String)
    svgobject = parse_string(svg_str)
    svgroot = root(svgobject)

    width = attribute(svgroot, "width")
    height = attribute(svgroot, "height")
    set_attribute(svgroot, "width", _adjust_dim(width))
    set_attribute(svgroot, "height", _adjust_dim(height))

    viewbox = attribute(svgroot, "viewBox")
    set_attribute(svgroot, "viewBox", _adjust_viewbox(viewbox))

    return string(svgobject)
end
