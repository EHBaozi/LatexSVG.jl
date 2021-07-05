const _DEFAULT_ENGINE_KEY = "texengine"
const _DEFAULT_PREAMBLE_KEY = "preamble"

function _set_default_texengine(::T; export_prefs::Bool=false) where T <: LaTeXEngine
    set_preferences!(LatexSVG, _DEFAULT_ENGINE_KEY => string(nameof(T)); export_prefs=export_prefs)
    @info "The default LaTeX engine is set to $(string(nameof(T))). This will take effect after you restart your Julia session."
    return nothing
end

function _set_default_preamble(pre::Vector{<:AbstractString}; export_prefs::Bool=false)
    set_preferences!(LatexSVG, _DEFAULT_PREAMBLE_KEY => String.(pre); export_prefs=export_prefs)
    info = "The default preamble is set to:\n\n  " * join((pre), "\n  ") * "\n\nThis will take effect after you restart your Julia session."
    @info info
    return nothing
end
_set_default_preamble(pre::AbstractString; export_prefs::Bool=false) = _set_default_preamble(split(strip(pre), "\n"); export_prefs=export_prefs)

"""
    config(key::String)

Obtain the persistent settings for the LaTeX engine and the preamble. `key` can be `"texengine"` or `"preamble"`. Use [`config!`](@ref) to configure these settings.
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
    config!(; texengine=nothing, preamble=nothing, export_prefs=false)

Configure persistent settings for the LaTeX engine and the preamble:
- `texengine` can be [`XeLaTeX`](@ref), [`PDFLaTeX`](@ref), or [`LuaLaTeX`](@ref)
- `preamble` can be an `AbstractString` or a `Vector` of `AbstractString`s.

Two examples:
```julia-repl
julia> config!(texengine=PDFLaTeX)
```
This sets the default LaTeX engine to be `PDFLaTeX` *for all future sessions*.

```julia-repl
julia> config!(preamble=["\\usepackage{mathtools}", "\\usepackage{xcolor}"])
```
This sets the default preamble to be
```latex
\\usepackage{mathtools}
\\usepackage{xcolor}
```
*for all future sessions*, replacing the original default of
```latex
\\usepackage{amsmath,amsthm,amssymb}
\\usepackage{color}
```

You can also call `config!()` without any keyword argument. In this case your current LaTeX engine and preamble will be stored as the default.

These preferences are stored in a `LocalPreferences.toml` file in your active project. If `export_prefs=true`, they will instead be written into your `Project.toml`. Either way, if you have multiple projects using this package you need to set the preference for them individually.
"""
function config!(;
    texengine::Union{Nothing, T, Type{T}}=nothing,
    preamble::Union{Nothing, <:AbstractString, Vector{<:AbstractString}}=nothing,
    export_prefs::Bool=false
) where T <: LaTeXEngine
    if texengine !== nothing
        _set_default_texengine(T(); export_prefs=export_prefs)
    end
    if preamble !== nothing
        _set_default_preamble(preamble; export_prefs=export_prefs)
    end
    if texengine === nothing && preamble === nothing
        _set_default_texengine(LatexSVG.texengine(); export_prefs=export_prefs)
        _set_default_preamble(LatexSVG.preamble(); export_prefs=export_prefs)
    end
    return nothing
end
