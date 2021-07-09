function _dvi2svg(dvi_path::AbstractString)
    output = IOBuffer()
    # scale by 1.2 so that it looks better on the web
    run(pipeline(`dvisvgm --page=1 "$dvi_path" --bbox=min -e --precision=6 --no-fonts=1 -O --verbosity=0 -s`, stdout=output))
    return String(take!(output))
end

"""
    latexsvg(latex::AbstractString, engine=texengine(); standalone=false, extra_args=[])

Renders `latex` as an SVG string. `latex` is the LaTeX code that you want to render, `engine` is the LaTeX engine to use and defaults to the one currently in use for this session. You can change the engine for this session with [`texengine!`](@ref), or set the default permanently with [`config!`](@ref).

The output can be configured with a few keyword arguments:
- If `standalone=true`, it is assumed that `latex` is a complete document, thus the preamble will be ignored. Otherwise (and this is the default) `latex` will be inserted into a LaTeX document, whose preamble can be configured with [`add_preamble!`](@ref) and reset with [`reset_preamble!`](@ref). You can get the current complete preamble with [`preamble`](@ref).
- `extra_args` allows you to pass additional commandline flags/arguments to the LaTeX engine. For instance, if your LaTeX code contains `minted` code blocks (for some reason), you would need to set `extra_args=["--shell-escape"]`.
"""
function latexsvg(latex::AbstractString, engine::LaTeXEngine=texengine(); standalone::Bool=false, extra_args::Vector{String}=String[])
    temp_dir = mktempdir()
    filename = tempname(temp_dir; cleanup=false)

    latex_document = _assemble_document(latex; standalone=standalone)
    write(filename * ".tex", latex_document)

    dvifile = _tex2dvi(filename, engine; extra_args=extra_args)
    result = _dvi2svg(dvifile)

    return LaTeXSVG(String(latex), result; standalone=standalone)
end

latexsvg(latex::AbstractString, engine::Type{T}; kwargs...) where T <: LaTeXEngine = latexsvg(latex, T(); kwargs...)

"""
    savesvg(filepath::AbstractString, svg::LaTeXSVG; web_display=false, web_inline=false)

Saves `svg` to `filepath`.

If `web_display=true`, some adjustments are made to the SVG before it is saved:
- The height of the SVG is scaled by a factor of 1.2 and its unit changed to `rem`, and the width attribute is deleted.
- A style attribute `style="display: block; margin: auto; max-width: 80%"` is added.
- A `class="latexsvg-display"` attribute is added to the `<svg>` tag.

If `web_inline=true`, the following adjustments are made:
- The height of the SVG is scaled by a factor of 1.2 and its unit changed to `rem`, and the width attribute is deleted.
- A style attribute `style="vertical-align: middle"` is added.
- A `class="latexsvg-inline"` attribute is added.

Refer to the documentation for details.

Note that `web_display` and `web_inline` cannot both be `true`. If they are both `false`, the vanilla SVG output is saved with no modification.
"""
function savesvg(filepath::AbstractString, svg::LaTeXSVG; web_display::Bool=false, web_inline::Bool=false)
    if web_display && web_inline
        throw(ArgumentError("Keyword arguments `web_display` and `web_inline` cannot both be true."))
    end
    if web_display
        write(filepath, _adjust_web_svg_display(svg.svg))
    elseif web_inline
        write(filepath, _adjust_web_svg_inline(svg.svg))
    else
        write(filepath, svg.svg)
    end
    return nothing
end
