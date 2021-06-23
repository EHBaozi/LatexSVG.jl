module LatexSVG

@doc read(joinpath(@__DIR__, "..", "README.md"), String) LatexSVG

using LightXML, FixedPointDecimals
using Preferences

export
    default_preamble, default_preamble!, current_preamble, reset_preamble!, add_preamble!, set_preamble!,
    PDFLaTeX, XeLaTeX, texengine, texengine!, default_texengine, default_texengine!,
    LaTeXSVG, latexsvg, printsvg, savesvg,
    @Lsvg_str


include("latexdocument/latexdocument.jl")
include("latexdocument/configurations.jl")

include("latexengines/interface.jl")
include("latexengines/configurations.jl")
include("latexengines/pdflatex.jl")
include("latexengines/xelatex.jl")

include("svgprocessing.jl")
include("svgtype.jl")
include("svgrender.jl")
include("svgmacros.jl")

include("initialize.jl")

function __init__()
    _initialize_latex()
    return nothing
end

end # module
