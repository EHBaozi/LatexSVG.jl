@enum LaTeXEngine begin
  pdflatex
  xelatex
end

@doc "The `xelatex` engine" xelatex
@doc "The `pdflatex` engine" pdflatex

const _DEFAULT_ENGINE = Ref{LaTeXEngine}(xelatex)

"""
    texengine()

Returns the current latex engine.
"""
texengine() = _DEFAULT_ENGINE[]

"""
    texengine!(eng::LaTeXEngine)

Sets the latex engine. `eng` can be `pdflatex` or `xelatex`. Currently `lualatex` is not supported.
"""
texengine!(eng::LaTeXEngine) = _DEFAULT_ENGINE[] = eng

function _check_latex()
  if Sys.which("dvisvgm") === nothing
    error("dvisvgm not found. Your LaTeX installation should come with dvisvgm; make sure it is in your PATH.")
  end
  for eng in (xelatex, pdflatex)
    @debug "Looking for $(string(eng))"
    if Sys.which(string(eng)) !== nothing
      texengine!(eng)
      @info "Using $(string(eng)). To change the latex engine, use `texengine!`."
      return nothing
    end
  end
  error("Neither `xelatex` or `pdflatex` are found. Make sure that LaTeX is properly installed on your system.")
end
