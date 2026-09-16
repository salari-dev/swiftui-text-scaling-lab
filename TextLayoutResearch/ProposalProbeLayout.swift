// Created by Mike Salari

import SwiftUI

struct ProposalProbeLayout: Layout {
    var label: String
    var dynamicTypeLabel: String
    var containerWidth: CGFloat
    var string: String = ""
    var renderGeneration: Int = 0
    var labelID: String = ""
    var childProposalOverride: ProposedViewSize? = nil
    let onMeasurement: @Sendable (LayoutMeasurement) -> Void

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard let text = subviews.first else { return .zero }
        let measuredProposal = childProposalOverride ?? proposal
        let child = text.sizeThatFits(measuredProposal)
        let ideal = text.sizeThatFits(.unspecified)
        let minimum = text.sizeThatFits(.zero)
        let maximum = text.sizeThatFits(ProposedViewSize(width: .infinity, height: .infinity))
        let result = CGSize(width: min(child.width, containerWidth), height: child.height)
        let m = LayoutMeasurement(configuration: label, dynamicTypeSize: dynamicTypeLabel,
                                  containerWidth: containerWidth, incomingProposalWidth: proposal.width,
                                  incomingProposalHeight: proposal.height, childProposalWidth: measuredProposal.width,
                                  childProposalHeight: measuredProposal.height, measuredWidth: child.width,
                                  measuredHeight: child.height, idealWidth: ideal.width, idealHeight: ideal.height,
                                  minimumWidth: minimum.width, minimumHeight: minimum.height,
                                  maximumWidth: maximum.width, maximumHeight: maximum.height,
                                  finalWidth: result.width, finalHeight: result.height)
        var enriched = m
        enriched.string = string
        enriched.stringLength = string.count
        enriched.renderGeneration = renderGeneration
        enriched.labelID = labelID
        onMeasurement(enriched)
        return result
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        subviews.first?.place(at: CGPoint(x: bounds.minX, y: bounds.minY), proposal: proposal)
    }
}
