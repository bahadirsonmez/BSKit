//
//  StatItemView.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 21.12.2025.
//

import SwiftUI
import DemoDesignSystem

// MARK: - Stat Item View

struct StatItemView: View {
    
    private let icon: String
    private let value: String
    private let color: Color
    private let accessibilityLabelText: String
    
    init(icon: String, value: String, color: Color, accessibilityLabel: String) {
        self.icon = icon
        self.value = value
        self.color = color
        self.accessibilityLabelText = accessibilityLabel
    }
    
    var body: some View {
        HStack(spacing: DSSpacing.xxs) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(DSTypography.caption)
                .accessibilityHidden(true)
            Text(value)
                .font(DSTypography.subheadline)
                .fontWeight(DSTypography.Weight.medium)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabelText)
    }
}

// MARK: - Preview

#Preview("Rating") {
    StatItemView(
        icon: "star.fill",
        value: "8.5",
        color: DSColor.rating,
        accessibilityLabel: "Rating 8.5 out of 10"
    )
    .padding()
}

#Preview("Calendar") {
    StatItemView(
        icon: "calendar",
        value: "2025-01-01",
        color: DSColor.calendar,
        accessibilityLabel: "Release date January 1, 2025"
    )
    .padding()
}
