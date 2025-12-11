//
//  JSONDecoder+TMDB.swift
//  DemoNetwork
//
//  Created by Bahadir Sonmez on 15.12.2025.
//

import Foundation

public extension JSONDecoder {
    
    static var tmdb: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

