// Created by Mike Salari

import CoreGraphics
import Foundation

struct LayoutMeasurement: Codable, Equatable, Sendable {
    var timestamp = Date()
    var configuration: String
    var dynamicTypeSize: String
    var containerWidth: CGFloat
    var incomingProposalWidth: CGFloat?
    var incomingProposalHeight: CGFloat?
    var childProposalWidth: CGFloat?
    var childProposalHeight: CGFloat?
    var measuredWidth: CGFloat
    var measuredHeight: CGFloat
    var idealWidth: CGFloat?
    var idealHeight: CGFloat?
    var minimumWidth: CGFloat?
    var minimumHeight: CGFloat?
    var maximumWidth: CGFloat?
    var maximumHeight: CGFloat?
    var finalWidth: CGFloat
    var finalHeight: CGFloat
    var runID: String = ""
    var conditionID: String = ""
    var string: String = ""
    var stringLength: Int = 0
    var lineLimit: Int = 1
    var minimumScaleFactor: Double? = nil
    var actualGlyphScale: String = "unavailable"
    var renderGeneration: Int = 0
    var labelID: String = ""
}

@MainActor
final class MeasurementStore: ObservableObject {
    @Published var latest: LayoutMeasurement?
    @Published private(set) var all: [LayoutMeasurement] = []
    func record(_ measurement: LayoutMeasurement) { latest = measurement; all.append(measurement) }
    func csv() -> String {
        let header = "runID,conditionID,renderGeneration,labelID,text,stringLength,containerWidth,dynamicTypeSize,minimumScaleFactor,lineLimit,incomingProposalWidth,incomingProposalHeight,childProposalWidth,childProposalHeight,measuredWidth,measuredHeight,idealWidth,idealHeight,zeroWidth,zeroHeight,infinityWidth,infinityHeight,finalWidth,finalHeight,actualGlyphScale"
        let rows = all.map { m in
            var values: [String] = []
            values.append(contentsOf: [m.runID, m.conditionID, String(m.renderGeneration), m.labelID, m.string.replacingOccurrences(of: ",", with: " "), String(m.stringLength), String(describing: m.containerWidth), m.dynamicTypeSize])
            values.append(m.minimumScaleFactor.map { String($0) } ?? "none")
            values.append(String(m.lineLimit)); values.append(m.incomingProposalWidth.map { String(describing: $0) } ?? ""); values.append(m.incomingProposalHeight.map { String(describing: $0) } ?? "")
            values.append(m.childProposalWidth.map { String(describing: $0) } ?? ""); values.append(m.childProposalHeight.map { String(describing: $0) } ?? "")
            values.append(String(describing: m.measuredWidth)); values.append(String(describing: m.measuredHeight)); values.append(m.idealWidth.map { String(describing: $0) } ?? ""); values.append(m.idealHeight.map { String(describing: $0) } ?? "")
            values.append(contentsOf: [String(describing: m.minimumWidth ?? .nan), String(describing: m.minimumHeight ?? .nan), String(describing: m.maximumWidth ?? .nan), String(describing: m.maximumHeight ?? .nan), String(describing: m.finalWidth), String(describing: m.finalHeight), m.actualGlyphScale])
            return values.joined(separator: ",")
        }
        return ([header] + rows).joined(separator: "\n")
    }
}
