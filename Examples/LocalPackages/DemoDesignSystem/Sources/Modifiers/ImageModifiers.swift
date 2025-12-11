//
//  ImageModifiers.swift
//  DemoDesignSystem
//
//  Created by Bahadir Sonmez on 16.12.2025.
//

import SwiftUI

// MARK: - Poster Image Style

public struct PosterImageModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .frame(width: DSSize.Poster.width, height: DSSize.Poster.height)
            .clipped()
            .cornerRadius(DSRadius.sm)
    }
}

// MARK: - Backdrop Image Style

public struct BackdropImageModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .frame(height: DSSize.Backdrop.height)
            .clipped()
    }
}

// MARK: - View Extensions

public extension View {
    
    func posterStyle() -> some View {
        modifier(PosterImageModifier())
    }
    
    func backdropStyle() -> some View {
        modifier(BackdropImageModifier())
    }
}
