// Created by Mike Salari

import SwiftUI
struct ThresholdSingleEvidenceView: View {
    let width = CGFloat(Int(CommandLine.arguments.value(after: "--width") ?? "200") ?? 200)
    var body: some View { let type: DynamicTypeSize = (CommandLine.arguments.value(after: "--dynamic-type") == "accessibility5") ? .accessibility5 : .large; VStack(alignment: .leading, spacing: 12) { Text("One label, shrinking space").font(.title3).environment(\.dynamicTypeSize, .large); Text("width=\(Int(width)) | dynamicType=\(String(describing: type)) | scale=0.8 | lineLimit=1").font(.caption).environment(\.dynamicTypeSize, .large); Text("Morning Interval Training Session").font(.headline).lineLimit(1).minimumScaleFactor(0.8).frame(width: width, alignment: .leading).border(.orange); Text("reportedHeightRatio is measuredHeight / idealHeight").font(.caption2).environment(\.dynamicTypeSize, .large) }.padding().environment(\.dynamicTypeSize, type) }
}
