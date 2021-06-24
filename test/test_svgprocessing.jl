@testset "Postprocessing" begin
    @test LatexSVG._adjust_dim("1.618034pt") == "2.618034pt"
    @test LatexSVG._adjust_viewbox("3.141593 2.718282 1.618034 0.577216") == "2.641593 2.218282 2.618034 1.577216"

    @test begin
        svg_test = """
        <?xml version="1.0" encoding="utf-8"?>
        <svg width="21.923673pt" height="8.966376pt" viewBox="67.695921 70.081196 21.923673 8.966376">
        <defs/>
        </svg>
        """
        svg_adjusted = LatexSVG._adjust_web_svg(svg_test)
        svg_adjusted == """
        <?xml version="1.0" encoding="utf-8"?>
        <svg width="22.923673pt" height="auto" viewBox="67.195921 69.581196 22.923673 9.966376" style="display: block; margin: auto" class="latexsvg-displaystyle-svg">
        <defs/>
        </svg>
        """
    end
end
