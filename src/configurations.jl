const _DEFAULT_ENGINE_KEY = "texengine"
const _DEFAULT_PREAMBLE_KEY = "preamble"

function _set_default_texengine(::T) where T <: LaTeXEngine
    @set_preferences!(_DEFAULT_ENGINE_KEY => string(nameof(T)))
    @info "The default LaTeX engine is set to $(string(nameof(T))). This will take effect after you restart your Julia session."
    return nothing
end

function _set_default_preamble(pre::Vector{<:AbstractString})
    @set_preferences!(_DEFAULT_PREAMBLE_KEY => String.(pre))
    info = "The default preamble is set to:\n\n  " * join((pre), "\n  ") * "\n\nThis will take effect after you restart your Julia session."
    @info info
    return nothing
end
_set_default_preamble(pre::AbstractString) = _set_default_preamble(split(strip(pre), "\n"))

"""
    config(key::String)

Obtain the persistent settings for the LaTeX engine and the preamble. `key` can be "texengine" or "preamble". Use [`config!`](@ref) to configure these settings.
"""
function config(key::String; info=true)
    if @has_preference(key)
        return @load_preference(key)
    else
        if info
            @info "Preference \"$(key)\" is unset."
        end
        return nothing
    end
end

"""
    config!(; texengine=nothing, preamble=nothing)

Configure persistent settings for the LaTeX engine and the preamble:
- `texengine` can be [`XeLaTeX`](@ref) or [`PDFLaTeX`](@ref)
- `preamble` can be an `AbstractString` or a `Vector` of `AbstractString`s.

Two examples:
```julia-repl
julia> config!(texengine=PDFLaTeX)
# This sets the default LaTeX engine to be `PDFLaTeX` for all future sessions.

julia> config!(preamble=["\\usepackage{physics}", "\\usepackage{siunitx}"])
# This sets the default preamble to be
# \\usepackage{physics}
# \\usepackage{siunitx}
# for all future sessions.
```
You can also call `config!()` without any keyword argument. In this case your current LaTeX engine and preamble will be configured as the default.

These preferences are stored in a `LocalPreferences.toml` file in your active project, therefore if you have multiple projects using this package you need to set the preference for them individually.

If no settings are detected, this package defaults to using `XeLaTeX` and sets the preamble to be
```latex
\\usepackage{amsmath,amsthm,amssymb}
\\usepackage{color}
```
"""
function config!(;
    texengine::Union{Nothing, T, Type{T}}=nothing,
    preamble::Union{Nothing, <:AbstractString, Vector{<:AbstractString}}=nothing
) where T <: LaTeXEngine
    if texengine !== nothing
        _set_default_texengine(T())
    end
    if preamble !== nothing
        _set_default_preamble(preamble)
    end
    if texengine === nothing && preamble === nothing
        _set_default_texengine(LatexSVG.texengine())
        _set_default_preamble(LatexSVG.preamble())
    end
    return nothing
end
