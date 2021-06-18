abstract type LaTeXEngine end

"The `pdflatex` engine."
struct PDFLaTeX <: LaTeXEngine end

"The `xelatex` engine."
struct XeLaTeX <: LaTeXEngine end

Base.show(io::IO, ::T) where T <: LaTeXEngine = print(io, nameof(T), " engine")

const _DEFAULT_ENGINE = Ref{LaTeXEngine}()

"""
    texengine()

Returns the current latex engine.
"""
texengine() = _DEFAULT_ENGINE[]

"""
    texengine!(eng::LaTeXEngine)

Sets the latex engine. `eng` can be `pdflatex` or `xelatex`. Currently `lualatex` is not supported.
"""
texengine!(eng::LaTeXEngine) = _DEFAULT_ENGINE[] = eng

"""
    texcommand(<:LaTeXEngine, input_file::AbstractString, output_path::AbstractString)

Returns a `Cmd` object which, when run, turns `input_file` into a dvi document of the same file name in `output_path`. The first argument needs to be an instance of the subtype `LaTeXEngine` and determines the associated command.

This package supplies two [`LaTeXEngine`](@ref)s: [`PDFLaTeX`](@ref) and [`XeLaTeX`](@ref). To define your own LaTeX engine, do the following:

1. Define a singleton subtype of `LaTeXEngine`, e.g.
   ```julia
   struct MyLaTeXEngine <: LaTeXEngine
   ```
   Note that `MyLaTeXEngine` has no fields.

2. Overload the [`texcommand`](@ref) function with the method
   ```julia
   function texcommand(::MyLaTeXEngine, input_file::AbstractString, output_path::AbstractString)
       # Returns a `Cmd` that turns `input_file` into a dvi document of the same file name in `output_path`.
   end
   ```
"""
function texcommand(engine <: LaTeXEngine, ::AbstractString, ::AbstractString)
    error("You need to overload the `texcommand` function with your custom-defined `$(nameof(engine))` engine. See the documentation of `texcommand` for details.")
end

function texcommand(::PDFLaTeX, input_file::AbstractString, output_path::AbstractString)
    return `pdflatex -output-format=dvi -output-directory="$output_path" -quiet -halt-on-error "$input_file"`
end

function texcommand(::XeLaTeX, input_file::AbstractString, output_path::AbstractString)
    return `xelatex -no-pdf -output-directory="$output_path" -quiet -halt-on-error "$input_file"`
end

"""
    dvisuffix(::LaTeXEngine)

Returns the file extension of the dvi output of the [`LaTeXEngine`](@ref). This is `"dvi"` for [`PDFLaTeX`](@ref) and `"xdv"` for [`XeLaTeX`](@ref). If you are using a custom-defined `LaTeXEngine`, we assume that it is `dvi`; alternatively you can define a method
```julia
dvisuffix(::MyLaTeXEngine) = "wackydviextension"
```
Make sure that the methods returns a plain `String`.
"""
function dvisuffix(engine <: LaTeXEngine)
    @warn "Assuming that the dvi output has file extension \".dvi\". If this is not the case, overload the `dvisuffix` function with your custom-defined `$(nameof(engine))`. See documentation for `dvisuffix` for details."
    return "dvi"
end

dvisuffix(::PDFLaTeX) = "dvi"
dvisuffix(::XeLaTeX) = "xdv"

function _tex2dvi(input_file::AbstractString, engine::LaTeXEngine=texengine())
    output_path = joinpath(splitpath(input_file)[begin:end - 1]...)
    run(texcommand(engine, input_file, output_path))
end
