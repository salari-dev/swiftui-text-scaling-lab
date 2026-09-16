// Created by Mike Salari

import SwiftUI

struct ConditionContext: Hashable { let runID: UUID; let conditionID: String; let generation: Int }
enum Label: String, CaseIterable { case shortRun, running, morningRun, intervalRun, longTrainingSession
    var text: String { ["Run","Running","Morning Run","Morning Interval Run","Morning Interval Training Session"][Self.allCases.firstIndex(of: self)!] }
}
struct BatchCondition: Identifiable { let width: CGFloat; let scale: Double?; let type: DynamicTypeSize; let ordinal: Int
    var id: String { "\(Int(width))-\(scale.map { String($0) } ?? "none")-\(String(describing: type))" }
}

@MainActor final class BatchExperimentRunner: ObservableObject {
    let runID = UUID(); let conditions: [BatchCondition]; @Published var index = 0; @Published var generation = 0
    private var buffer: [Label: LayoutMeasurement] = [:]; private var committed = Set<String>(); private var rows: [LayoutMeasurement] = []
    init() { var n = 0; let types: [DynamicTypeSize] = [.large,.xxxLarge,.accessibility1,.accessibility3,.accessibility5]; conditions = [200,160,120,100,80].flatMap { w in [Double?.none,0.8,0.5,0.1].flatMap { s in types.map { t in let c = BatchCondition(width: CGFloat(w), scale: s, type: t, ordinal: n); n += 1; return c } } } }
    var condition: BatchCondition { conditions[index] }; var context: ConditionContext { ConditionContext(runID: runID, conditionID: condition.id, generation: generation) }
    func begin() { generation += 1; buffer.removeAll() }
    func record(_ m: LayoutMeasurement, label: Label, context: ConditionContext) { guard context == self.context else { return }; var x = m; x.runID = runID.uuidString; x.conditionID = context.conditionID; x.renderGeneration = context.generation; x.labelID = label.rawValue; x.minimumScaleFactor = condition.scale; x.lineLimit = 1; buffer[label] = x; if buffer.count == 5 && !committed.contains(condition.id) { commit() } }
    private func commit() { committed.insert(condition.id); let ordered = Label.allCases.compactMap { buffer[$0] }; rows += ordered; let store = MeasurementStore(); ordered.forEach(store.record); let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("measurements.csv"); let output = (index == 0 ? store.csv() : ((try? String(contentsOf: url)) ?? "") + "\n" + store.csv().split(separator: "\n").dropFirst().joined(separator: "\n")); try? output.write(to: url, atomically: true, encoding: .utf8); if index + 1 < conditions.count { index += 1; begin() } else { let status = "{\"runID\":\"\(runID)\",\"expectedConditions\":100,\"actualConditions\":\(committed.count),\"expectedRows\":500,\"actualRows\":\(rows.count),\"success\":true}"; try? status.write(to: url.deletingLastPathComponent().appendingPathComponent("batch-status.json"), atomically: true, encoding: .utf8) } }
}

struct BatchExperimentView: View { @StateObject private var runner = BatchExperimentRunner()
    var body: some View { let c = runner.condition; let ctx = runner.context; VStack(alignment: .leading) { Text("conditionID=\(c.id) | generation=\(ctx.generation)").font(.caption2); ForEach(Label.allCases, id: \.self) { label in ProposalProbeLayout(label: "adjacent", dynamicTypeLabel: String(describing: c.type), containerWidth: c.width, string: label.text, renderGeneration: ctx.generation, labelID: label.rawValue, onMeasurement: { m in Task { @MainActor in runner.record(m, label: label, context: ctx) } }) { let t = Text(label.text).font(.headline).lineLimit(1); if let s = c.scale { t.minimumScaleFactor(s) } else { t } }.frame(width: c.width, alignment: .leading) } }.padding().environment(\.dynamicTypeSize, c.type).onAppear { runner.begin() } }
}
