#if canImport(UIKit)
//
//  CachedAsyncImage.swift
//  BSSwiftUI
//
//  Created by Bahadir Sonmez on 15.12.2025.
//

import SwiftUI
import BSCoreKit

// MARK: - Image Load State

enum ImageLoadState: Equatable {
    case idle
    case loaded(Image)
    
    static func == (lhs: ImageLoadState, rhs: ImageLoadState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loaded, .loaded):
            return true
        default:
            return false
        }
    }
}

// MARK: - Cached Async Image

public struct CachedAsyncImage<Content: View>: View {
    
    private let url: URL?
    private let cacheEnabled: Bool
    private let content: (Image) -> Content
    
    @State private var state: ImageLoadState = .idle
    
    public init(
        url: URL?,
        cacheEnabled: Bool = true,
        @ViewBuilder content: @escaping (Image) -> Content
    ) {
        self.url = url
        self.cacheEnabled = cacheEnabled
        self.content = content
    }
    
    public var body: some View {
        Group {
            switch state {
            case .idle:
                placeholderView
                    .onAppear {
                        loadImage()
                    }
            case .loaded(let image):
                content(image)
            }
        }
    }
    
    private var placeholderView: some View {
        Image(systemName: "photo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.gray.opacity(0.5))
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func loadImage() {
        guard let url = url, state == .idle else { return }
        
        // Check cache first (if enabled)
        if cacheEnabled,
           let cachedData = ImageCacheManager.shared.image(for: url),
           let uiImage = UIImage(data: cachedData) {
            state = .loaded(Image(uiImage: uiImage))
            return
        }
        
        // Fetch from network
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                // Cache the image (if enabled)
                if cacheEnabled {
                    ImageCacheManager.shared.store(data, for: url)
                }
                
                if let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        state = .loaded(Image(uiImage: uiImage))
                    }
                }
            } catch {
                // Keep showing placeholder on error
            }
        }
    }
}

// MARK: - Convenience Initializer

public extension CachedAsyncImage where Content == Image {
    
    init(url: URL?) {
        self.init(url: url, content: { $0 })
    }
}
#endif
