# Preamble

const _USE_DEFAULT_PREAMBLE = Ref(true)

const _DEFAULT_PREAMBLE = String[
    raw"\usepackage{amsmath,amsthm,amssymb}",
    raw"\usepackage{color}",
    raw"\pagestyle{empty}"
]

_CUSTOM_PREAMBLE = String[]

"""
    current_preamble()

Returns the current preamble of the latex document.
"""
function current_preamble()
    pre = String[]
    if _USE_DEFAULT_PREAMBLE[]
        append!(pre, _DEFAULT_PREAMBLE)
    end
    append!(pre, _CUSTOM_PREAMBLE)
    return pre
end

"""
    default_preamble()

Returns the default preamble of the latex document.
"""
function default_preamble()
    return _DEFAULT_PREAMBLE
end

"""
    reset_preamble!()

Resets the preamble to the default.
"""
function reset_preamble!()
    _USE_DEFAULT_PREAMBLE[] = true
    empty!(_CUSTOM_PREAMBLE)
    return current_preamble()
end

"""
    add_preamble!(pre::AbstractString...; reset=false)

Adds preamble statements to the latex document. `pre` is any number of `AbstractString`s, each as a separate argument. You can pass a single multi-line string, or any number of single-line strings.

Returns the complete preamble.

By default this adds to the current preamble. To reset the preamble to the default before adding, set `reset=true`.
"""
function add_preamble!(pre::AbstractString...; reset::Bool=false)
    if reset
        reset_preamble!()
    end
    append!(_CUSTOM_PREAMBLE, String.(pre))
    return current_preamble()
end

"""
    set_preamble!(pre::AbstractString...; override=true)

Sets preamble statements of the latex document. `pre` is any number of `AbstractString`s, each as a separate argument. You can pass a single multi-line string, or any number of single-line strings.

Returns the complete preamble.

This function always resets the current preamble first. By default it also overrides the default preamble, meaning that the default will not show up in the final latex document. To suppress this behavior set `override=false`.
"""
function set_preamble!(pre::AbstractString...; override::Bool=true)
    reset_preamble!()
    if override
        _USE_DEFAULT_PREAMBLE[] = false
    end
    append!(_CUSTOM_PREAMBLE, String.(pre))
    return current_preamble()
end


# Document

function _assemble_document(latex_content::AbstractString; standalone=false)
    if standalone
        return String(latex_content)
    else
        doc = String[
      raw"\documentclass{article}",
      current_preamble()...,
      raw"\begin{document}",
      String(latex_content),
      raw"\end{document}"
    ]
        return join(doc, '\n')
    end
end