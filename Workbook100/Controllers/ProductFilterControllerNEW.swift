//
//  ProductFilterControllerNEW.swift
//  Workbook100
//
//  Created by Eddie Char on 2/25/22.
//

import UIKit

protocol ProductFilterControllerNEWDelegate {
    func applyTapped(selectedCollection: String,
                     selectedNew: Int,
                     selectedEssential: Int,
                     selectedLaunchSeason: [String],
                     selectedProductCategory: [String],
                     selectedProductType: [String],
                     selectedProductSubtype: [String],
                     selectedDivision: [String],
                     selectedProductClass: [String],
                     selectedDescription: String,
                     selectedProductDetails: String)
}

class ProductFilterCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set(newFrame) {
            var frame = newFrame
            frame.size.width = ContainerViewController.expandDistance - 40
            super.frame = frame
        }
    }
}


class ProductFilterControllerNEW: UITableViewController, ProductSubFilterControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var labelCollection: UILabel!
    @IBOutlet weak var segmentedNew: UISegmentedControl!
    @IBOutlet weak var segmentedEssential: UISegmentedControl!
    @IBOutlet weak var labelLaunchSeason: UILabel!
    @IBOutlet weak var labelProductCategory: UILabel!
    @IBOutlet weak var labelProductType: UILabel!
    @IBOutlet weak var labelProductSubtype: UILabel!
    @IBOutlet weak var labelDivision: UILabel!
    @IBOutlet weak var labelProductClass: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelProductDetails: UILabel!
    
    var selectedCollection: String! { didSet { labelCollection.text = selectedCollection }}
    var selectedLaunchSeason: [String]! { didSet { labelLaunchSeason.text = selectedLaunchSeason.joined(separator: K.ProductFilter.multiSeparator + " ") }}
    var selectedProductCategory: [String]! { didSet { labelProductCategory.text = selectedProductCategory.joined(separator: K.ProductFilter.multiSeparator + " ") }}
    var selectedProductType: [String]! { didSet { labelProductType.text = selectedProductType.joined(separator: K.ProductFilter.multiSeparator + " ") }}
    var selectedProductSubtype: [String]! { didSet { labelProductSubtype.text = selectedProductSubtype.joined(separator: K.ProductFilter.multiSeparator + " ") }}
    var selectedDivision: [String]! { didSet { labelDivision.text = selectedDivision.joined(separator: K.ProductFilter.multiSeparator + " ") }}
    var selectedProductClass: [String]! { didSet { labelProductClass.text = selectedProductClass.joined(separator: K.ProductFilter.multiSeparator + " ") }}
    var selectedDescription: String! { didSet { labelDescription.text = selectedDescription }}
    var selectedProductDetails: String! { didSet { labelProductDetails.text = selectedProductDetails }}
    
    var selectedSection: Int?
    var delegate: ProductFilterControllerNEWDelegate?
    
    enum FilterItem: Int {
        case collection = 0,
             new,
             essential,
             launchSeason,
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
        self.selectedCollection = clear ? K.ProductFilter.wildcard : K.ProductFilter.selectedCollection
        self.segmentedNew.selectedSegmentIndex = clear ? K.ProductFilter.segementedBoth : K.ProductFilter.selectedNew
        self.segmentedEssential.selectedSegmentIndex = clear ? K.ProductFilter.segementedBoth : K.ProductFilter.selectedEssential
        self.selectedLaunchSeason = clear ? [K.ProductFilter.wildcard] : K.ProductFilter.selectedLaunchSeason
        self.selectedProductCategory = clear ? [K.ProductFilter.wildcard] : K.ProductFilter.selectedProductCategory
        self.selectedProductType = clear ? [K.ProductFilter.wildcard] : K.ProductFilter.selectedProductType
        self.selectedProductSubtype = clear ? [K.ProductFilter.wildcard] : K.ProductFilter.selectedProductSubtype
        self.selectedDivision = clear ? [K.ProductFilter.wildcard] : K.ProductFilter.selectedDivision
        self.selectedProductClass = clear ? [K.ProductFilter.wildcard] : K.ProductFilter.selectedProductClass
        self.selectedDescription = clear ? K.ProductFilter.wildcard : K.ProductFilter.selectedDescription
        self.selectedProductDetails = clear ? K.ProductFilter.wildcard : K.ProductFilter.selectedProductDetails
    }
    
    
    // MARK: - Navigation
    
    @IBAction func applyButtonTapped(_ sender: UIButton) {
        self.delegate?.applyTapped(selectedCollection: self.selectedCollection,
                                   selectedNew: self.segmentedNew.selectedSegmentIndex,
                                   selectedEssential: self.segmentedEssential.selectedSegmentIndex,
                                   selectedLaunchSeason: self.selectedLaunchSeason,
                                   selectedProductCategory: self.selectedProductCategory,
                                   selectedProductType: self.selectedProductType,
                                   selectedProductSubtype: self.selectedProductSubtype,
                                   selectedDivision: self.selectedDivision,
                                   selectedProductClass: self.selectedProductClass,
                                   selectedDescription: self.selectedDescription,
                                   selectedProductDetails: self.selectedProductDetails
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
            
            controller.navigationItem.title = "Select"
            controller.delegate = self
            self.selectedSection = indexPath.section
            
            switch self.selectedSection {
            case FilterItem.collection.rawValue:
                controller.selections = K.ProductFilter.selectionCollection
                controller.selectedItems = [self.selectedCollection]
                controller.navigationItem.title! += " Collection"
            case FilterItem.launchSeason.rawValue:
                controller.selections = K.ProductFilter.selectionLaunchSeason
                controller.selectedItems = self.selectedLaunchSeason
                controller.navigationItem.title! += " Launch Season"
            case FilterItem.productCategory.rawValue:
                controller.selections = K.ProductFilter.selectionProductCategory
                controller.selectedItems = self.selectedProductCategory
                controller.navigationItem.title! += " Product Category"
            case FilterItem.productType.rawValue:
                if let selectedProductCategory = K.ProductFilter.categories.search(self.selectedProductCategory.joined()) {
                    controller.selections = [K.ProductFilter.wildcard] + selectedProductCategory.getChildren()
                }
                else {
                    controller.selections = K.ProductFilter.selectionProductType
                }
                
                controller.selectedItems = self.selectedProductType
                controller.navigationItem.title! += " Product Type"
            case FilterItem.productSubtype.rawValue:
                if let selectedProductCategory = K.ProductFilter.categories.search(self.selectedProductCategory.joined()),
                   let selectedProductType = selectedProductCategory.children.first(where: { $0.value == self.selectedProductType.joined() }) {
                    controller.selections = [K.ProductFilter.wildcard] + selectedProductType.getChildren()
                }
                else {
                    controller.selections = K.ProductFilter.selectionProductSubtype
                }
                
                controller.selectedItems = self.selectedProductSubtype
                controller.navigationItem.title! += " Product Subtype"
            case FilterItem.division.rawValue:
                controller.selections = K.ProductFilter.selectionDivision
                controller.selectedItems = self.selectedDivision
                controller.navigationItem.title! += " Division"
            case FilterItem.productClass.rawValue:
                if let selectedProductCategory = K.ProductFilter.categories.search(self.selectedProductCategory.joined()),
                   let selectedProductType = selectedProductCategory.children.first(where: { $0.value == self.selectedProductType.joined() }),
                   let selectedProductSubtype = selectedProductType.children.first(where: { $0.value == self.selectedProductSubtype.joined() }) {
                    controller.selections = [K.ProductFilter.wildcard] + selectedProductSubtype.getChildren()
                }
                else {
                    controller.selections = K.ProductFilter.selectionProductClass
                }
                
                controller.selectedItems = self.selectedProductClass
                controller.navigationItem.title! += " Product Class"
            case FilterItem.description.rawValue:
                controller.selections = K.ProductFilter.selectionDescription
                controller.selectedItems = [self.selectedDescription]
                controller.navigationItem.title! += " Description"
            case FilterItem.productDetails.rawValue:
                controller.selections = K.ProductFilter.selectionProductDetails
                controller.selectedItems = [self.selectedProductDetails]
                controller.navigationItem.title! += " Product Details"
            default:
                controller.selectedItems = ["Wrong selection!"]
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
    func didSelectItems(selectedItems: [String]) {
        switch self.selectedSection {
        case FilterItem.collection.rawValue: self.selectedCollection = selectedItems[0]
        case FilterItem.launchSeason.rawValue: self.selectedLaunchSeason = selectedItems
        case FilterItem.productCategory.rawValue: self.selectedProductCategory = selectedItems
        case FilterItem.productType.rawValue: self.selectedProductType = selectedItems
        case FilterItem.productSubtype.rawValue: self.selectedProductSubtype = selectedItems
        case FilterItem.division.rawValue: self.selectedDivision = selectedItems
        case FilterItem.productClass.rawValue: self.selectedProductClass = selectedItems
        case FilterItem.description.rawValue: self.selectedDescription = selectedItems[0]
        case FilterItem.productDetails.rawValue: self.selectedProductDetails = selectedItems[0]
        default: print("Wrong selection!")
        }
    }
}
