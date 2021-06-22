module LatexSVG

@doc read(joinpath(@__DIR__, "..", "README.md"), String) LatexSVG

using LightXML, FixedPointDecimals
using Preferences

export
    default_preamble, current_preamble, reset_preamble!, add_preamble!, set_preamble!,
    PDFLaTeX, XeLaTeX, texengine, texengine!, default_texengine, default_texengine!,
    LaTeXSVG, latexsvg, printsvg, savesvg,
    @Lsvg_str


include("latexdocument.jl")

include("latexengines/engineinterface.jl")
include("latexengines/xelatex.jl")
include("latexengines/pdflatex.jl")

include("svgprocessing.jl")
include("svgtype.jl")
include("svgrender.jl")
include("svgmacros.jl")

include("initialize.jl")

function __init__()
    _check_latex()
    return nothing
end

end # module
