//
//  ProductListController.swift
//  Workbook100
//
//  Created by Eddie Char on 5/6/22.
//

import UIKit

protocol ProductListControllerDelegate {
    func didSelectItem(item: CollectionModel)
}

class ProductListController: UIViewController {
    let tableView = UITableView()
    
    var delegate: ProductListControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductListCell.self, forCellReuseIdentifier: ProductListCell.reuseID)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: view.topAnchor),
                                     tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
                                     view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)])
    }
}

extension ProductListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return K.getFilteredItemsIfFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductListCell.reuseID, for: indexPath) as! ProductListCell
        
        cell.label.text = K.getFilteredItemsIfFiltered[indexPath.row].skuCode
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectItem(item: K.getFilteredItemsIfFiltered[indexPath.row])
        dismiss(animated: true)
    }
}
