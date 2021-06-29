"The `xelatex` engine."
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
