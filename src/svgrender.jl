function _dvi2svg(dvi_path::AbstractString)
    output = IOBuffer()
    # scale by 1.2 so that it looks better on the web
    run(pipeline(`dvisvgm -p 1 "$dvi_path" -b min -e -d 6 --scale=1.2 -n -v 0 -s`, stdout=output))
    return String(take!(output))
end

"""
    latexsvg(latex::AbstractString, engine::LaTeXEngine=texengine(); centering=true, standalone=false, extra_args=[])

Renders `latex` as an svg string. `latex` is the LaTeX code that you want to render, `engine` is the LaTeX engine to use, which defaults to [`XeLaTeX`](@ref) and can be set with [`texengine!`](@ref) or passed directly as the second argument. 

The output can be configured with a few keyword arguments:
- `centering=true` wraps your LaTeX code in a `{\\centering ... \\par}` block. This is useful since this package is primarily designed to output short blocks of LaTeX. Note that this does not affect the alignment of the output svg when it's embedded in e.g. a webpage and only affects the formatting within the LaTeX content itself.
- `standalone=true` assumes that `latex` is a complete document, thus the `centering` keyword and the preamble will be ignored. Otherwise (and this is the default) `latex` will be inserted into a LaTeX document, whose preamble can be configured with [`add_preamble!`](@ref) or [`set_preamble!`](@ref) and reset with [`reset_preamble!`](@ref). You can get the default preamble with [`default_preamble`](@ref) and the current complete preamble with [`current_preamble`](@ref).
- `extra_args` allows you to pass additional commandline flags/arguments to the LaTeX engine. For instance, if your LaTeX code contains `minted` code blocks, you would need to set `extra_args=["-shell-escape"]`.

This function returns a [`LaTeXSVG`](@ref) object that contains the LaTeX code, preamble, and the svg string. If you are in an svg-capable display environment, e.g. IJulia or VS Code, the svg output is automatically rendered and displayed; you can also access the plain svg string or save it to a file directly:
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
function latexsvg(latex::AbstractString, engine::LaTeXEngine=texengine(); centering::Bool=true, standalone::Bool=false, extra_args::Vector{String}=String[])
    temp_dir = mktempdir()

    filename = tempname(temp_dir; cleanup=false)
    texfile = filename * ".tex"
    dvifile = filename * "." * dvisuffix(engine)

    latex_document = _assemble_document(latex; centering=centering, standalone=standalone)

    open(texfile, "w") do io
        write(io, latex_document)
    end

    _tex2dvi(texfile, engine; extra_args=extra_args)

    result = _dvi2svg(dvifile)
    return LaTeXSVG(String(latex), result)
end

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
