# Color

A `Color` represents a color value with support for HEX, RGB, RGBA, and HSL spaces, color manipulation, and accessibility metrics.

```poo
val red  = Color("#ff0000");
val blue = Color.rgb(0, 0, 255);
```

---

## Methods

[`alpha`](#alpha) ·
[`bytesize`](#bytesize) ·
[`contrast_ratio`](#contrast_ratio) ·
[`darken`](#darken) ·
[`desaturate`](#desaturate) ·
[`invert`](#invert) ·
[`is_dark`](#is_dark) ·
[`is_light`](#is_light) ·
[`lighten`](#lighten) ·
[`mix`](#mix) ·
[`saturate`](#saturate) ·
[`to_darken`](#to_darken) ·
[`to_desaturate`](#to_desaturate) ·
[`to_hex`](#to_hex) ·
[`to_hsl`](#to_hsl) ·
[`to_invert`](#to_invert) ·
[`to_lighten`](#to_lighten) ·
[`to_mix`](#to_mix) ·
[`to_rgb`](#to_rgb) ·
[`to_rgba`](#to_rgba) ·
[`to_saturate`](#to_saturate) ·
[`to_string`](#to_string)

> [!NOTE]
> All methods could be used with both snake-case and pascal-case.

---

## alpha

Retrieves or sets the opacity/alpha channel value (between `0.0` and `1.0`) in-place.

```poo
val c = Color("#ff0000");
val a = c.alpha(); // 1.0
c.alpha(0.5);     // Sets opacity to 50% in-place
```

## bytesize

Returns the total memory size occupied by the color object in bytes.

```poo
Color("#ff0000").bytesize();
```

## contrast_ratio

Calculates the WCAG contrast ratio between the current color and another color (returns a value between `1.0` and `21.0`).

```poo
val bg = Color("#ffffff");
val fg = Color("#000000");
bg.contrast_ratio(fg); // 21.0
```

## darken

Reduces the lightness of the color in-place by a given percentage.

```poo
val c = Color("#ff0000");
c.darken(0.2); // Darkens by 20% in-place
```

## desaturate

Reduces the saturation of the color in-place by a given percentage.

```poo
val c = Color("#ff0000");
c.desaturate(0.5); // Desaturates by 50% in-place
```

## invert

Inverts the RGB channels of the color in-place.

```poo
val c = Color("#ffffff");
c.invert(); // Color becomes #000000
```

## is_dark

Returns `true` if the color is perceptually dark based on relative luminance.

```poo
Color("#000000").is_dark(); // true
```

## is_light

Returns `true` if the color is perceptually light based on relative luminance.

```poo
Color("#ffffff").is_light(); // true
```

## lighten

Increases the lightness of the color in-place by a given percentage.

```poo
val c = Color("#800000");
c.lighten(0.2); // Lightens by 20% in-place
```

## mix

Blends the current color with another color in-place based on a weight ratio (default `0.5`).

```poo
val c1 = Color("#ff0000");
val c2 = Color("#0000ff");
c1.mix(c2, 0.5); // Blends red and blue in-place
```

## saturate

Increases the saturation of the color in-place by a given percentage.

```poo
val c = Color("#804040");
c.saturate(0.3); // Saturates by 30% in-place
```

## to_darken

Returns a new darkened copy of the color leaving the original unmodified.

```poo
val original = Color("#ff0000");
val darker = original.to_darken(0.2);
```

## to_desaturate

Returns a new desaturated copy of the color leaving the original unmodified.

```poo
val original = Color("#ff0000");
val muted = original.to_desaturate(0.5);
```

## to_hex

Converts the color to its HEX string representation.

```poo
Color.rgb(255, 0, 0).to_hex(); // "#ff0000"
```

## to_hsl

Converts the color to an HSL tuple `#(hue, saturation, lightness)`.

```poo
Color("#ff0000").to_hsl(); // #(0, 100, 50)
```

## to_invert

Returns a new inverted copy of the color leaving the original unmodified.

```poo
val white = Color("#ffffff");
val black = white.to_invert(); // #000000
```

## to_lighten

Returns a new lightened copy of the color leaving the original unmodified.

```poo
val original = Color("#800000");
val lighter = original.to_lighten(0.2);
```

## to_mix

Returns a new blended copy of two colors leaving the originals unmodified.

```poo
val red = Color("#ff0000");
val blue = Color("#0000ff");
val purple = red.to_mix(blue, 0.5);
```

## to_rgb

Converts the color to an RGB tuple `#(r, g, b)`.

```poo
Color("#ff0000").to_rgb(); // #(255, 0, 0)
```

## to_rgba

Converts the color to an RGBA tuple `#(r, g, b, a)`.

```poo
Color("#ff0000").to_rgba(); // #(255, 0, 0, 1.0)
```

## to_saturate

Returns a new saturated copy of the color leaving the original unmodified.

```poo
val original = Color("#804040");
val vivid = original.to_saturate(0.3);
```

## to_string

Converts the color into a default CSS-compatible string representation.

```poo
Color("#ff0000").to_string(); // "rgb(255, 0, 0)"
```
