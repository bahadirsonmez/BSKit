#if canImport(UIKit)
//
//  CachedImageView.swift
//  BSUIKit
//
//  Created by Bahadir Sonmez on 23.12.2025.
//

import UIKit
import BSCoreKit

/// A UIKit equivalent of CachedAsyncImage that provides asynchronous image loading and caching.
open class CachedImageView: UIImageView {
    
    // MARK: - Properties
    
    private var loadingTask: Task<Void, Never>?
    private let placeholderImage: UIImage?
    
    // MARK: - Initialization
    
    public init(placeholder: UIImage? = UIImage(systemName: "photo")) {
        self.placeholderImage = placeholder
        super.init(frame: .zero)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        self.placeholderImage = UIImage(systemName: "photo")
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentMode = .scaleAspectFill
        clipsToBounds = true
        image = placeholderImage
    }
    
    // MARK: - Public Methods
    
    /// Loads an image from the given URL with optional caching.
    /// - Parameters:
    ///   - url: The URL of the image to load.
    ///   - cacheEnabled: Whether to use the image cache. Defaults to true.
    public func loadImage(from url: URL?, cacheEnabled: Bool = true) {
        // Cancel any existing loading task
        loadingTask?.cancel()
        
        guard let url = url else {
            image = placeholderImage
            return
        }
        
        // Check cache first
        if cacheEnabled,
           let cachedData = ImageCacheManager.shared.image(for: url),
           let uiImage = UIImage(data: cachedData) {
            self.image = uiImage
            return
        }
        
        // Fetch from network
        image = placeholderImage
        
        loadingTask = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                // Ensure task wasn't cancelled while loading
                guard !Task.isCancelled else { return }
                
                if let uiImage = UIImage(data: data) {
                    // Cache the image
                    if cacheEnabled {
                        ImageCacheManager.shared.store(data, for: url)
                    }
                    
                    await MainActor.run {
                        self.transition(to: uiImage)
                    }
                }
            } catch {
                // Keep placeholder on error
            }
        }
    }
    
    /// Cancels the current image loading task and resets to placeholder.
    public func cancelLoading() {
        loadingTask?.cancel()
        loadingTask = nil
        image = placeholderImage
    }
    
    // MARK: - Private Methods
    
    private func transition(to newImage: UIImage) {
        UIView.transition(with: self,
                        duration: 0.3,
                        options: .transitionCrossDissolve,
                        animations: { self.image = newImage },
                        completion: nil)
    }
}
#endif
