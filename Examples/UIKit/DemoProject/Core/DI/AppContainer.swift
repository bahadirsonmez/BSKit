//
//  AppContainer.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 23.12.2025.
//

import Foundation
import BSNetworkKit
import DemoNetwork

protocol AppContainerProtocol {
    var networkClient: NetworkClientProtocol { get }
}

final class AppContainer: AppContainerProtocol {
    
    static let shared = AppContainer()
    
    // MARK: - Network
    let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol = NetworkClient(decoder: .tmdb)) {
        self.networkClient = networkClient
    }
}
