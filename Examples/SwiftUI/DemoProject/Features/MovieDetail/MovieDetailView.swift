//
//  MovieDetailView.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 13.12.2025.
//

import SwiftUI
import BSSwiftUI
import DemoDesignSystem
import DemoNetwork

struct MovieDetailView: BaseViewProtocol {
    
    @StateObject var viewModel: MovieDetailViewModel
    @StateObject private var router: MovieDetailRouter
    
    init(
        viewModel: MovieDetailViewModel,
        router: MovieDetailRouter
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _router = StateObject(wrappedValue: router)
    }
    
    private var supporter: MovieDetailSupporter {
        viewModel.supporter
    }
    
    var body: some View {
        contentBody
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.trigger(.viewDidLoad)
            }
    }
    
    var contentBody: some View {
        Group {
            switch viewModel.state {
            case .idle:
                LoadingView()
            case .loaded(let model):
                movieDetailContent(model: model)
                    .onAppear {
                        supporter.trackEvent(.screenViewed(movieId: model.id))
                    }
            }
        }
    }
    
    private func movieDetailContent(model: MovieDetailPresentationModel) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                backdropImage(model: model)
                movieInfoSection(model: model)
            }
            .frame(alignment: .leading)
        }
        .ignoresSafeArea(edges: .top)
    }
    
    private func backdropImage(model: MovieDetailPresentationModel) -> some View {
        ZStack(alignment: .bottomLeading) {
            CachedAsyncImage(url: model.backdropURL) { image in
                GeometryReader { geo in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                }
            }
            .backdropStyle()
            .accessibilityLabel(supporter.text(for: .backdropImageLabel(model.title)))
            
            LinearGradient(
                colors: [.clear, DSColor.overlayGradient],
                startPoint: .top,
                endPoint: .bottom
            )
            .accessibilityHidden(true)
            
            Text(model.title)
                .titleStyle()
                .foregroundColor(.white)
                .padding()
                .accessibilityAddTraits(.isHeader)
        }
    }
    
    private func movieInfoSection(model: MovieDetailPresentationModel) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            // Stats Row
            HStack(spacing: DSSpacing.lg) {
                if let rating = model.formattedRating {
                    StatItemView(
                        icon: "star.fill",
                        value: rating,
                        color: DSColor.rating,
                        accessibilityLabel: supporter.text(for: .ratingLabel(rating))
                    )
                }
                if let releaseDate = model.formattedReleaseDate {
                    StatItemView(
                        icon: "calendar",
                        value: releaseDate,
                        color: DSColor.calendar,
                        accessibilityLabel: supporter.text(for: .releaseDateLabel(releaseDate))
                    )
                }
            }
            
            // Overview
            if !model.overview.isEmpty {
                VStack(alignment: .leading, spacing: DSSpacing.xs) {
                    Text(supporter.text(for: .overview))
                        .headlineStyle()
                        .accessibilityAddTraits(.isHeader)
                    
                    Text(model.overview)
                        .bodyStyle()
                        .foregroundColor(DSColor.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            // Additional Info
            if model.originalTitle != nil || model.originalLanguage != nil {
                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    Text(supporter.text(for: .information))
                        .headlineStyle()
                        .accessibilityAddTraits(.isHeader)
                    
                    if let originalTitle = model.originalTitle {
                        infoRow(title: supporter.text(for: .originalTitle), value: originalTitle)
                    }
                    if let originalLanguage = model.originalLanguage {
                        infoRow(title: supporter.text(for: .originalLanguage), value: originalLanguage.uppercased())
                    }
                }
            }
        }
        .padding(.horizontal, DSSpacing.md)
        .padding(.vertical, DSSpacing.md)
    }
    
    
    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(DSColor.textSecondary)
            Spacer()
            Text(value)
                .fontWeight(DSTypography.Weight.medium)
                .multilineTextAlignment(.trailing)
        }
        .font(DSTypography.subheadline)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        MovieDetailView(
            viewModel: MovieDetailViewModel(
                movie: PreviewMocks.movie,
                supporter: MovieDetailSupporter()
            ),
            router: MovieDetailRouter(container: AppContainer.shared)
        )
    }
}
