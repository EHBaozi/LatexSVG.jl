# Displaying in a webpage

If you are using the output SVG file directly in HTML, there are a few things you need to take note.

By default, the saved SVG file hard-codes its dimensions with the `width` and `height` attributes. This is not recommended as you instead want the SVG to resize based on the content on the webpage (which is possible due to the `viewBox` attribute so don't mess with that.) You'll also want additional styles to ensure that the SVG is properly positioned. The [`savesvg`](@ref) function helps you accomplish this:

```@docs
savesvg
```

Each of the 3 adjustments accomplish different things:

1. **Scaling**: the first adjustment makes the font size in the SVG scale to exactly 1.2 times the font size associated with the root `<html>` tag. This ensures that LaTeX is displayed more nicely and elements such as subscripts and superscripts are legible. If you prefer a different scale, simply change the `height` attribute. You can also change the unit to `em` so that it scales with the font size of its parent instead of the root.

   Also note that, since the `width` attribute no longer exists, if you would like to manually scale the SVG to a certain size with CSS (which then overrides the font-size based scaling), you should always set the `height` attribute.

2. **Positioning**: the second adjustment helps to position the SVG with respect to the surrounding content, but it doens't do the trick by itself. You need to additionally place the SVG inside a container. For display-style LaTeX:

   ```html
   <p><span style="display: inline-block; width: 100%">
   <!-- Copy-paste the SVG here -->
   </span><p>
   ```

   This nicely center-aligns the SVG. For inline-style LaTeX, the surrounding HTML should look like

   ```html
   <p>This is an inline SVG
   <span>
   <!-- Copy-paste the SVG here -->
   </span>
   from LatexSVG.jl.
   </p>
   ```

   This aligns the SVG with the surrounding text.

The third adjustment is simply there to facilitate further styling directly with CSS. For instance, you may want to change the `fill` color in accordance with light/dark mode.

!!! note
    With these adjustments, it is recommended that you use the SVG directly inline in HTML (instead of embedding it in, say, an `<img />` tag.)

These are just the most basic instructions; the SVG format is very powerful and there is room for a lot of customizations.

---

!!! note
    Sadly, the inline style is not yet achieveable in Documenter/Weave/etc., since the Julia flavor of markdown doesn't have support for inline raw HTML and it is difficult to have them capture inline HTML output. This means that, as mentioned in the [introduction](../index.md), this package can't yet function as a complete replacement for `mathjax` or `KaTeX` in these environments without some user effort.

!!! note
    Continuing the point above, one way to replace `mathjax` with this package is to use `pandoc` filters. You can simply write a filter that replaces all inline and display math elements in your markdown document with raw HTML code blocks that contain the SVG output from this package. Downside being, again, that this doesn't work with anything built on top of Julia markdown, however there are still plenty of places where you can use this method. (Also, there isn't yet a Julia package that facilitates writing pandoc filters, although it's nothing more than manipulating JSON so it shouldn't be too hard in principle.)
