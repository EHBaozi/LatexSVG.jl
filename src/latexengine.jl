function _pdflatex(filepath::AbstractString)
  output_path = joinpath(splitpath(filepath)[begin:end-1]...)
  run(`pdflatex -output-format=dvi -output-directory="$output_path" -quiet -halt-on-error "$filepath"`)
end

function _xelatex(filepath::AbstractString)
  output_path = joinpath(splitpath(filepath)[begin:end-1]...)
  run(`xelatex -no-pdf -output-directory="$output_path" -quiet -halt-on-error "$filepath"`)
end

function _to_dvi(filepath::AbstractString, engine::LaTeXEngine=texengine())
  if engine == pdflatex
    _pdflatex(filepath)
  elseif engine == xelatex
    _xelatex(filepath)
  end
end

function _to_svg(dvi_path::AbstractString)
  output = IOBuffer()
  run(pipeline(`dvisvgm -p 1 "$dvi_path" -b min -n -v 0 -s`, stdout=output))
  return String(take!(output))
end
