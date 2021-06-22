function default_texengine()
    preferred_engine_str = @load_preference("latexengine")
    if preferred_engine_str == "PDFLaTeX"
        return PDFLaTeX()
    elseif preferred_engine_str == "XeLaTeX"
        return XeLaTeX()
    else
        @warn "Unknown LaTeX engine $preferred_engine_str; please set a valid default LaTeX engine with `default_texengine!`."
    end
end

function default_texengine!(::T) where T <: LaTeXEngine
    @set_preferences!("latexengine" => string(nameof(T)))
end

default_texengine!(::Type{T}) where T <: LaTeXEngine = default_texengine!(T())

function _check_latex()
    if Sys.which("dvisvgm") === nothing
        error("dvisvgm not found. Your LaTeX installation should come with dvisvgm; make sure it is in your PATH.")
    end
    if @has_preference("latexengine")
        texengine!(default_texengine())
    else
        for (eng, ENG) in zip(("pdflatex", "xelatex"), (PDFLaTeX(), XeLaTeX()))
            @debug "Looking for $eng"
            if Sys.which(eng) !== nothing
            texengine!(ENG)
            @info "Using $eng. Use `texengine!` to change the LaTeX engine for this session, or `default_texengine!` to set the default permanently."
            return nothing
            end
        end
        error("Neither `pdflatex` or `xelatex` are found. Make sure that LaTeX is properly installed on your system.")
    end
end
