//
//  ColorTokens.swift
//  DemoDesignSystem
//
//  Created by Bahadir Sonmez on 16.12.2025.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

#if canImport(UIKit)
import UIKit
#endif

// MARK: - Color Tokens

public enum DSColor {
    
    // MARK: - Background
    
    #if canImport(SwiftUI)
    public static let background = Color(.systemBackground)
    public static let cardBackground = Color(.secondarySystemBackground)
    #endif
    
    #if canImport(UIKit)
    public static let uiBackground = UIColor.systemBackground
    public static let uiCardBackground = UIColor.secondarySystemBackground
    #endif
    
    // MARK: - Text
    
    #if canImport(SwiftUI)
    public static let textSecondary = Color(.secondaryLabel)
    #endif
    
    #if canImport(UIKit)
    public static let uiTextSecondary = UIColor.secondaryLabel
    #endif
    
    // MARK: - Accent
    
    #if canImport(SwiftUI)
    public static let rating = Color.yellow
    public static let calendar = Color.green
    #endif
    
    #if canImport(UIKit)
    public static let uiRating = UIColor.systemYellow
    public static let uiCalendar = UIColor.systemGreen
    #endif
    
    // MARK: - Overlay
    
    #if canImport(SwiftUI)
    public static let overlayGradient = Color.black.opacity(0.7)
    #endif
    
    #if canImport(UIKit)
    public static let uiOverlayGradient = UIColor.black.withAlphaComponent(0.7)
    #endif
    
    // MARK: - Shadow
    
    #if canImport(SwiftUI)
    public static let shadow = Color.black.opacity(0.1)
    #endif
    
    #if canImport(UIKit)
    public static let uiShadow = UIColor.black.withAlphaComponent(0.1)
    #endif
}
