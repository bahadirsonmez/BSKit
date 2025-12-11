//
//  DemoProjectApp.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 11.12.2025.
//

import SwiftUI

@main
struct DemoProjectApp: App {
    var body: some Scene {
        WindowGroup {
            MovieListRouter.createView(container: AppContainer.shared)
        }
    }
}
