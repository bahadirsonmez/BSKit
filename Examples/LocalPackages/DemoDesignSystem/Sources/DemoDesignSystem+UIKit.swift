//
//  DemoDesignSystem+UIKit.swift
//  DemoDesignSystem
//
//  Created by Bahadir Sonmez on 23.12.2025.
//

#if canImport(UIKit)
import UIKit

public extension UIView {
    
    func applyCardStyle() {
        backgroundColor = DSColor.uiCardBackground
        layer.cornerRadius = DSRadius.md
        applyShadow(DSShadow.uiCard)
    }
    
    func applyShadow(_ shadow: DSShadow) {
        layer.shadowColor = (shadow.uiColor ?? .clear).cgColor
        layer.shadowOffset = CGSize(width: shadow.x, height: shadow.y)
        layer.shadowRadius = shadow.radius
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
    }
}

public extension UIImageView {
    
    func applyPosterStyle() {
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = DSRadius.sm
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: DSSize.Poster.width),
            heightAnchor.constraint(equalToConstant: DSSize.Poster.height)
        ])
    }
    
    func applyBackdropStyle() {
        contentMode = .scaleAspectFill
        clipsToBounds = true
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: DSSize.Backdrop.height)
        ])
    }
}

public extension UILabel {
    
    func applyStyle(_ font: UIFont, color: UIColor = .label) {
        self.font = font
        self.textColor = color
    }
}
#endif
