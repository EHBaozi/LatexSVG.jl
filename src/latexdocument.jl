# Preamble

const _DEFAULT_PREAMBLE = Ref{Vector{String}}()
_CUSTOM_PREAMBLE = String[]

"""
    preamble()

Returns the current preamble of the LaTeX document.
"""
function preamble()
    pre = String[]
    append!(pre, _DEFAULT_PREAMBLE[])
    append!(pre, _CUSTOM_PREAMBLE)
    return pre
end

"""
    reset_preamble!()

Resets the preamble to the default.
"""
function reset_preamble!()
    empty!(_CUSTOM_PREAMBLE)
    return preamble()
end

"""
    add_preamble!(pre::AbstractString...; reset=false)

Adds preamble statements to the LaTeX document. `pre` is any number of `AbstractString`s.

By default this adds to the current preamble. To reset the preamble to the default before adding, set `reset=true`.
"""
function add_preamble!(pre::AbstractString...; reset::Bool=false)
    reset && reset_preamble!()
    append!(_CUSTOM_PREAMBLE, String.(pre))
    return preamble()
end


# Document

function _assemble_document(latex_content::AbstractString; standalone::Bool=false)
    if standalone
        return String(latex_content)
    else
        doc = """
        \\documentclass[12pt]{article}
        $(join(preamble(), "\n"))
        \\pagestyle{empty}
        \\begin{document}
        $(String(latex_content))
        \\end{document}
        """
        return doc
    end
end
