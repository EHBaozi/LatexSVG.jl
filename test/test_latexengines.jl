@testset "LaTeXEngine" begin
    @test begin
        texengine!(PDFLaTeX)
        texengine() == PDFLaTeX()
    end

    @test LatexSVG.runlatex(XeLaTeX(), "test.tex", raw"C:\path to\out"; extra_args=["--shell-escape", "-synctex=1"], runcommand=false) == `xelatex --shell-escape -synctex=1 -no-pdf -output-directory="C:\\path to\\out" -quiet -halt-on-error "test.tex"`
    @test LatexSVG.runlatex(PDFLaTeX(), "test.tex", raw"C:\path to\out"; extra_args=["--shell-escape", "-synctex=1"], runcommand=false) == `pdflatex --shell-escape -synctex=1 -output-format=dvi -output-directory="C:\\path to\\out" -quiet -halt-on-error "test.tex"`
    @test LatexSVG.runlatex(LuaLaTeX(), "test.tex", raw"C:\path to\out"; extra_args=["--shell-escape", "--synctex=1"], runcommand=false) == `lualatex --shell-escape --synctex=1 --output-format=dvi --output-directory="C:\\path to\\out" --interaction=batchmode --halt-on-error "test.tex"`

    @test_throws ErrorException begin
        struct _MyEngine <: LatexSVG.LaTeXEngine end
        LatexSVG.runlatex(_MyEngine(), "test.tex", raw"C:\path to\out"; extra_args=["--shell-escape", "--synctex=1"])
    end
end
