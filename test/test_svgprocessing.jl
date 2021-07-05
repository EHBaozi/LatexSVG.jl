@testset "Postprocessing" begin
    @test LatexSVG._adjust_web_svg_dim("16.180339pt") == "1.618034rem"

    @test begin
        svg_test = """
        <?xml version="1.0" encoding="utf-8"?>
        <svg width="21.923673pt" height="8.966376pt" viewBox="67.695921 70.081196 21.923673 8.966376">
        <defs/>
        </svg>
        """
        svg_adjusted = LatexSVG._adjust_web_svg(svg_test)
        svg_adjusted == """
        <?xml version="1.0" encoding="UTF-8"?>
        <svg height="0.896638rem" viewBox="67.695921 70.081196 21.923673 8.966376" class="latexsvg-display" style="display: block; margin: auto; max-width: 80%">
        <defs/>
        </svg>
        """
    end
end
