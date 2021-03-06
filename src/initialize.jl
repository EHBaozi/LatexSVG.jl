function _initialize_preamble()
    pre = config(_DEFAULT_PREAMBLE_KEY; info=false)
    if pre === nothing
        _DEFAULT_PREAMBLE[] = [
            "\\usepackage{amsmath,amsthm,amssymb}",
            "\\usepackage{color}"
        ]
    else
        _DEFAULT_PREAMBLE[] = pre
    end
    return nothing
end

function _initialize_latexengine()
    eng = config(_DEFAULT_ENGINE_KEY; info=false)
    if eng !== nothing
        if eng == "PDFLaTeX"
            texengine!(PDFLaTeX())
        elseif eng == "XeLaTeX"
            texengine!(XeLaTeX())
        elseif eng == "LuaLaTeX"
            texengine!(LuaLaTeX())
        else
            @warn "Unknown LaTeX engine $eng; please set a valid default LaTeX engine with `config!`."
            return nothing
        end
    else
        for (engname, ENG) in zip(("xelatex", "pdflatex", "lualatex"), (XeLaTeX(), PDFLaTeX(), LuaLaTeX()))
            @debug "Looking for $engname"
            if Sys.which(engname) !== nothing
                texengine!(ENG)
                @debug "Using $engname. Use `texengine!` to change the LaTeX engine for this session, or `config!` to set the default permanently."
                return nothing
            end
        end
        @warn "No LaTeX engine is found. Make sure that LaTeX is properly installed on your system, and `xelatex`, `pdflatex`, or `lualatex` are available in your PATH."
        return nothing
    end
end

function _initialize_latex()
    _initialize_latexengine()
    if Sys.which("dvisvgm") === nothing
        @warn "dvisvgm not found. Your LaTeX installation should come with dvisvgm; make sure it is in your PATH, since this package won't function without it."
    end
    _initialize_preamble()
end
