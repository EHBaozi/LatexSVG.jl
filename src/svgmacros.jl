# Most of this file is shamelessly copied from LaTeXStrings.jl. Here's its license:

#=
Copyright © 2013-2014 by Steven G. Johnson.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
=#

@doc raw"""
    Lsvg"..."

Renders the input as SVG with the current preamble and LaTeX engine.

This behave similarly to the `raw"..."` string macro in the sense that you do not have to escape special characters like `\` and `$` which makes it easier to write LaTeX.

You can interpolate variables using the `%$` syntax, which is the same as the `L"..."` string macro in `LaTeXStrings.jl`. For instance, if there is a variable `x = 10`, then `Lsvg"number %$x"` will render the string `"number 10"`. However, unlike the `L"..."` macro, `Lsvg"..."` does not automatically wrap your input in a pair of dollar signs, since it is very much possible that you'll want to use some other LaTeX environment.
"""
macro Lsvg_str(s::String)
    return esc(_Lsvg(s, String(__source__.file)))
end

function _Lsvg(s::String, filename)
    i = firstindex(s)
    buf = IOBuffer(maxsize=ncodeunits(s))
    ex = Expr(:call, GlobalRef(LatexSVG, :latexsvg))
    while i <= ncodeunits(s)
        c = @inbounds s[i]
        i = nextind(s, i)
        if c === '%' && i <= ncodeunits(s)
            c = @inbounds s[i]
            if c === '$'
                position(buf) > 0 && push!(ex.args, String(take!(buf)))
                atom, i = Meta.parseatom(s, nextind(s, i), filename=filename)
                Meta.isexpr(atom, :incomplete) && error(atom.args[1])
                atom !== nothing && push!(ex.args, atom)
                continue
            else
                print(buf, '%')
            end
        else
            print(buf, c)
        end
    end
    position(buf) > 0 && push!(ex.args, String(take!(buf)))
    return ex
end
