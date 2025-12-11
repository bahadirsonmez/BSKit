//
//  ImageCacheManager.swift
//  BSCoreKit
//
//  Created by Bahadir Sonmez on 15.12.2025.
//

import Foundation

// MARK: - Image Cache Manager

public final class ImageCacheManager {
    
    public static let shared = ImageCacheManager()
    
    private let memoryCache = NSCache<NSString, NSData>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("ImageCache")
        
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        
        memoryCache.countLimit = 100
        memoryCache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
    }
    
    // MARK: - Methods
    
    public func image(for url: URL) -> Data? {
        let key = cacheKey(for: url)
        
        // Check memory cache first
        if let data = memoryCache.object(forKey: key as NSString) {
            return data as Data
        }
        
        // Check disk cache
        let filePath = cacheDirectory.appendingPathComponent(key)
        if let data = try? Data(contentsOf: filePath) {
            // Store in memory cache for faster access next time
            memoryCache.setObject(data as NSData, forKey: key as NSString, cost: data.count)
            return data
        }
        
        return nil
    }
    
    public func store(_ data: Data, for url: URL) {
        let key = cacheKey(for: url)
        
        // Store in memory cache
        memoryCache.setObject(data as NSData, forKey: key as NSString, cost: data.count)
        
        // Store on disk
        let filePath = cacheDirectory.appendingPathComponent(key)
        try? data.write(to: filePath)
    }
    
    public func clearCache() {
        memoryCache.removeAllObjects()
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    // MARK: - Private Methods
    
    private func cacheKey(for url: URL) -> String {
        url.absoluteString.data(using: .utf8)?.base64EncodedString() ?? url.lastPathComponent
    }
}
