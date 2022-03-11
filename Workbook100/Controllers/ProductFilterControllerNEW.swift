//
//  ProductFilterControllerNEW.swift
//  Workbook100
//
//  Created by Eddie Char on 2/25/22.
//

import UIKit

protocol ProductFilterControllerNEWDelegate {
    func applyTapped(selectedNew: Int,
                     selectedEssential: Int,
                     selectedSeasonsCarried: String,
                     selectedProductCategory: String,
                     selectedProductType: String,
                     selectedProductSubtype: String,
                     selectedDivision: String,
                     selectedProductClass: String,
                     selectedDescription: String,
                     selectedProductDetails: String)
}


class ProductFilterControllerNEW: UITableViewController, ProductSubFilterControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var segmentedNew: UISegmentedControl!
    @IBOutlet weak var segmentedEssential: UISegmentedControl!
    @IBOutlet weak var labelSeasonsCarried: UILabel!
    @IBOutlet weak var labelProductCategory: UILabel!
    @IBOutlet weak var labelProductType: UILabel!
    @IBOutlet weak var labelProductSubtype: UILabel!
    @IBOutlet weak var labelDivision: UILabel!
    @IBOutlet weak var labelProductClass: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelProductDetails: UILabel!
    
    var selectedSeasonsCarried: String! { didSet { labelSeasonsCarried.text = selectedSeasonsCarried}}
    var selectedProductCategory: String! { didSet { labelProductCategory.text = selectedProductCategory}}
    var selectedProductType: String! { didSet { labelProductType.text = selectedProductType}}
    var selectedProductSubtype: String! { didSet { labelProductSubtype.text = selectedProductSubtype}}
    var selectedDivision: String! { didSet {labelDivision.text = selectedDivision}}
    var selectedProductClass: String! { didSet { labelProductClass.text = selectedProductClass}}
    var selectedDescription: String! { didSet { labelDescription.text = selectedDescription}}
    var selectedProductDetails: String! { didSet { labelProductDetails.text = selectedProductDetails}}
    
    var selectedSection: Int?
    var delegate: ProductFilterControllerNEWDelegate?
    
    enum FilterItem: Int {
        case new = 0,
             essential,
             seasonsCarried,
             productCategory,
             productType,
             productSubtype,
             division,
             productClass,
             description,
             productDetails,
             applyClearButtons
    }
    
    
    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetFilters()
    }
    
    private func resetFilters(clear: Bool = false) {
        segmentedNew.selectedSegmentIndex = clear ? K.ProductFilter.segementedBoth : K.ProductFilter.selectedNew
        segmentedEssential.selectedSegmentIndex = clear ? K.ProductFilter.segementedBoth : K.ProductFilter.selectedEssential
        selectedSeasonsCarried = clear ? K.ProductFilter.wildcard : K.ProductFilter.selectedSeasonsCarried
        selectedProductCategory = clear ? K.ProductFilter.wildcard : K.ProductFilter.selectedProductCategory
        selectedProductType = clear ? K.ProductFilter.wildcard : K.ProductFilter.selectedProductType
        selectedProductSubtype = clear ? K.ProductFilter.wildcard : K.ProductFilter.selectedProductSubtype
        selectedDivision = clear ? K.ProductFilter.wildcard : K.ProductFilter.selectedDivision
        selectedProductClass = clear ? K.ProductFilter.wildcard : K.ProductFilter.selectedProductClass
        selectedDescription = clear ? K.ProductFilter.wildcard : K.ProductFilter.selectedDescription
        selectedProductDetails = clear ? K.ProductFilter.wildcard : K.ProductFilter.selectedProductDetails
    }
    
    
    // MARK: - Navigation
    
    @IBAction func applyButtonTapped(_ sender: UIButton) {
        delegate?.applyTapped(selectedNew: segmentedNew.selectedSegmentIndex,
                              selectedEssential: segmentedEssential.selectedSegmentIndex,
                              selectedSeasonsCarried: selectedSeasonsCarried,
                              selectedProductCategory: selectedProductCategory,
                              selectedProductType: selectedProductType,
                              selectedProductSubtype: selectedProductSubtype,
                              selectedDivision: selectedDivision,
                              selectedProductClass: selectedProductClass,
                              selectedDescription: selectedDescription,
                              selectedProductDetails: selectedProductDetails
        )
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
            case FilterItem.seasonsCarried.rawValue:
                controller.selections = K.ProductFilter.selectionSeasonsCarried
                controller.selectedItem = selectedSeasonsCarried
                controller.navigationItem.title! += "Seasons Carried"
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
            case FilterItem.division.rawValue:
                controller.selections = K.ProductFilter.selectionDivision
                controller.selectedItem = selectedDivision
                controller.navigationItem.title! += "Division"
            case FilterItem.productClass.rawValue:
                controller.selections = K.ProductFilter.selectionProductClass
                controller.selectedItem = selectedProductClass
                controller.navigationItem.title! += "Product Class"
            case FilterItem.description.rawValue:
                controller.selections = K.ProductFilter.selectionDescription
                controller.selectedItem = selectedDescription
                controller.navigationItem.title! += "Description"
            case FilterItem.productDetails.rawValue:
                controller.selections = K.ProductFilter.selectionProductDetails
                controller.selectedItem = selectedProductDetails
                controller.navigationItem.title! += "Product Details"
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
        if indexPath.section != FilterItem.new.rawValue &&
            indexPath.section != FilterItem.essential.rawValue &&
            indexPath.section != FilterItem.applyClearButtons.rawValue {
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
        case FilterItem.seasonsCarried.rawValue: selectedSeasonsCarried = selectedItem
        case FilterItem.productCategory.rawValue: selectedProductCategory = selectedItem
        case FilterItem.productType.rawValue: selectedProductType = selectedItem
        case FilterItem.productSubtype.rawValue: selectedProductSubtype = selectedItem
        case FilterItem.division.rawValue: selectedDivision = selectedItem
        case FilterItem.productClass.rawValue: selectedProductClass = selectedItem
        case FilterItem.description.rawValue: selectedDescription = selectedItem
        case FilterItem.productDetails.rawValue: selectedProductDetails = selectedItem
        default: print("Wrong selection!")
        }
    }
}
