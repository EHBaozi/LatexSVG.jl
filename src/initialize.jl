function _check_latex()
    if Sys.which("dvisvgm") === nothing
        error("dvisvgm not found. Your LaTeX installation should come with dvisvgm; make sure it is in your PATH.")
    end
    for (eng, ENG) in zip(("pdflatex", "xelatex"), (PDFLaTeX(), XeLaTeX()))
        @debug "Looking for $eng"
        if Sys.which(eng) !== nothing
        texengine!(ENG)
        @info "Using $eng. To change the LaTeX engine, use `texengine!`."
        return nothing
        end
    end
    error("Neither `pdflatex` or `xelatex` are found. Make sure that LaTeX is properly installed on your system.")
end
