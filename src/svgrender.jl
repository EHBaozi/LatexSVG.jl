function _dvi2svg(dvi_path::AbstractString)
    output = IOBuffer()
    # scale by 1.2 so that it looks better on the web
    run(pipeline(`dvisvgm --page=1 "$dvi_path" --bbox=min -e --precision=6 --scale=1.2 --no-fonts=1 -O --verbosity=0 -s`, stdout=output))
    return String(take!(output))
end

"""
    latexsvg(latex::AbstractString, engine=texengine(); standalone=false, extra_args=[])

Renders `latex` as an svg string. `latex` is the LaTeX code that you want to render, `engine` is the LaTeX engine to use. By default `engine` is set to [`PDFLaTeX`](@ref). You can change the default engine for this session with [`texengine!`](@ref), or permanently with [`default_texengine!`](@ref). 

The output can be configured with a few keyword arguments:
- If `standalone=true`, it is assumed that `latex` is a complete document, thus the preamble will be ignored. Otherwise (and this is the default) `latex` will be inserted into a LaTeX document, whose preamble can be configured with [`add_preamble!`](@ref) or [`set_preamble!`](@ref) and reset with [`reset_preamble!`](@ref). You can get the default preamble with [`default_preamble`](@ref) and the current complete preamble with [`current_preamble`](@ref).
- `extra_args` allows you to pass additional commandline flags/arguments to the LaTeX engine. For instance, if your LaTeX code contains `minted` code blocks, you would need to set `extra_args=["-shell-escape"]`.

This function returns a [`LaTeXSVG`](@ref) object that contains the LaTeX code, preamble, and the SVG string. If you are in an SVG- or HTML-capable display environment, e.g. IJulia, VS Code, or Pluto.jl, the svg output is automatically rendered and displayed; you can also access the plain SVG string or save it to a file directly:
```julia-repl
julia> output = latexsvg(latex_string_to_render);
julia> output.svg
# returns the svg string
julia> printsvg(output)
# prints the svg string
julia> savesvg("/path/to/file", output)
# saves output to a file
```
"""
function latexsvg(latex::AbstractString, engine::LaTeXEngine=texengine(); standalone::Bool=false, extra_args::Vector{String}=String[])
    temp_dir = mktempdir()

    filename = tempname(temp_dir; cleanup=false)
    texfile = filename * ".tex"
    dvifile = filename * "." * dvisuffix(engine)

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
    printsvg(svg::LaTeXSVG)

Prints the rendered svg string of a `LaTeXSVG` object as plain text.
"""
printsvg(svg::LaTeXSVG) = println(svg.svg)

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
