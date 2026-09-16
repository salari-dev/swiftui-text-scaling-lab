# Width threshold final run

The prior zero-height-proposal run is archived under `FailedZeroHeightProposalRun/` and excluded. The corrected run contains 160 rows: 8 widths × 4 scale settings × 5 injected Dynamic Type values.

The actual threshold proposal is width-constrained and vertically unconstrained: `childProposalWidth = containerWidth` and `childProposalHeight` is empty/nil. For `.large / 0.8`, sanity cases were: width 200 measured height 16.33 vs ideal 20.33; width 264 measured 20.00 vs ideal 20.33; widths 280, 400, and 800 measured 20.33 vs ideal 20.33. The 800 pt control therefore does not show artificial minimum-scale reduction.

Truncation was not classified programmatically; actual glyph scale remains unavailable through public API.

## Adaptive threshold observations

The corrected run includes added widths 250, 260, and 270 around the `.large` transition. For `.large / 0.8`, ratios were 0.803 at 200, 0.885 at 240, 0.934 at 250, 0.984 at 260 and 264, and 1.0 at 270 and above. The tested transition zone is therefore 264–270 pt; no exact threshold is claimed.

For the wider Dynamic Type values, the first tested width with ratio 1.0 was 400 for `xxxLarge`, 600 for `accessibility1`, 600 for `accessibility3`, and 800 for `accessibility5` for the 0.8 setting. These are tested-width boundaries, not interpolated thresholds.

At large widths, `none` remains at ideal reported height even when the ideal width exceeds the container; this is consistent with a possible truncation state, but truncation was not inferred from size alone and requires visual confirmation.
