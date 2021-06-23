const _DEFAULT_PREAMBLE_KEY = "preamble"

function default_preamble!(pre::Vector{String})
    @set_preferences!(_DEFAULT_PREAMBLE_KEY => pre)
    info = "The default preamble is set to:\n" * join(pre, "\n") * "\nThis will take effect after you restart your Julia session."
    @info info
    return nothing
end

default_preamble!(pre::AbstractString...) = default_preamble!(collect(String.(pre)))
default_preamble!(pre::AbstractString) = default_preamble!(String.(split(pre, "\n")))
