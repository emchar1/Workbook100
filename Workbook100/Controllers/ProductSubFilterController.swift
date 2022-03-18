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
    func didSelectItem(selectedItem: String)
}

class ProductSubFilterController: UITableViewController {
    @IBOutlet weak var singleMultiButton: UIBarButtonItem!

    var selections: [String] = []
    var selectedItem: String!
    var delegate: ProductSubFilterControllerDelegate?
    var isSingle = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.title = "Product Filters"
    }
    
    
    @IBAction func singleMultiPressed(_ sender: UIBarButtonItem) {
        isSingle = !isSingle
        
        singleMultiButton.title = isSingle ? "Multi" : "Done"
    }
    
    
    // MARK: - Table View Data Source, Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubFilterCell", for: indexPath) as! ProductSubFilterCell

        cell.label.text = selections[indexPath.row]
        cell.accessoryType = selectedItem == selections[indexPath.row] ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = selections[indexPath.row]
        
        delegate?.didSelectItem(selectedItem: selectedItem)
        
        tableView.deselectRow(at: indexPath, animated: true)
//        dismiss(animated: true, completion: nil)
    }
    
    
}
