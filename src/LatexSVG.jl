module LatexSVG

@doc read(joinpath(@__DIR__, "..", "README.md"), String) LatexSVG

using FixedPointDecimals
using LightXML: parse_string, root, attribute, set_attribute
using Preferences

export
    preamble, reset_preamble!, add_preamble!,
    PDFLaTeX, XeLaTeX, LuaLaTeX, texengine, texengine!,
    LaTeXSVG, latexsvg, savesvg,
    @Lsvg_str,
    config, config!


include("latexdocument.jl")

include("latexengines/interface.jl")
include("latexengines/pdflatex.jl")
include("latexengines/xelatex.jl")
include("latexengines/lualatex.jl")

include("svgtype.jl")
include("svgrender.jl")
include("svghtmldisplay.jl")
include("svgmacros.jl")

include("configurations.jl")
include("initialize.jl")

function __init__()
    _initialize_latex()
    return nothing
end

end # module
