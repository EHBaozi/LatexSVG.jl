"""
    LaTeXEngine

Subtypes of this type represent LaTeX engines and should be singletons.
"""
abstract type LaTeXEngine end

Base.show(io::IO, ::T) where T <: LaTeXEngine = print(io, nameof(T), " engine")

const _CURRENT_ENGINE = Ref{LaTeXEngine}()

"""
    texengine()

Returns the current LaTeX engine.
"""
texengine() = _CURRENT_ENGINE[]

"""
    texengine!(eng)

Sets the LaTeX engine for this session. `eng` can be [`PDFLaTeX`](@ref), [`XeLaTeX`](@ref), or [`LuaLaTeX`](@ref), e.g.
```julia
texengine!(PDFLaTeX)
```
"""
function texengine!(eng::LaTeXEngine)
    _CURRENT_ENGINE[] = eng
    return nothing
end

texengine!(::Type{T}) where T <: LaTeXEngine = texengine!(T())


"""
    runlatex(<:LaTeXEngine, input_file::AbstractString, output_path::AbstractString; extra_args=String[])

Compiles `input_file` into a dvi document of the same file name in `output_path`. The first argument needs to be an instance of a subtype of `LaTeXEngine` and determines the associated LaTeX command to run. The keyword argument `extra_args` is a `Vector` of `String`s that contains additional arguments/flags to pass to the LaTeX engine, and defaults to being empty. Make sure that strings in `extra_args` contain no spaces, or are otherwise valid shell arguments.
"""
function runlatex(
    engine::LaTeXEngine,
    input_file::AbstractString,
    output_path::AbstractString;
    extra_args::Vector{String}=String[],
)
    error("You need to overload the `runlatex` function for `$(nameof(typeof(engine)))`.")
end

"""
    dviext(::LaTeXEngine)

Returns the file extension of the dvi output of the [`LaTeXEngine`](@ref).
"""
function dviext(engine::LaTeXEngine)
    error("You need to overload the `dviext` function for `$(nameof(typeof(engine)))`.")
end

function _tex2dvi(filename::AbstractString, engine::LaTeXEngine; extra_args::Vector{String}=String[])
    output_path = joinpath(splitpath(filename)[begin:end - 1]...)
    runlatex(engine, filename * ".tex", output_path; extra_args=extra_args)
    return filename * "." * dviext(engine)
end
