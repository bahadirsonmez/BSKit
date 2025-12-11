//
//  MovieDetailViewController.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 23.12.2025.
//

import UIKit
import BSUIKit
import DemoNetwork
import DemoDesignSystem

final class MovieDetailViewController: BaseViewController<MovieDetailViewModel, UIView> {
    
    private let router: MovieDetailRouter
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backdropImageView: CachedImageView = {
        let imageView = CachedImageView(placeholder: UIImage(systemName: "photo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = DSSpacing.lg
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let ratingView = StatItemView()
    private let releaseDateView = StatItemView()
    
    private let infoSectionStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = DSSpacing.md
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let overviewHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let additionalInfoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = DSSpacing.sm
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let infoHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(viewModel: MovieDetailViewModel, router: MovieDetailRouter) {
        self.router = router
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        navigationItem.largeTitleDisplayMode = .never
        mainView.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(backdropImageView)
        containerView.addSubview(gradientView)
        containerView.addSubview(titleLabel)
        
        containerView.addSubview(statsStackView)
        statsStackView.addArrangedSubview(ratingView)
        statsStackView.addArrangedSubview(releaseDateView)
        
        containerView.addSubview(infoSectionStackView)
        
        infoSectionStackView.addArrangedSubview(overviewHeaderLabel)
        infoSectionStackView.addArrangedSubview(overviewLabel)
        infoSectionStackView.setCustomSpacing(DSSpacing.xs, after: overviewHeaderLabel)
        
        infoSectionStackView.addArrangedSubview(additionalInfoStackView)
        additionalInfoStackView.addArrangedSubview(infoHeaderLabel)
        
        setupStyles()
        setupConstraints()
    }
    
    private func setupStyles() {
        backdropImageView.applyBackdropStyle()
        
        titleLabel.applyStyle(DSTypography.uiTitle, color: .white)
        titleLabel.font = DSTypography.uiTitle.withWeight(.bold)
        
        overviewHeaderLabel.applyStyle(DSTypography.uiHeadline)
        overviewLabel.applyStyle(DSTypography.uiBody, color: DSColor.uiTextSecondary)
        
        infoHeaderLabel.applyStyle(DSTypography.uiHeadline)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, DSColor.uiOverlayGradient.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientView.layer.addSublayer(gradientLayer)
        
        // Update gradient frame on layout
        view.setNeedsLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientView.layer.sublayers?.first?.frame = gradientView.bounds
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: mainView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            backdropImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            gradientView.topAnchor.constraint(equalTo: backdropImageView.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: backdropImageView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: backdropImageView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: backdropImageView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: DSSpacing.md),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -DSSpacing.md),
            titleLabel.bottomAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: -DSSpacing.md),
            
            statsStackView.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: DSSpacing.md),
            statsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: DSSpacing.md),
            
            infoSectionStackView.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: DSSpacing.md),
            infoSectionStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: DSSpacing.md),
            infoSectionStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -DSSpacing.md),
            infoSectionStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -DSSpacing.md)
        ])
    }
    
    override func bindViewModel() {
        configure()
        viewModel.trigger(.viewDidLoad)
    }
    
    private func configure() {
        let movie = viewModel.movie
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        backdropImageView.loadImage(from: movie.backdropURL)
        
        overviewHeaderLabel.text = viewModel.text(for: "movieDetail.overview")
        infoHeaderLabel.text = viewModel.text(for: "movieDetail.information")
        
        if let rating = movie.formattedRating {
            ratingView.configure(icon: "star.fill", value: rating, color: DSColor.uiRating)
        } else {
            ratingView.isHidden = true
        }
        
        if let releaseDate = movie.formattedReleaseDate {
            releaseDateView.configure(icon: "calendar", value: releaseDate, color: DSColor.uiCalendar)
        } else {
            releaseDateView.isHidden = true
        }
        
        setupAdditionalInfo(movie: movie)
    }
    
    private func setupAdditionalInfo(movie: Movie) {
        additionalInfoStackView.arrangedSubviews.forEach { if $0 != infoHeaderLabel { $0.removeFromSuperview() } }
        
        if let originalTitle = movie.originalTitle {
            addInfoRow(title: viewModel.text(for: "movieDetail.originalTitle"), value: originalTitle)
        }
        
        if let originalLanguage = movie.originalLanguage {
            addInfoRow(title: viewModel.text(for: "movieDetail.originalLanguage"), value: originalLanguage.uppercased())
        }
    }
    
    private func addInfoRow(title: String, value: String) {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        
        let titleLabel = UILabel()
        titleLabel.applyStyle(DSTypography.uiSubheadline, color: DSColor.uiTextSecondary)
        titleLabel.text = title
        
        let valueLabel = UILabel()
        valueLabel.applyStyle(DSTypography.uiSubheadline)
        valueLabel.font = DSTypography.uiSubheadline.withWeight(.medium)
        valueLabel.text = value
        valueLabel.textAlignment = .right
        
        hStack.addArrangedSubview(titleLabel)
        hStack.addArrangedSubview(valueLabel)
        
        additionalInfoStackView.addArrangedSubview(hStack)
    }
}

private extension UIFont {
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        var attributes = fontDescriptor.fontAttributes
        var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]
        traits[.weight] = weight
        attributes[.name] = nil
        attributes[.traits] = traits
        attributes[.family] = nil
        let descriptor = fontDescriptor.addingAttributes(attributes)
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}
