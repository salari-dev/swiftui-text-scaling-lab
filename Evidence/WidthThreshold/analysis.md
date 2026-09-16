# Width threshold analysis

The final corrected threshold CSV contains 220 rows: 11 tested widths, 4 scale settings, and 5 Dynamic Type values. `reportedHeightRatio` is `measuredHeight / idealHeight`; it is not a glyph scale.

For `.large / 0.8`, the measured ideal width is 264.33 pt. Ratios at widths 200, 240, 250, 260, 264, and 270 are approximately 0.803, 0.885, 0.934, 0.984, 0.984, and 1.0. The empirical transition zone is therefore 264–270 pt for this exact string, font, SDK, OS, device, and single-line layout.

The public API does not expose actual glyph scale or a definitive truncation state.
