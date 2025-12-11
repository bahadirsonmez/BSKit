#if canImport(UIKit)
//
//  BaseCollectionView.swift
//  BSUIKit
//
//  Created by Bahadir Sonmez on 22.12.2025.
//

import UIKit

// MARK: - Base Collection View

open class BaseCollectionView<Item, Cell: UICollectionViewCell>: BaseView<[Item]>, UICollectionViewDataSource, UICollectionViewDelegate where Cell: ConfigurableCell, Cell.Model == Item {
    
    // MARK: - UI Components
    
    public lazy var layout: UICollectionViewLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        return flowLayout
    }()
    
    public lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
        cv.backgroundColor = .clear
        return cv
    }()
    
    // MARK: - Properties
    
    public var items: [Item] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var onSelect: ((Item) -> Void)?
    public var onFetchNextPage: (() -> Void)?
    
    // MARK: - Setup
    
    open override func setupUI() {
        super.setupUI()
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    open override func configure(with model: [Item]) {
        self.items = model
    }
    
    // MARK: - UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            return UICollectionViewCell()
        }
        cell.configure(with: items[indexPath.row])
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < items.count else { return }
        onSelect?(items[indexPath.item])
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == items.count - 5 {
            onFetchNextPage?()
        }
    }
}
#endif
