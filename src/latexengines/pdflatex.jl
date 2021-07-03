"""
    PDFLaTeX

The `pdflatex` engine.

Command line options `-output-format=dvi`, `-quiet`, and `-halt-on-error` are passed to the `pdflatex` executable, and both the input and output directories are also handled. If you would like to pass additional command line arguments, use the [`latexsvg`](@ref) function.
"""
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

dviext(::PDFLaTeX) = "dvi"
