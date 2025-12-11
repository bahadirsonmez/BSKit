//
//  MovieTableViewCell.swift
//  DemoProject
//
//  Created by Bahadir Sonmez on 23.12.2025.
//

import UIKit
import BSUIKit
import DemoNetwork
import DemoDesignSystem

final class MovieTableViewCell: UITableViewCell, ConfigurableCell {
    
    typealias Model = Movie
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .top
        stack.spacing = DSSpacing.sm
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let posterImageView: CachedImageView = {
        let imageView = CachedImageView(placeholder: UIImage(systemName: "movieclipping"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = DSSpacing.xs
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingView: StatItemView = {
        let view = StatItemView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(posterImageView)
        contentStackView.addArrangedSubview(infoStackView)
        
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(releaseDateLabel)
        infoStackView.addArrangedSubview(ratingView)
        infoStackView.addArrangedSubview(overviewLabel)
        
        containerView.applyCardStyle()
        posterImageView.applyPosterStyle()
        
        titleLabel.applyStyle(DSTypography.uiHeadline)
        releaseDateLabel.applyStyle(DSTypography.uiCaption, color: DSColor.uiTextSecondary)
        overviewLabel.applyStyle(DSTypography.uiCaption, color: DSColor.uiTextSecondary)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DSSpacing.xs),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DSSpacing.md),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DSSpacing.md),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DSSpacing.xs),
            
            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -DSSpacing.sm),
            contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            infoStackView.topAnchor.constraint(equalTo: contentStackView.topAnchor, constant: DSSpacing.xs),
            infoStackView.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: -DSSpacing.xs)
        ])
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        releaseDateLabel.text = movie.formattedReleaseDate
        overviewLabel.text = movie.overview
        posterImageView.loadImage(from: movie.posterURL)
        
        if let rating = movie.formattedRating {
            ratingView.isHidden = false
            ratingView.configure(icon: "star.fill", value: rating, color: DSColor.uiRating)
        } else {
            ratingView.isHidden = true
        }
    }
}
