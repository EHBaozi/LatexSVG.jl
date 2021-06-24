const _DEFAULT_ENGINE_KEY = "texengine"
const _DEFAULT_PREAMBLE_KEY = "preamble"

function _set_default_texengine(::T) where T <: LaTeXEngine
    @set_preferences!(_DEFAULT_ENGINE_KEY => string(nameof(T)))
    @info "The default LaTeX engine is set to $(T()). This will take effect after you restart your Julia session."
    return nothing
end

function _set_default_preamble(pre::Vector{AbstractString})
    @set_preferences!(_DEFAULT_PREAMBLE_KEY => String.(pre))
    info = "The default preamble is set to:\n\n  " * join((pre), "\n  ") * "\n\nThis will take effect after you restart your Julia session."
    @info info
    return nothing
end
_set_default_preamble(pre::AbstractString) = _set_default_preamble(split(strip(pre), "\n"))

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

function config!(;
    texengine::Union{Nothing, T, Type{T}}=nothing,
    preamble::Union{Nothing, AbstractString, Vector{AbstractString}}=nothing
) where T <: LaTeXEngine
    if texengine !== nothing
        _set_default_texengine(T())
    end
    if preamble !== nothing
        _set_default_preamble(preamble)
    end
    return nothing
end
