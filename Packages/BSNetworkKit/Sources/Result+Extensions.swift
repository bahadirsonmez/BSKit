//
//  Result+Extensions.swift
//  BSNetworkKit
//
//  Created by Bahadir Sonmez on 13.12.2025.
//

import Foundation

public extension Result where Failure == NetworkError {
    
    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }
    
    var isFailure: Bool {
        !isSuccess
    }
    
    var value: Success? {
        if case .success(let value) = self { return value }
        return nil
    }
    
    var error: NetworkError? {
        if case .failure(let error) = self { return error }
        return nil
    }
}
