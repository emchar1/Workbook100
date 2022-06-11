//
//  ProductListController.swift
//  Workbook100
//
//  Created by Eddie Char on 5/6/22.
//

import UIKit

protocol ProductListControllerDelegate {
    func didSelect(item: CollectionModel)
}

class ProductListController: UIViewController {
    let tableView = UITableView()
    var delegate: ProductListControllerDelegate?
    var allItems: [CollectionModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allItems = K.items.filter { model in
            model.lineList == K.ProductFilter.wildcard
        }
        
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


// MARK: - Table View Data Source, Delegate

extension ProductListController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return K.ProductFilter.selectionProductCategory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return K.getFilteredItemsIfFiltered.count
        
        guard !K.ProductFilter.selectionProductCategory.isEmpty else { return 0 }
        
        let itemForCategory = allItems.filter {
            $0.productCategory == K.ProductFilter.selectionProductCategory[section]
        }

        return itemForCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !K.ProductFilter.selectionProductCategory.isEmpty else { return UITableViewCell() }

        let itemForCategory = allItems.filter {
            $0.productCategory == K.ProductFilter.selectionProductCategory[indexPath.section]
        }
        
        guard (itemForCategory[indexPath.row].productCategory.count) > 0 else { return UITableViewCell() }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductListCell.reuseID, for: indexPath) as! ProductListCell
        
        cell.labelSKU.text = itemForCategory[indexPath.row].skuCode
        cell.labelDesc.text = itemForCategory[indexPath.row].productCategory + " - " + itemForCategory[indexPath.row].productNameDescription + " - " + itemForCategory[indexPath.row].productNameDescriptionSecondary
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemForCategory = allItems.filter {
            $0.productCategory == K.ProductFilter.selectionProductCategory[indexPath.section]
        }

        delegate?.didSelect(item: itemForCategory[indexPath.row])
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard !K.ProductFilter.selectionProductCategory.isEmpty else { return nil }
        
//        let itemForCategory = allItems.filter {
//            $0.productCategory == K.ProductFilter.selectionProductCategory[section]
//        }
        
        return K.ProductFilter.selectionProductCategory[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
