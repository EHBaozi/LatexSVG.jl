push!(LOAD_PATH, joinpath(@__DIR__, ".."))

using Documenter
using LatexSVG

makedocs(
    modules = [LatexSVG],
    sitename = "LatexSVG.jl",
    format = Documenter.HTML(
        prettyurls = false,
        assets = ["assets/svgtheme.css"]
    ),
    doctest = false,
    pages = Any[
        "Introduction" => "index.md",
        "Guide" => [
            "man/installation.md",
            "man/usage.md",
            "man/third-party.md",
            "man/htmldisplay.md"
        ]
    ]
)
