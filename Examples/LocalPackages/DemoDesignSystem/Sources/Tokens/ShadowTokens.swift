//
//  ShadowTokens.swift
//  DemoDesignSystem
//
//  Created by Bahadir Sonmez on 16.12.2025.
//

import SwiftUI

// MARK: - Shadow Tokens

public struct DSShadow {
    #if canImport(SwiftUI)
    public let color: Color?
    #endif
    #if canImport(UIKit)
    public let uiColor: UIColor?
    #endif
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat
    
    #if canImport(SwiftUI)
    public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        self.color = color
        #if canImport(UIKit)
        self.uiColor = nil
        #endif
        self.radius = radius
        self.x = x
        self.y = y
    }
    #endif
    
    #if canImport(UIKit)
    public init(uiColor: UIColor, radius: CGFloat, x: CGFloat, y: CGFloat) {
        #if canImport(SwiftUI)
        self.color = nil
        #endif
        self.uiColor = uiColor
        self.radius = radius
        self.x = x
        self.y = y
    }
    #endif
}

public extension DSShadow {
    
    /// Card shadow
    #if canImport(SwiftUI)
    static let card = DSShadow(color: DSColor.shadow, radius: 4, x: 0, y: 2)
    #endif
    #if canImport(UIKit)
    static let uiCard = DSShadow(uiColor: DSColor.uiShadow, radius: 4, x: 0, y: 2)
    #endif
}

// MARK: - View Extension

#if canImport(SwiftUI)
public extension View {
    
    func dsShadow(_ shadow: DSShadow) -> some View {
        self.shadow(color: shadow.color ?? Color.clear, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}
#endif
