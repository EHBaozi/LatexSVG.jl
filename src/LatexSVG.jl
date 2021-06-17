module LatexSVG

@doc read(joinpath(@__DIR__, "..", "README.md"), String) LatexSVG

export pdflatex, xelatex, texengine, texengine!,
    default_preamble, current_preamble, reset_preamble!, add_preamble!, set_preamble!,
    LaTeXSVG, latexsvg, savesvg

include("initialize.jl")
include("latexdocument.jl")
include("latexengine.jl")
include("svgtype.jl")
include("svgrender.jl")

function __init__()
    _check_latex()
    return nothing
end

end # module
