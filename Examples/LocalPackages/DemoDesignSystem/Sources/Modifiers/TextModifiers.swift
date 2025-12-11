//
//  TextModifiers.swift
//  DemoDesignSystem
//
//  Created by Bahadir Sonmez on 16.12.2025.
//

import SwiftUI

// MARK: - Title Style

public struct TitleTextModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .font(DSTypography.title)
            .fontWeight(DSTypography.Weight.bold)
    }
}

// MARK: - Headline Style

public struct HeadlineTextModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .font(DSTypography.headline)
    }
}

// MARK: - Body Style

public struct BodyTextModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .font(DSTypography.body)
    }
}

// MARK: - Secondary Text Style

public struct SecondaryTextModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .font(DSTypography.subheadline)
            .foregroundColor(DSColor.textSecondary)
    }
}

// MARK: - Caption Style

public struct CaptionTextModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .font(DSTypography.caption)
            .foregroundColor(DSColor.textSecondary)
    }
}

// MARK: - View Extensions

public extension View {
    
    func titleStyle() -> some View {
        modifier(TitleTextModifier())
    }
    
    func headlineStyle() -> some View {
        modifier(HeadlineTextModifier())
    }
    
    func bodyStyle() -> some View {
        modifier(BodyTextModifier())
    }
    
    func secondaryStyle() -> some View {
        modifier(SecondaryTextModifier())
    }
    
    func captionStyle() -> some View {
        modifier(CaptionTextModifier())
    }
}
