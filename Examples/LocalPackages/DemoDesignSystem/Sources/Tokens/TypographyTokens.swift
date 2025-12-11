//
//  TypographyTokens.swift
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

// MARK: - Typography Tokens

public enum DSTypography {
    
    // MARK: - Font Weights
    
    #if canImport(SwiftUI)
    public enum Weight {
        public static let medium = Font.Weight.medium
        public static let bold = Font.Weight.bold
    }
    #endif
    
    #if canImport(UIKit)
    public enum UIWeight {
        public static let medium = UIFont.Weight.medium
        public static let bold = UIFont.Weight.bold
    }
    #endif
    
    // MARK: - Predefined Fonts
    
    #if canImport(SwiftUI)
    public static let title = Font.title
    public static let headline = Font.headline
    public static let subheadline = Font.subheadline
    public static let body = Font.body
    public static let caption = Font.caption
    #endif
    
    #if canImport(UIKit)
    public static let uiTitle = UIFont.preferredFont(forTextStyle: .title1)
    public static let uiHeadline = UIFont.preferredFont(forTextStyle: .headline)
    public static let uiSubheadline = UIFont.preferredFont(forTextStyle: .subheadline)
    public static let uiBody = UIFont.preferredFont(forTextStyle: .body)
    public static let uiCaption = UIFont.preferredFont(forTextStyle: .caption1)
    #endif
}
