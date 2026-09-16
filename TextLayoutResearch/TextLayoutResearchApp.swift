// Created by Mike Salari

import SwiftUI

@main
struct TextLayoutResearchApp: App {
    var body: some Scene {
        WindowGroup { CommandLine.arguments.contains("--batch") ? AnyView(BatchExperimentView()) : (CommandLine.arguments.contains("--threshold") ? AnyView(WidthThresholdExperiment()) : (CommandLine.arguments.contains("--threshold-screenshot") ? AnyView(ThresholdSingleEvidenceView()) : (CommandLine.arguments.contains("--comparison") ? AnyView(ComparisonView()) : (CommandLine.arguments.contains("--screenshot") ? AnyView(ScreenshotExperimentView()) : AnyView(ExperimentView()))))) }
    }
}
