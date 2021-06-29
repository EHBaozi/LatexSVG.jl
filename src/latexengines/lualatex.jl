"the `lualatex` engine."
struct LuaLaTeX <: LaTeXEngine end

function runlatex(
    ::LuaLaTeX,
    input_file::AbstractString,
    output_path::AbstractString;
    extra_args::Vector{String}=String[],
    runcommand::Bool=true
)
    command = `lualatex $extra_args --output-format=dvi --output-directory="$output_path" --interaction=batchmode --halt-on-error "$input_file"`
    if runcommand
        run(command)
    end
    return command
end

dviext(::LuaLaTeX) = "dvi"
