# WidthThresholdExperiment

This is a separate 160-condition run: 8 widths × 4 minimum-scale settings × 5 injected Dynamic Type values. It does not modify the validated adjacent-label dataset.

The CSV contains 160 rows and covers all requested conditions. For `none`, every observed `reportedHeightRatio` is 1.0. For each non-`none` setting, the recorded ratio is approximately the configured minimum across the tested widths in this implementation: 0.803 (0.8), 0.508 (0.5), and 0.115 (0.1) at `large` (minor rounding/platform metrics vary by Dynamic Type). The measured ideal widths are recorded per Dynamic Type; at `large` the ideal width was 264.33 pt, not assumed to be exactly 264.

This result is a warning about experimental interpretation: the public `Layout` response is not a direct readout of the glyph scale or of a hidden SwiftUI phase. No truncation classification was made programmatically. Additional adaptive widths and deterministic visual truncation review are still required before claiming an exact transition threshold.

`actualGlyphScale` is `unavailable` in every row. `reportedHeightRatio` is measuredHeight / idealHeight only.
