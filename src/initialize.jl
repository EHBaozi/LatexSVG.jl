"""
    default_texengine()

Returns the default LaTeX engine. By default this is unset. You can set a default with [`default_texengine!`](@ref) and your choice will persist for all future Julia sessions.
"""
function default_texengine()
    if @has_preference("latexengine")
        preferred_engine_str = @load_preference("latexengine")
        if preferred_engine_str == "PDFLaTeX"
            return PDFLaTeX()
        elseif preferred_engine_str == "XeLaTeX"
            return XeLaTeX()
        else
            @warn "Unknown LaTeX engine $preferred_engine_str; please set a valid default LaTeX engine with `default_texengine!`."
            return nothing
        end
    else
        @info "You are using $(texengine()) for this session. To set it as the default for all future sessions, use the `default_texengine!` function."
        return nothing
    end
end

"""
    default_texengine!(eng)

Sets the default LaTeX engine for this and all future Julia sessions. `eng` can be [`PDFLaTeX`](@ref) or [`XeLaTeX`](@ref).
"""
function default_texengine!(::T) where T <: LaTeXEngine
    @set_preferences!("latexengine" => string(nameof(T)))
    texengine!(T())
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
