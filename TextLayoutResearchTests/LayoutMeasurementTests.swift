// Created by Mike Salari

import XCTest
@testable import TextLayoutResearch

@MainActor
final class LayoutMeasurementTests: XCTestCase {
    func testCSVContainsStableHeaderAndMeasurement() {
        let m = LayoutMeasurement(configuration: "A plain", dynamicTypeSize: "default", containerWidth: 240,
                                  incomingProposalWidth: 240, incomingProposalHeight: nil, childProposalWidth: 240,
                                  childProposalHeight: nil, measuredWidth: 200, measuredHeight: 30, idealWidth: 400,
                                  idealHeight: 20, minimumWidth: 0, minimumHeight: 30, maximumWidth: 400,
                                  maximumHeight: 20, finalWidth: 200, finalHeight: 30)
        let store = MeasurementStore(); store.record(m)
        XCTAssertTrue(store.csv().contains("containerWidth,dynamicTypeSize"))
        XCTAssertTrue(store.csv().contains("240.0"))
    }
}
