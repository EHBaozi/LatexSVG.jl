"""
    LaTeXEngine

Subtypes of this type represent LaTeX engines and should be singletons.
"""
abstract type LaTeXEngine end

"The `pdflatex` engine."
struct PDFLaTeX <: LaTeXEngine end

"The `xelatex` engine."
struct XeLaTeX <: LaTeXEngine end

Base.show(io::IO, ::T) where T <: LaTeXEngine = print(io, nameof(T), " engine")

const _DEFAULT_ENGINE = Ref{LaTeXEngine}()

"""
    texengine()

Returns the current LaTeX engine.
"""
texengine() = _DEFAULT_ENGINE[]

"""
    texengine!(eng::LaTeXEngine)
    texengine!(eng::Type{<:LaTeXEngine})

Sets the LaTeX engine. `eng` can be [`PDFLaTeX`](@ref), [`XeLaTeX`](@ref), or a custom singleton subtype of [`LaTeXEngine`](@ref).

The following invocations are both valid:
```julia
texengine!(PDFLaTeX())
```
and
```julia
texengine!(PDFLaTeX)
```
"""
texengine!(eng::LaTeXEngine) = _DEFAULT_ENGINE[] = eng
texengine!(::Type{T}) where T <: LaTeXEngine = texengine!(T())

"""
    texcommand(<:LaTeXEngine, input_file::AbstractString, output_path::AbstractString; extra_args=String[]) where N

Returns a `Cmd` object which, when run, turns `input_file` into a dvi document of the same file name in `output_path`. The first argument needs to be an instance of a subtype of `LaTeXEngine` and determines the associated LaTeX command to run. The keyword argument `extra_args` is a `Vector` of `String`s that contains additional arguments/flags to pass to the LaTeX engine, and defaults to being empty. Make sure that strings in `extra_args` contain no spaces, or are otherwise valid shell arguments.

As an example, `texcommand` for [`PDFLaTeX`](@ref) returns the following command:
```julia
`pdflatex \$extra_args -output-format=dvi -output-directory="\$output_path" -quiet -halt-on-error "\$input_file"`
```
thus, a call `texcommand(PDFLaTeX(), "/path/to/input.tex", "/path/to/output/"; extra_args=["-shell-escape"])` will run the command
```julia
`pdflatex -shell-escape -output-format=dvi -output-directory=/path/to/output/ -quiet -halt-on-error /path/to/input.tex`
```
which creates a file `/path/to/output/input.dvi`.

This package supplies two [`LaTeXEngine`](@ref)s: `PDFLaTeX` and [`XeLaTeX`](@ref). To define your own LaTeX engine, do the following:

First, define a singleton subtype of `LaTeXEngine`, e.g.
```julia
struct MyLaTeXEngine <: LaTeXEngine end
```
Note that `MyLaTeXEngine` has no fields.

Second, overload the [`texcommand`](@ref) function with the method
```julia
function texcommand(::MyLaTeXEngine, input_file::AbstractString, output_path::AbstractString; extra_args=String[])
    # Returns a `Cmd` that turns `input_file` into a dvi document of the same file name in `output_path`.
end
```
"""
function texcommand(engine::LaTeXEngine, input_file::AbstractString, output_path::AbstractString; extra_args::Vector{String}=String[])
    error("You need to overload the `texcommand` function with your custom-defined `$(nameof(typeof(engine)))` LaTeX engine. See the documentation of `texcommand` for details.")
end

function texcommand(::PDFLaTeX, input_file::AbstractString, output_path::AbstractString; extra_args::Vector{String}=String[])
    return `pdflatex $extra_args -output-format=dvi -output-directory="$output_path" -quiet -halt-on-error "$input_file"`
end

function texcommand(::XeLaTeX, input_file::AbstractString, output_path::AbstractString; extra_args::Vector{String}=String[])
    return `xelatex $extra_args -no-pdf -output-directory="$output_path" -quiet -halt-on-error "$input_file"`
end

"""
    dvisuffix(::LaTeXEngine)

Returns the file extension of the dvi output of the [`LaTeXEngine`](@ref). This is `"dvi"` for [`PDFLaTeX`](@ref) and `"xdv"` for [`XeLaTeX`](@ref). If you are using a custom-defined `LaTeXEngine`, we assume that it is `dvi`; alternatively you can define a method
```julia
dvisuffix(::MyLaTeXEngine) = "wackydviextension"
```
Make sure that the methods returns a plain `String`.
"""
function dvisuffix(engine::LaTeXEngine)
    @warn "Assuming that the dvi output has file extension \"dvi\". If this is not the case, overload the `dvisuffix` function with your custom-defined `$(nameof(typeof(engine)))`. See documentation for `dvisuffix` for details."
    return "dvi"
end

dvisuffix(::PDFLaTeX) = "dvi"
dvisuffix(::XeLaTeX) = "xdv"

function _tex2dvi(input_file::AbstractString, engine::LaTeXEngine=texengine(); extra_args::Vector{String}=String[])
    output_path = joinpath(splitpath(input_file)[begin:end - 1]...)
    run(texcommand(engine, input_file, output_path; extra_args=extra_args))
end
