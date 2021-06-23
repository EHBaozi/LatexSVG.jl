function _initialize_preamble()
    if @has_preference(_DEFAULT_PREAMBLE_KEY)
        _DEFAULT_PREAMBLE[] = @load_preference(_DEFAULT_PREAMBLE_KEY)
    else
        _DEFAULT_PREAMBLE[] = [
            "\\usepackage{amsmath,amsthm,amssymb}",
            "\\usepackage{color}",
            "\\pagestyle{empty}"
        ]
    end
    return nothing
end

function _initialize_latexengine()
    if @has_preference(_DEFAULT_ENGINE_KEY)
        texengine!(default_texengine())
    else
        for (eng, ENG) in zip(("pdflatex", "xelatex"), (PDFLaTeX(), XeLaTeX()))
            @debug "Looking for $eng"
            if Sys.which(eng) !== nothing
                texengine!(ENG)
                @info "Using $eng. Use `texengine!` to change the LaTeX engine for this session, or `default_texengine!` to set the default permanently, which will also suppress this message."
                return nothing
            end
        end
        error("Neither `pdflatex` or `xelatex` are found. Make sure that LaTeX is properly installed on your system.")
    end
end

function _initialize_latex()
    if Sys.which("dvisvgm") === nothing
        error("dvisvgm not found. Your LaTeX installation should come with dvisvgm; make sure it is in your PATH.")
    end
    _initialize_preamble()
    _initialize_latexengine()
end
