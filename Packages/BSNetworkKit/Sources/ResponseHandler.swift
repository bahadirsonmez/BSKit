//
//  ResponseHandler.swift
//  BSNetworkKit
//
//  Created by Bahadir Sonmez on 11.12.2025.
//

import Foundation

public struct ResponseHandler {
    
    // MARK: - Completion-based
    
    public static func handle<T: Decodable>(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        decoder: JSONDecoder
    ) -> Result<T, NetworkError> {
        
        if let error = error {
            return .failure(.unknown(error))
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.noData)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            return .failure(.serverError(statusCode: httpResponse.statusCode))
        }
        
        guard let data = data else {
            return .failure(.noData)
        }
        
        return decode(data, decoder: decoder)
    }
    
    // MARK: - Async/Await
    
    public static func handleAsync<T: Decodable>(
        data: Data,
        response: URLResponse,
        decoder: JSONDecoder
    ) throws -> T {
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        return try decodeOrThrow(data, decoder: decoder)
    }
    
    // MARK: - Private
    
    private static func decode<T: Decodable>(_ data: Data, decoder: JSONDecoder) -> Result<T, NetworkError> {
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(.decodingError)
        }
    }
    
    private static func decodeOrThrow<T: Decodable>(_ data: Data, decoder: JSONDecoder) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
