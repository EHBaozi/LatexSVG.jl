# Preamble

const _USE_DEFAULT_PREAMBLE = Ref(true)
const _DEFAULT_PREAMBLE = Ref{Vector{String}}()
_CUSTOM_PREAMBLE = String[]

"""
    preamble()

Returns the current preamble of the LaTeX document.
"""
function preamble()
    pre = String[]
    if _USE_DEFAULT_PREAMBLE[]
        append!(pre, _DEFAULT_PREAMBLE[])
    end
    append!(pre, _CUSTOM_PREAMBLE)
    return pre
end

"""
    reset_preamble!()

Resets the preamble to the default.
"""
function reset_preamble!()
    _USE_DEFAULT_PREAMBLE[] = true
    empty!(_CUSTOM_PREAMBLE)
    return preamble()
end

"""
    add_preamble!(pre::AbstractString...; reset=false)

Adds preamble statements to the LaTeX document. `pre` is any number of `AbstractString`s, each as a separate argument. You can pass a single multi-line string, or any number of single-line strings.

Returns the complete preamble.

By default this adds to the current preamble. To reset the preamble to the default before adding, set `reset=true`.
"""
function add_preamble!(pre::AbstractString...; ignore_default::Bool=false, reset::Bool=false)
    reset && reset_preamble!()
    _USE_DEFAULT_PREAMBLE[] = !ignore_default
    append!(_CUSTOM_PREAMBLE, String.(pre))
    return preamble()
end


# Document

function _assemble_document(latex_content::AbstractString; standalone::Bool=false)
    if standalone
        return String(latex_content)
    else
        doc = String[
            "\\documentclass[12pt]{article}",
            preamble()...,
            "\\begin{document}",
            String(latex_content),
            "\\end{document}"
        ]
        return join(doc, '\n')
    end
end
