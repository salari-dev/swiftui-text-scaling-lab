// Created by Mike Salari

import SwiftUI

struct ThresholdCondition: Identifiable { let width: CGFloat; let scale: Double?; let type: DynamicTypeSize; var id: String { "\(Int(width))-\(scale.map { String($0) } ?? "none")-\(String(describing: type))" } }
@MainActor final class WidthThresholdRunner: ObservableObject {
    let widths: [CGFloat] = [200,240,250,260,264,270,280,320,400,600,800]
    let scales: [Double?] = [nil,0.8,0.5,0.1]
    let types: [DynamicTypeSize] = [.large,.xxxLarge,.accessibility1,.accessibility3,.accessibility5]
    let text = "Morning Interval Training Session"; let conditions: [ThresholdCondition]
    @Published var index = 0; private var measurements: [LayoutMeasurement] = []
    init() { conditions = [200,240,250,260,264,270,280,320,400,600,800].flatMap { w in [Double?.none,0.8,0.5,0.1].flatMap { s in [DynamicTypeSize.large,.xxxLarge,.accessibility1,.accessibility3,.accessibility5].map { ThresholdCondition(width: CGFloat(w), scale: s, type: $0) } } } }
    var condition: ThresholdCondition { conditions[index] }
    func record(_ measurement: LayoutMeasurement, conditionID: String) { guard conditionID == condition.id, !measurements.contains(where: { $0.conditionID == conditionID }) else { return }; var m = measurement; m.runID = "threshold"; m.conditionID = conditionID; m.minimumScaleFactor = condition.scale; measurements.append(m); if index + 1 < conditions.count { index += 1 } else { persist() } }
    private func persist() { let store = MeasurementStore(); measurements.forEach(store.record); let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("WidthThreshold", isDirectory: true); try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true); try? store.csv().write(to: dir.appendingPathComponent("measurements.csv"), atomically: true, encoding: .utf8) }
}
struct WidthThresholdExperiment: View { @StateObject private var runner = WidthThresholdRunner()
    var body: some View { let c = runner.condition; VStack(alignment: .leading, spacing: 12) { Text("Width threshold | width=\(Int(c.width)) | scale=\(c.scale.map { String($0) } ?? "none") | dynamicType=\(String(describing: c.type))").font(.caption).environment(\.dynamicTypeSize, .large); ProposalProbeLayout(label: "threshold", dynamicTypeLabel: String(describing: c.type), containerWidth: c.width, string: runner.text, childProposalOverride: ProposedViewSize(width: c.width, height: nil), onMeasurement: { m in Task { @MainActor in runner.record(m, conditionID: c.id) } }) { let t = Text(runner.text).font(.headline).lineLimit(1); if let s = c.scale { t.minimumScaleFactor(s) } else { t } }.frame(width: c.width, alignment: .leading).border(.orange); Text("reportedHeightRatio = measuredHeight / idealHeight; actualGlyphScale = unavailable").font(.caption2).environment(\.dynamicTypeSize, .large) }.padding().environment(\.dynamicTypeSize, c.type) }
}
