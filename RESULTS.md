# Results

## Environment

Xcode 26.6 (17F113), Swift 6.3.3, iOS Simulator SDK 26.5, iOS 17.0 deployment target, iPhone 17 Simulator on iOS 26.5.

## Research questions

This project measures public SwiftUI layout proposals and Text responses for adjacent labels and for one long string under changing width. It does not infer private implementation details.

## Adjacent-label experiment

The final validated run contains 100 conditions and 500 rows. There are 25 no-scaling conditions with 0/25 differing-height conditions, and 75 scaling conditions with 75/75 differing-height conditions. The five stable labels are recorded in `Evidence/measurements.csv`.

## Width-threshold experiment

The corrected run is separated in `Evidence/WidthThreshold/measurements.csv` and contains 220 rows, including adaptive widths 250, 260, and 270 pt. For `.large / 0.8`, measured ideal width was 264.33 pt; ratios were approximately 0.803 at 200, 0.885 at 240, 0.934 at 250, 0.984 at 260/264, and 1.0 at 270 and above. This is an empirical transition zone, not an undocumented SwiftUI threshold.

## Validated findings

Adjacent labels can report different heights under identical nominal typography, geometry, Dynamic Type, and minimum scale settings. The effect is absent in the 25 no-scaling conditions and present in all 75 scaling conditions.

## Visual observations

The screenshots show the same `.headline` style and equal-width bounds while longer strings become visibly smaller under constrained single-line fitting. The threshold figures contain large and Accessibility 5 width sequences.

## Why this is not a SwiftUI bug

The behavior is consistent with the documented purpose of `minimumScaleFactor`: allowing text to reduce to fit a constrained line. The result is an expected behavior that can create a typography/design hazard. No framework bug was demonstrated.

## Accessibility scope

The evidence supports only the narrow statement that a constrained single-line component can report substantially reduced height while receiving a larger Dynamic Type environment. This is not a complete accessibility audit.

## What public API cannot tell us

The public APIs used here do not expose actual glyph scale, the internal rendering algorithm, or a definitive truncation state. `reportedHeightRatio` is measuredHeight / idealHeight, not font scale.

## Failed / excluded runs

The original zero-height-proposal threshold run is preserved under `Evidence/WidthThreshold/FailedZeroHeightProposalRun/`. It constrained both width and height and is excluded from analysis.
