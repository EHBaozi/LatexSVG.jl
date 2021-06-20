push!(LOAD_PATH, joinpath(@__DIR__, "..", ".."))

using Documenter
using LatexSVG

makedocs(
    modules = [LatexSVG],
    sitename = "LatexSVG.jl",
    format = Documenter.HTML(prettyurls = false),
    doctest = false,
    pages = Any[
        "Introduction" => "index.md",
        "Guide" => [
            "man/installation.md",
            "man/usage.md",
            "man/custom_engine.md"
        ],
        "Reference" => Any[
            "lib/api.md",
            "lib/interface.md"
        ]
    ]
)
