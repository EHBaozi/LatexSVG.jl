const _DEFAULT_ENGINE_KEY = "latexengine"

"""
    default_texengine()

Returns the default LaTeX engine. By default this is unset. You can set a default with [`default_texengine!`](@ref) and your choice will be stored in a `LocalPreferences.toml` file for your currently active project and thus will persist for all future Julia sessions.

To change the LaTeX engine for the current session only, use [`texengine!`](@ref).
"""
function default_texengine()
    if @has_preference(_DEFAULT_ENGINE_KEY)
        preferred_engine_str = @load_preference(_DEFAULT_ENGINE_KEY)
        if preferred_engine_str == "PDFLaTeX"
            return PDFLaTeX()
        elseif preferred_engine_str == "XeLaTeX"
            return XeLaTeX()
        else
            @warn "Unknown LaTeX engine $preferred_engine_str; please set a valid default LaTeX engine with `default_texengine!`."
            return nothing
        end
    else
        @info "You are using $(texengine()) for this session. To set it as the default for all future sessions, use the `default_texengine!` function."
        return nothing
    end
end

"""
    default_texengine!(eng)

Sets the default LaTeX engine for all future Julia sessions. `eng` can be [`PDFLaTeX`](@ref) or [`XeLaTeX`](@ref).
"""
function default_texengine!(::T) where T <: LaTeXEngine
    @set_preferences!(_DEFAULT_ENGINE_KEY => string(nameof(T)))
    @info "The default LaTeX engine is set to $(T()). This will take effect after you restart your Julia session."
    return nothing
end

default_texengine!(::Type{T}) where T <: LaTeXEngine = default_texengine!(T())

"""
    texengine()

Returns the current LaTeX engine.
"""
texengine() = _CURRENT_ENGINE[]

"""
    texengine!(eng)

Sets the LaTeX engine for this session. `eng` can be [`PDFLaTeX`](@ref) or [`XeLaTeX`](@ref), e.g.
```julia
texengine!(PDFLaTeX)
```
"""
function texengine!(eng::LaTeXEngine)
    _CURRENT_ENGINE[] = eng
    return nothing
end

texengine!(::Type{T}) where T <: LaTeXEngine = texengine!(T())
