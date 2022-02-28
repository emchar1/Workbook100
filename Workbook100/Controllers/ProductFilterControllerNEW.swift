//
//  ProductFilterControllerNEW.swift
//  Workbook100
//
//  Created by Eddie Char on 2/25/22.
//

import UIKit

protocol ProductFilterControllerNEWDelegate {
    func applyTapped(selectedDivision: String,
                     selectedLaunchSeason: String,
                     selectedProductCategory: String,
                     selectedProductType: String,
                     selectedProductSubtype: String)
}


class ProductFilterControllerNEW: UITableViewController, ProductSubFilterControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var labelDivision: UILabel!
    @IBOutlet weak var labelLaunchSeason: UILabel!
    @IBOutlet weak var labelProductCategory: UILabel!
    @IBOutlet weak var labelProductType: UILabel!
    @IBOutlet weak var labelProductSubtype: UILabel!
    
    var selectedDivision: String! { didSet {labelDivision.text = selectedDivision}}
    var selectedLaunchSeason: String! { didSet { labelLaunchSeason.text = selectedLaunchSeason}}
    var selectedProductCategory: String! { didSet { labelProductCategory.text = selectedProductCategory}}
    var selectedProductType: String! { didSet { labelProductType.text = selectedProductType}}
    var selectedProductSubtype: String! { didSet { labelProductSubtype.text = selectedProductSubtype}}
    
    var selectedSection: Int?
    var delegate: ProductFilterControllerNEWDelegate?
    
    enum FilterItem: Int {
        case division = 0, launchSeason, productCategory, productType, productSubtype, applyClearButtons
    }
    
    
    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetFilters()
    }
    
    private func resetFilters(clear: Bool = false) {
        selectedDivision = clear ? K.ProductFilterSelection.wildcard : K.ProductFilterSelection.selectedDivision
        selectedLaunchSeason = clear ? K.ProductFilterSelection.wildcard : K.ProductFilterSelection.selectedLaunchSeason
        selectedProductCategory = clear ? K.ProductFilterSelection.wildcard : K.ProductFilterSelection.selectedProductCategory
        selectedProductType = clear ? K.ProductFilterSelection.wildcard : K.ProductFilterSelection.selectedProductType
        selectedProductSubtype = clear ? K.ProductFilterSelection.wildcard : K.ProductFilterSelection.selectedProductSubtype
        
//        labelDivision.text = selectedDivision
//        labelLaunchSeason.text = selectedLaunchSeason
//        labelProductCategory.text = selectedProductCategory
//        labelProductType.text = selectedProductType
//        labelProductSubtype.text = selectedProductSubtype
    }
    
    
    // MARK: - Navigation
    
    @IBAction func applyButtonTapped(_ sender: UIButton) {
        delegate?.applyTapped(selectedDivision: selectedDivision,
                              selectedLaunchSeason: selectedLaunchSeason,
                              selectedProductCategory: selectedProductCategory,
                              selectedProductType: selectedProductType,
                              selectedProductSubtype: selectedProductSubtype)
    }
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        resetFilters(clear: true)
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        //Cancel button from the ProductSubFilterController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "didSelectFilter" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let nc = segue.destination as! UINavigationController
            let vc = nc.topViewController as! ProductSubFilterController
            
            vc.navigationItem.title = "Select "
            vc.delegate = self
            selectedSection = indexPath.section
            
            switch selectedSection {
            case FilterItem.division.rawValue:
                vc.selections = K.ProductFilterSelection.selectionDivision
                vc.selectedItem = selectedDivision
                vc.navigationItem.title! += "Division"
            case FilterItem.launchSeason.rawValue:
                vc.selections = K.ProductFilterSelection.selectionLaunchSeason
                vc.selectedItem = selectedLaunchSeason
                vc.navigationItem.title! += "Launch Season"
            case FilterItem.productCategory.rawValue:
                vc.selections = K.ProductFilterSelection.selectionProductCategory
                vc.selectedItem = selectedProductCategory
                vc.navigationItem.title! += "Product Category"
            case FilterItem.productType.rawValue:
                vc.selections = K.ProductFilterSelection.selectionProductType
                vc.selectedItem = selectedProductType
                vc.navigationItem.title! += "Product Type"
            case FilterItem.productSubtype.rawValue:
                vc.selections = K.ProductFilterSelection.selectionProductSubtype
                vc.selectedItem = selectedProductSubtype
                vc.navigationItem.title! += "Product Subtype"
            default: print("Wrong selection")
            }
        }
    }

    
    // MARK: - Table View Data Source, Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == FilterItem.applyClearButtons.rawValue {
            return 100
        }
        
        return 40
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section < FilterItem.applyClearButtons.rawValue {
            performSegue(withIdentifier: "didSelectFilter", sender: nil)
        }
        
        //Do the deselect AFTER everthing else!!!
        tableView.deselectRow(at: indexPath, animated: true)
    }

}


// MARK: - Product Sub Filter Controller Delegate

extension ProductFilterControllerNEW {
    func didSelectItem(selectedItem: String) {
        switch selectedSection {
        case FilterItem.division.rawValue:
            selectedDivision = selectedItem
//            labelDivision.text = selectedItem
        case FilterItem.launchSeason.rawValue:
            selectedLaunchSeason = selectedItem
//            labelLaunchSeason.text = selectedItem
        case FilterItem.productCategory.rawValue:
            selectedProductCategory = selectedItem
//            labelProductCategory.text = selectedItem
        case FilterItem.productType.rawValue:
            selectedProductType = selectedItem
//            labelProductType.text = selectedItem
        case FilterItem.productSubtype.rawValue:
            selectedProductSubtype = selectedItem
//            labelProductSubtype.text = selectedItem
        default: print("Wrong selection")
        }
    }
}
