function _dvi2svg(dvi_path::AbstractString)
    output = IOBuffer()
    # scale by 1.2 so that it looks better on the web
    run(pipeline(`dvisvgm --page=1 "$dvi_path" --bbox=min -e --precision=6 --scale=1.2 --no-fonts=1 -O --verbosity=0 -s`, stdout=output))
    return String(take!(output))
end

"""
    latexsvg(latex::AbstractString, engine=texengine(); standalone=false, extra_args=[])

Renders `latex` as an SVG string. `latex` is the LaTeX code that you want to render, `engine` is the LaTeX engine to use. By default `engine` is set to [`XeLaTeX`](@ref). You can change the default engine for this session with [`texengine!`](@ref), or permanently with [`config!`](@ref).

The output can be configured with a few keyword arguments:
- If `standalone=true`, it is assumed that `latex` is a complete document, thus the preamble will be ignored. Otherwise (and this is the default) `latex` will be inserted into a LaTeX document, whose preamble can be configured with [`add_preamble!`](@ref) and reset with [`reset_preamble!`](@ref). You can get the current complete preamble with [`preamble`](@ref).
- `extra_args` allows you to pass additional commandline flags/arguments to the LaTeX engine. For instance, if your LaTeX code contains `minted` code blocks, you would need to set `extra_args=["-shell-escape"]`.
"""
function latexsvg(latex::AbstractString, engine::LaTeXEngine=texengine(); standalone::Bool=false, extra_args::Vector{String}=String[])
    temp_dir = mktempdir()

    filename = tempname(temp_dir; cleanup=false)
    texfile = filename * ".tex"
    dvifile = filename * "." * dviext(engine)

    latex_document = _assemble_document(latex; standalone=standalone)

    open(texfile, "w") do io
        write(io, latex_document)
    end

    _tex2dvi(texfile, engine; extra_args=extra_args)

    result = _dvi2svg(dvifile)
    return LaTeXSVG(String(latex), result; standalone=standalone)
end

latexsvg(latex::AbstractString, engine::Type{T}; kwargs...) where T <: LaTeXEngine = latexsvg(latex, T(); kwargs...)

"""
    savesvg(filepath::AbstractString, svg::LaTeXSVG)

Saves `svg` to `filepath`.
"""
function savesvg(filepath::AbstractString, svg::LaTeXSVG)
    open(filepath, "w") do io
        write(io, svg.svg)
    end
    return nothing
end
