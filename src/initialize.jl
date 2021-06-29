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
                @info "Using $engname. Use `texengine!` to change the LaTeX engine for this session, or `config!` to set the default permanently, which will also suppress this message."
                return nothing
            end
        end
        error("No LaTeX engine is found. Make sure that LaTeX is properly installed on your system.")
    end
end

function _initialize_latex()
    if Sys.which("dvisvgm") === nothing
        error("dvisvgm not found. Your LaTeX installation should come with dvisvgm; make sure it is in your PATH.")
    end
    _initialize_preamble()
    _initialize_latexengine()
end
