@testset "Preamble" begin
    @test preamble() == ["\\usepackage{amsmath,amsthm,amssymb}", "\\usepackage{color}"]
    @test add_preamble!("\\usepackage{physics}") == ["\\usepackage{amsmath,amsthm,amssymb}", "\\usepackage{color}", "\\usepackage{physics}"]
    @test reset_preamble!() == ["\\usepackage{amsmath,amsthm,amssymb}", "\\usepackage{color}"]
    @test LatexSVG._assemble_document("testing latex") == """
    \\documentclass[12pt]{article}
    \\usepackage{amsmath,amsthm,amssymb}
    \\usepackage{color}
    \\pagestyle{empty}
    \\begin{document}
    testing latex
    \\end{document}
    """
    @test LatexSVG._assemble_document("testing latex"; standalone=true) == "testing latex"
end
