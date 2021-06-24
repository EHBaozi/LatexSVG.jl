module LatexSVG

@doc read(joinpath(@__DIR__, "..", "README.md"), String) LatexSVG

using LightXML, FixedPointDecimals
using Preferences

export
    preamble, reset_preamble!, add_preamble!,
    PDFLaTeX, XeLaTeX, texengine, texengine!,
    LaTeXSVG, latexsvg, printsvg, savesvg,
    @Lsvg_str,
    config, config!


include("latexdocument.jl")

include("latexengines/interface.jl")
include("latexengines/pdflatex.jl")
include("latexengines/xelatex.jl")

include("svgprocessing.jl")
include("svgtype.jl")
include("svgrender.jl")
include("svgmacros.jl")

include("configurations.jl")
include("initialize.jl")

function __init__()
    _initialize_latex()
    return nothing
end

end # module
