using Documenter
using LatexSVG

makedocs(
    modules = [LatexSVG],
    sitename = "LatexSVG.jl",
    format = Documenter.HTML(
        assets = ["assets/svgtheme.css"]
    ),
    doctest = false,
    pages = Any[
        "Introduction" => "index.md",
        "Guide" => [
            "man/installation.md",
            "man/usage.md",
            "man/htmldisplay.md"
        ]
    ]
)

deploydocs(
    repo = "github.com/EHBaozi/LatexSVG.jl.git"
)
