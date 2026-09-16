// Created by Mike Salari

import SwiftUI
import UniformTypeIdentifiers

enum TextConfiguration: String, CaseIterable, Identifiable {
    case plain = "A plain"
    case lineLimited = "B lineLimit 1"
    case scale80 = "C lineLimit 1 + scale 0.8"
    case scale50 = "D lineLimit 1 + scale 0.5"
    case scale10 = "E lineLimit 1 + scale 0.1"
    var id: String { rawValue }
}

struct ExperimentView: View {
    private let text = "SwiftUI asks Text a sequence of layout questions before it decides what can fit."
    @StateObject private var store = MeasurementStore()
    @State private var width: CGFloat = 240
    @State private var configuration: TextConfiguration = .plain
    @State private var showingAdjacent = false
    @State private var exportURL: URL?
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Picker("Configuration", selection: $configuration) { ForEach(TextConfiguration.allCases) { Text($0.rawValue).tag($0) } }
                    .pickerStyle(.menu)
                    Picker("Width", selection: $width) { ForEach([320, 240, 180, 120, 80], id: \.self) { Text("\($0) pt").tag(CGFloat($0)) } }
                    .pickerStyle(.segmented)
                    Text("Dynamic Type: \(String(describing: dynamicTypeSize))").font(.caption)
                    ProposalProbeLayout(label: configuration.rawValue, dynamicTypeLabel: String(describing: dynamicTypeSize), containerWidth: width, onMeasurement: { measurement in
                        Task { @MainActor in store.record(measurement) }
                    }) {
                        configuredText.frame(width: width, alignment: .leading)
                    }
                    .frame(width: width, alignment: .leading)
                    .border(.blue)
                    if let m = store.latest { MeasurementPanel(measurement: m) }
                    Text("Measurements: \(store.all.count)").font(.caption2)
                    Button("Show adjacent-label experiment") { showingAdjacent = true }
                    Button("Show comparison experiment") { showingAdjacent = true }
                    Button("Export measurements.csv") {
                        let url = FileManager.default.temporaryDirectory.appendingPathComponent("measurements.csv")
                        try? store.csv().write(to: url, atomically: true, encoding: .utf8)
                        exportURL = url
                    }.fileExporter(isPresented: Binding(get: { exportURL != nil }, set: { if !$0 { exportURL = nil } }), document: CSVDocument(text: store.csv()), contentType: .commaSeparatedText, defaultFilename: "measurements") { _ in exportURL = nil }
                }.padding()
            }.navigationTitle("Text Layout Lab")
            .sheet(isPresented: $showingAdjacent) { AdjacentLabelsExperiment(store: store) }
        }
    }

    @ViewBuilder private var configuredText: some View {
        switch configuration {
        case .plain: Text(text).font(.headline)
        case .lineLimited: Text(text).font(.headline).lineLimit(1)
        case .scale80: Text(text).font(.headline).lineLimit(1).minimumScaleFactor(0.8)
        case .scale50: Text(text).font(.headline).lineLimit(1).minimumScaleFactor(0.5)
        case .scale10: Text(text).font(.headline).lineLimit(1).minimumScaleFactor(0.1)
        }
    }
}

struct AdjacentLabelsExperiment: View {
    let store: MeasurementStore
    @State private var width: CGFloat = 120
    @State private var scale: CGFloat = 0.8
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    private let labels = ["Run", "Running", "Morning Run", "Morning Interval Run", "Morning Interval Training Session"]
    var body: some View {
        NavigationStack { ScrollView { VStack(alignment: .leading, spacing: 12) {
            Picker("Width", selection: $width) { ForEach([200, 160, 120, 100, 80], id: \.self) { Text("\($0)").tag(CGFloat($0)) } }.pickerStyle(.segmented)
            Picker("Scale", selection: $scale) { Text("none").tag(CGFloat(1)); Text("0.8").tag(CGFloat(0.8)); Text("0.5").tag(CGFloat(0.5)); Text("0.1").tag(CGFloat(0.1)) }.pickerStyle(.menu)
            Text("Dynamic Type: \(String(describing: dynamicTypeSize))").font(.caption)
            ForEach(labels, id: \.self) { label in
                ProposalProbeLayout(label: "adjacent", dynamicTypeLabel: String(describing: dynamicTypeSize), containerWidth: width, onMeasurement: { measurement in Task { @MainActor in store.record(measurement) } }) {
                    let text = Text(label).font(.headline).lineLimit(1)
                    if scale == 1 { text } else { text.minimumScaleFactor(scale) }
                }.frame(width: width, alignment: .leading).border(.orange)
            }
            Text("Public SwiftUI does not expose actualGlyphScale.").font(.caption2)
        }.padding() }.navigationTitle("Adjacent Labels") }
    }
}

struct CSVDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.commaSeparatedText] }
    var text: String
    init(text: String = "") { self.text = text }
    init(configuration: ReadConfiguration) throws { text = String(data: configuration.file.regularFileContents ?? Data(), encoding: .utf8) ?? "" }
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper { FileWrapper(regularFileWithContents: Data(text.utf8)) }
}

private struct MeasurementPanel: View {
    let measurement: LayoutMeasurement
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Latest measurement").font(.headline)
            Text("incoming: \(measurement.incomingProposalWidth.map(String.init) ?? "nil") × \(measurement.incomingProposalHeight.map(String.init) ?? "nil")")
            Text("child: \(measurement.measuredWidth, format: .number.precision(.fractionLength(1))) × \(measurement.measuredHeight, format: .number.precision(.fractionLength(1)))")
            Text("ideal: \(measurement.idealWidth.map { String(format: "%.1f", $0) } ?? "nil") × \(measurement.idealHeight.map { String(format: "%.1f", $0) } ?? "nil")")
            Text("zero: \(measurement.minimumWidth.map { String(format: "%.1f", $0) } ?? "nil") | infinity: \(measurement.maximumWidth.map { String(format: "%.1f", $0) } ?? "nil")")
            Text("final: \(measurement.finalWidth, format: .number.precision(.fractionLength(1))) × \(measurement.finalHeight, format: .number.precision(.fractionLength(1)))")
        }.font(.caption).textSelection(.enabled)
    }
}
