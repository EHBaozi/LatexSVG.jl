"""
    XeLaTeX

The `xelatex` engine.

Command line options `-no-pdf`, `-quiet`, and `-halt-on-error` are passed to the `xelatex` executable, and both the input and output directories are also handled. If you would like to pass additional command line arguments, use the [`latexsvg`](@ref) function.
"""
struct XeLaTeX <: LaTeXEngine end

function runlatex(
    ::XeLaTeX,
    input_file::AbstractString,
    output_path::AbstractString;
    extra_args::Vector{String}=String[],
    runcommand::Bool=true
)
    command = `xelatex $extra_args -no-pdf -output-directory="$output_path" -quiet -halt-on-error "$input_file"`
    if runcommand
        run(command)
    end
    return command
end

dviext(::XeLaTeX) = "xdv"
