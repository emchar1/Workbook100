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
                     selectedProductSubtype: String,
                     selectedNew: Int,
                     selectedEssential: Int)
}


class ProductFilterControllerNEW: UITableViewController, ProductSubFilterControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var labelDivision: UILabel!
    @IBOutlet weak var labelLaunchSeason: UILabel!
    @IBOutlet weak var labelProductCategory: UILabel!
    @IBOutlet weak var labelProductType: UILabel!
    @IBOutlet weak var labelProductSubtype: UILabel!
    @IBOutlet weak var segmentedNew: UISegmentedControl!
    @IBOutlet weak var segmentedEssential: UISegmentedControl!
    
    var selectedDivision: String! { didSet {labelDivision.text = selectedDivision}}
    var selectedLaunchSeason: String! { didSet { labelLaunchSeason.text = selectedLaunchSeason}}
    var selectedProductCategory: String! { didSet { labelProductCategory.text = selectedProductCategory}}
    var selectedProductType: String! { didSet { labelProductType.text = selectedProductType}}
    var selectedProductSubtype: String! { didSet { labelProductSubtype.text = selectedProductSubtype}}
    
    var selectedSection: Int?
    var delegate: ProductFilterControllerNEWDelegate?
    
    enum FilterItem: Int {
        case division = 0,
             launchSeason,
             productCategory,
             productType,
             productSubtype,
             new,
             essential,
             applyClearButtons
    }
    
    
    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetFilters()
    }
    
    private func resetFilters(clear: Bool = false) {
        selectedDivision = clear ? K.ProductFilter.wildcard : K.ProductFilter.selectedDivision
        selectedLaunchSeason = clear ? K.ProductFilter.wildcard : K.ProductFilter.selectedLaunchSeason
        selectedProductCategory = clear ? K.ProductFilter.wildcard : K.ProductFilter.selectedProductCategory
        selectedProductType = clear ? K.ProductFilter.wildcard : K.ProductFilter.selectedProductType
        selectedProductSubtype = clear ? K.ProductFilter.wildcard : K.ProductFilter.selectedProductSubtype
        segmentedNew.selectedSegmentIndex = clear ? K.ProductFilter.segementedBoth : K.ProductFilter.selectedNew
        segmentedEssential.selectedSegmentIndex = clear ? K.ProductFilter.segementedBoth : K.ProductFilter.selectedEssential
    }
    
    
    // MARK: - Navigation
    
    @IBAction func applyButtonTapped(_ sender: UIButton) {
        delegate?.applyTapped(selectedDivision: selectedDivision,
                              selectedLaunchSeason: selectedLaunchSeason,
                              selectedProductCategory: selectedProductCategory,
                              selectedProductType: selectedProductType,
                              selectedProductSubtype: selectedProductSubtype,
                              selectedNew: segmentedNew.selectedSegmentIndex,
                              selectedEssential: segmentedEssential.selectedSegmentIndex)
    }
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        resetFilters(clear: true)
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        //Cancel button from the ProductSubFilterController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "didSelectFilter" {
            guard let indexPath = tableView.indexPathForSelectedRow else {
                print("No indexPath found in prepare(for: sender:) in ProductFilterControllerNEW.")
                return
            }
            
            let nc = segue.destination as! UINavigationController
            let controller = nc.topViewController as! ProductSubFilterController
            
            controller.navigationItem.title = "Select "
            controller.delegate = self
            selectedSection = indexPath.section
            
            switch selectedSection {
            case FilterItem.division.rawValue:
                controller.selections = K.ProductFilter.selectionDivision
                controller.selectedItem = selectedDivision
                controller.navigationItem.title! += "Division"
            case FilterItem.launchSeason.rawValue:
                controller.selections = K.ProductFilter.selectionLaunchSeason
                controller.selectedItem = selectedLaunchSeason
                controller.navigationItem.title! += "Launch Season"
            case FilterItem.productCategory.rawValue:
                controller.selections = K.ProductFilter.selectionProductCategory
                controller.selectedItem = selectedProductCategory
                controller.navigationItem.title! += "Product Category"
            case FilterItem.productType.rawValue:
                controller.selections = K.ProductFilter.selectionProductType
                controller.selectedItem = selectedProductType
                controller.navigationItem.title! += "Product Type"
            case FilterItem.productSubtype.rawValue:
                controller.selections = K.ProductFilter.selectionProductSubtype
                controller.selectedItem = selectedProductSubtype
                controller.navigationItem.title! += "Product Subtype"
            default:
                controller.selectedItem = "Wrong selection!"
                print("Wrong selection!")
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
        if indexPath.section < FilterItem.new.rawValue {
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
        case FilterItem.division.rawValue: selectedDivision = selectedItem
        case FilterItem.launchSeason.rawValue: selectedLaunchSeason = selectedItem
        case FilterItem.productCategory.rawValue: selectedProductCategory = selectedItem
        case FilterItem.productType.rawValue: selectedProductType = selectedItem
        case FilterItem.productSubtype.rawValue: selectedProductSubtype = selectedItem
        default: print("Wrong selection!")
        }
    }
}
