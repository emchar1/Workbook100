//
//  ProductSubFilterController.swift
//  Workbook100
//
//  Created by Eddie Char on 2/25/22.
//

import UIKit

class ProductSubFilterCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


protocol ProductSubFilterControllerDelegate {
    func didSelectItems(selectedItems: [String])
}

class ProductSubFilterController: UITableViewController {
    @IBOutlet weak var singleMultiButton: UIBarButtonItem!

    var selections: [String] = []
    var selectedItems: [String]!
    var delegate: ProductSubFilterControllerDelegate?
    private var isSingle = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func singleMultiPressed(_ sender: UIBarButtonItem) {
        guard isSingle else {
            delegate?.didSelectItems(selectedItems: selectedItems)
            dismiss(animated: true, completion: nil)
            return
        }

        
        isSingle = false
        singleMultiButton.title = "Done"

        selectedItems = selectedItems.filter { $0 != K.ProductFilter.wildcard }
        
        if selectedItems.count <= 0 {
            singleMultiButton.isEnabled = false
        }

        tableView.reloadData()
    }
    
    
    // MARK: - Table View Data Source, Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubFilterCell", for: indexPath) as! ProductSubFilterCell
        let selectedItemsFlat = K.ProductFilter.multiSeparator + selectedItems.joined(separator: K.ProductFilter.multiSeparator) + K.ProductFilter.multiSeparator

        cell.label.text = selections[indexPath.row]
        cell.accessoryType = selectedItemsFlat.contains(K.ProductFilter.multiSeparator + selections[indexPath.row] + K.ProductFilter.multiSeparator) ? .checkmark : .none
        cell.selectionStyle = isSingle ? .default : .none

        if !isSingle && indexPath.row == 0 {
            cell.label.text = "Multi-Select Mode"
            cell.label.textColor = .secondaryLabel
            cell.label.textAlignment = .center
        }
        else {
            cell.label.textColor = .label
            cell.label.textAlignment = .natural
        }
            
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSingle {
            selectedItems = [selections[indexPath.row]]
            
            delegate?.didSelectItems(selectedItems: selectedItems)
            dismiss(animated: true, completion: nil)
        }
        else {
            //Wildcard not selectable in Multi-mode
            guard indexPath.row > 0 else { return }
            
            
            //Toggle adding/removing a selectedItem
            if selectedItems.contains(selections[indexPath.row]) {
                //i.e. remove the selected item
                selectedItems = selectedItems.filter { $0 != selections[indexPath.row] }
            }
            else {
                selectedItems.append(selections[indexPath.row])
            }

            singleMultiButton.isEnabled = selectedItems.count <= 0 ? false : true
            selectedItems.sort()
            tableView.reloadData()
        }
    }
    
    
}
