# Most of this file is shamelessly copied from LaTeXStrings.jl. Here's its license:

#=
Copyright © 2013-2014 by Steven G. Johnson.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
=#


_maybe_wrap_equation(s) = occursin(r"[^\\%]\$|^\$", s) ? s : string('\$', s, '\$')

@doc raw"""
    Lsvg"..."
    Lsvg"..."i

Parses and renders the input as SVG with the current preamble and LaTeX engine.

This behave similarly to the `raw"..."` string macro in the sense that you do not have to escape special characters like `\` and `$` which makes it easier to write LaTeX.

You can interpolate variables using the `%$` syntax, which is the same as the `L"..."` string macro in `LaTeXStrings.jl`. For instance, if there is a variable `x = 10`, then `Lsvg"number %$x"` will render the string `"number 10"`.

There is an optional flag "i" that can be passed to the macro, e.g. `Lsvg"abc"i`. This flag alters the behavior of the macro in several ways:
- With the flag "i", the input is automatically wrapped in a pair of "\$" signs (unless it is already present). For instance, `Lsvg"abc"i` and `Lsvg"$abc$"i` are both equivalent to `latexsvg("$abc$")`, while `Lsvg"abc"` is equivalent to `latexsvg("abc")`.
- Thus you'll want to use the flag for rendering LaTeX inline-style...
- ...and omit it for rendering display-style LaTeX. A special point to note is that omitting the flag does not automatically wrap the input in double-dollar signs, since it is very much possible that you want to use some other LaTeX environments.
- In HTML-capable environments, the flag "i" wraps the output SVG in such a way that it is suitable for inline display, such as alongside HTML text in a paragraph. Omitting the flag, on the other hand, causes the output SVG to be displayed in its own paragraph, center-aligned.
"""
macro Lsvg_str(s::String, inline::Union{String, Nothing}=nothing)
    return esc(_Lsvg(s, String(__source__.file), inline))
end

function _Lsvg(s::String, filename, inline::Union{String, Nothing}=nothing)
    if inline == "i"
        s = _maybe_wrap_equation(s)
    elseif inline !== nothing
        throw(ArgumentError("Unknown flag: $inline."))
    end
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
    if inline == "i"
        push!(ex.args, Expr(:kw, :inline, true))
    end
    return ex
end
