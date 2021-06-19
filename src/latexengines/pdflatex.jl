"The `pdflatex` engine."
struct PDFLaTeX <: LaTeXEngine end

function runlatex(
    ::PDFLaTeX,
    input_file::AbstractString,
    output_path::AbstractString;
    extra_args::Vector{String}=String[],
    runcommand::Bool=true
)
    command = `pdflatex $extra_args -output-format=dvi -output-directory="$output_path" -quiet -halt-on-error "$input_file"`
    if runcommand
        run(command)
    end
    return command
end

dvisuffix(::PDFLaTeX) = "dvi"
