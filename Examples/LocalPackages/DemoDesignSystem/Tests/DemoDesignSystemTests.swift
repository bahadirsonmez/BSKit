//
//  DemoDesignSystemTests.swift
//  DemoDesignSystem
//
//  Created by Bahadir Sonmez on 16.12.2025.
//

import XCTest
@testable import DemoDesignSystem

final class DemoDesignSystemTests: XCTestCase {
    
    func testSpacingTokens() {
        XCTAssertEqual(DSSpacing.xs, 8)
        XCTAssertEqual(DSSpacing.md, 16)
        XCTAssertEqual(DSSpacing.lg, 20)
    }
    
    func testRadiusTokens() {
        XCTAssertEqual(DSRadius.sm, 8)
        XCTAssertEqual(DSRadius.md, 12)
    }
    
    func testSizeTokens() {
        XCTAssertEqual(DSSize.Icon.large, 60)
        XCTAssertEqual(DSSize.Poster.width, 100)
        XCTAssertEqual(DSSize.Backdrop.height, 250)
    }
}
