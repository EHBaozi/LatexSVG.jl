"""
    latexsvg(latex::AbstractString, engine::LaTeXEngine=texengine(); standalone=false)

Renders `latex` as an svg string. `latex` is the LaTeX code that you want to render, `engine` is the LaTeX engine to use (this defaults to `xelatex` and can be set with [`texengine!`](@ref).) If `standalone=true`, the preamble will be ignored and `latex` will be treated as a complete document; otherwise `latex` will be inserted into a latex document, whose preamble can be configured with [`add_preamble!`](@ref) or [`set_preamble!`](@ref) and reset with [`reset_preamble!`](@ref). You can get default preamble with [`default_preamble`](@ref) and the current complete preamble with [`preamble`](@ref).

If you are in an svg-capable display environment, e.g. IJulia or VS Code, the svg output is automatically rendered and displayed; otherwise, it returns a [`LaTeXSVG`](@ref) object that contains the LaTeX code, preamble, and the rendered svg string.
"""
function latexsvg(latex::AbstractString, engine::LaTeXEngine=texengine(); standalone=false)
    temp_dir = mktempdir()

    filename = tempname(temp_dir; cleanup=false)
    texfile = filename * ".tex"
    dvifile = if engine == xelatex
        filename * ".xdv"
    elseif engine == pdflatex
    filename * ".dvi"
    end

    latex_document = _assemble_document(latex; standalone=standalone)

    open(texfile, "w") do io
        write(io, latex_document)
    end

    _to_dvi(texfile, engine)
  
    result = _to_svg(dvifile)
    return LaTeXSVG(String(latex), result)
end

"""
    savesvg(file::AbstractString, svg::LaTeXSVG)

Saves `svg` into `file`.
"""
function savesvg(file::AbstractString, svg::LaTeXSVG)
    open(file, "w") do io
        write(io, svg.svg)
    end
end