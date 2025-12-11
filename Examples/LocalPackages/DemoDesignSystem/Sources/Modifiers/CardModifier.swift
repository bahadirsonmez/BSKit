//
//  CardModifier.swift
//  DemoDesignSystem
//
//  Created by Bahadir Sonmez on 16.12.2025.
//

import SwiftUI

// MARK: - Card Modifier

public struct CardModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .background(DSColor.cardBackground)
            .cornerRadius(DSRadius.md)
            .dsShadow(.card)
    }
}

// MARK: - View Extension

public extension View {
    
    func cardStyle() -> some View {
        modifier(CardModifier())
    }
}
