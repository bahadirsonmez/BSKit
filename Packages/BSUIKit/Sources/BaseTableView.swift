#if canImport(UIKit)
//
//  BaseTableView.swift
//  BSUIKit
//
//  Created by Bahadir Sonmez on 22.12.2025.
//

import UIKit

// MARK: - Base Table View

open class BaseTableView<Item, Cell: UITableViewCell>: BaseView<[Item]>, UITableViewDataSource, UITableViewDelegate where Cell: ConfigurableCell, Cell.Model == Item {
    
    // MARK: - UI Components
    
    public lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
        tv.backgroundColor = .clear
        tv.tableFooterView = UIView()
        return tv
    }()
    
    // MARK: - Properties
    
    public var items: [Item] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    public var onSelect: ((Item) -> Void)?
    public var onFetchNextPage: (() -> Void)?
    
    // MARK: - Setup
    
    open override func setupUI() {
        super.setupUI()
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    open override func configure(with model: [Item]) {
        self.items = model
    }
    
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            return UITableViewCell()
        }
        cell.configure(with: items[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < items.count else { return }
        onSelect?(items[indexPath.row])
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == items.count - 5 {
            onFetchNextPage?()
        }
    }
}
#endif
