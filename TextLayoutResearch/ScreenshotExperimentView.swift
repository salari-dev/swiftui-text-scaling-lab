// Created by Mike Salari

import SwiftUI

struct ScreenshotExperimentView: View {
    let width: CGFloat = CGFloat(Int(CommandLine.arguments.value(after: "--width") ?? "120") ?? 120)
    let scale: Double? = { let s = CommandLine.arguments.value(after: "--scale") ?? "none"; return s == "none" ? nil : Double(s) }()
    let type: DynamicTypeSize = { switch CommandLine.arguments.value(after: "--dynamic-type") ?? "large" { case "accessibility5": return .accessibility5; case "accessibility3": return .accessibility3; case "accessibility1": return .accessibility1; case "xxxLarge": return .xxxLarge; default: return .large } }()
    let labels = ["Run", "Running", "Morning Run", "Morning Interval Run", "Morning Interval Training Session"]
    var body: some View { VStack(alignment: .leading, spacing: 14) { Text("Adjacent Text comparison").font(.title3).environment(\.dynamicTypeSize, .large); Text("width=\(Int(width)) | scale=\(scale.map { String($0) } ?? "none") | dynamicType=\(String(describing: type)) | lineLimit=1").font(.caption).environment(\.dynamicTypeSize, .large); ForEach(labels, id: \.self) { label in let t = Text(label).font(.headline).lineLimit(1); Group { if let scale { t.minimumScaleFactor(scale) } else { t } }.frame(width: width, alignment: .leading).border(.orange) }; Text("All labels use .headline and equivalent \(Int(width)) pt containers.").font(.caption2).environment(\.dynamicTypeSize, .large) }.padding().environment(\.dynamicTypeSize, type) }
}

struct ComparisonView: View {
    let labels = ["Run", "Running", "Morning Run", "Morning Interval Run", "Morning Interval Training Session"]
    var body: some View { ScrollView { VStack(alignment: .leading, spacing: 20) { Text("width=120 | Dynamic Type=large").font(.headline); comparison(scales: [nil,0.8,0.5]); Text("width=120 | Dynamic Type=accessibility5").font(.headline).environment(\.dynamicTypeSize, .large); comparison(scales: [nil,0.8,0.5,0.1]).environment(\.dynamicTypeSize, .accessibility5); Text("Multiline / no scaling control").font(.headline).environment(\.dynamicTypeSize, .large); ForEach(labels, id: \.self) { Text($0).font(.headline).frame(width: 120, alignment: .leading).border(.green) } }.padding() } }
    @ViewBuilder private func comparison(scales: [Double?]) -> some View { ForEach(Array(scales.enumerated()), id: \.offset) { _, scale in VStack(alignment: .leading) { Text("scale=\(scale.map { String($0) } ?? "none")").font(.caption); ForEach(labels, id: \.self) { label in let t = Text(label).font(.headline).lineLimit(1); Group { if let scale { t.minimumScaleFactor(scale) } else { t } }.frame(width: 120, alignment: .leading).border(.orange) } } } }
}
extension Array where Element == String { func value(after flag: String) -> String? { guard let i = firstIndex(of: flag), i + 1 < count else { return nil }; return self[i + 1] } }
