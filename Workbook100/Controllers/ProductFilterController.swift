//
//  ProductFilterController.swift
//  Workbook100
//
//  Created by Eddie Char on 2/25/22.
//

import UIKit

protocol ProductFilterControllerDelegate {
    func applyTapped(selectedLineList: String,
                     selectedNew: Int,
                     selectedEssential: Int,
                     selectedCollection: String,
                     selectedSeasonsCarried: [String],
                     selectedProductCategory: [String],
                     selectedProductType: [String],
                     selectedProductSubtype: [String],
                     selectedDivision: [String],
                     selectedProductClass: [String],
                     selectedProductDetails: [String])
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


class ProductFilterController: UITableViewController, ProductSubFilterControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var labelLineList: UILabel!
    @IBOutlet weak var segmentedNew: UISegmentedControl!
    @IBOutlet weak var segmentedEssential: UISegmentedControl!
    @IBOutlet weak var labelCollection: UILabel!
    @IBOutlet weak var labelSeasonsCarried: UILabel!
    @IBOutlet weak var labelProductCategory: UILabel!
    @IBOutlet weak var labelProductType: UILabel!
    @IBOutlet weak var labelProductSubtype: UILabel!
    @IBOutlet weak var labelDivision: UILabel!
    @IBOutlet weak var labelProductClass: UILabel!
    @IBOutlet weak var labelProductDetails: UILabel!
    
    let s = "; "
    var selectedLineList: String! { didSet { labelLineList.text = selectedLineList }}
    var selectedCollection: String! { didSet { labelCollection.text = selectedCollection }}
    var selectedSeasonsCarried: [String]! { didSet { labelSeasonsCarried.text = selectedSeasonsCarried.joined(separator: s) }}
    var selectedProductCategory: [String]! { didSet { labelProductCategory.text = selectedProductCategory.joined(separator: s) }}
    var selectedProductType: [String]! { didSet { labelProductType.text = selectedProductType.joined(separator: s) }}
    var selectedProductSubtype: [String]! { didSet { labelProductSubtype.text = selectedProductSubtype.joined(separator: s) }}
    var selectedDivision: [String]! { didSet { labelDivision.text = selectedDivision.joined(separator: s) }}
    var selectedProductClass: [String]! { didSet { labelProductClass.text = selectedProductClass.joined(separator: s) }}
    var selectedProductDetails: [String]! { didSet { labelProductDetails.text = selectedProductDetails.joined(separator: s) }}
    
    var selectedSection: Int?
    var delegate: ProductFilterControllerDelegate?
    
    enum FilterItem: Int {
        case lineList = 0,
             new,
             essential,
             collection,
             seasonsCarried,
             productCategory,
             productType,
             productSubtype,
             division,
             productClass,
             productDetails,
             applyClearButtons
    }
    
    
    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetFilters()
    }
    
    private func resetFilters(clear: Bool = false) {
        self.selectedLineList = clear ? K.ProductFilter.lineListDefault : K.ProductFilter.selectedLineList
        self.segmentedNew.selectedSegmentIndex = clear ? K.ProductFilter.segementedBoth : K.ProductFilter.selectedNew
        self.segmentedEssential.selectedSegmentIndex = clear ? K.ProductFilter.segementedBoth : K.ProductFilter.selectedEssential
        self.selectedCollection = clear ? K.ProductFilter.wildcard : K.ProductFilter.selectedCollection
        self.selectedSeasonsCarried = clear ? [K.ProductFilter.wildcard] : K.ProductFilter.selectedSeasonsCarried
        self.selectedProductCategory = clear ? [K.ProductFilter.wildcard] : K.ProductFilter.selectedProductCategory
        self.selectedProductType = clear ? [K.ProductFilter.wildcard] : K.ProductFilter.selectedProductType
        self.selectedProductSubtype = clear ? [K.ProductFilter.wildcard] : K.ProductFilter.selectedProductSubtype
        self.selectedDivision = clear ? [K.ProductFilter.wildcard] : K.ProductFilter.selectedDivision
        self.selectedProductClass = clear ? [K.ProductFilter.wildcard] : K.ProductFilter.selectedProductClass
        self.selectedProductDetails = clear ? [K.ProductFilter.wildcard] : K.ProductFilter.selectedProductDetails
    }
    
    
    // MARK: - Navigation
    
    @IBAction func applyButtonTapped(_ sender: UIButton) {
        self.delegate?.applyTapped(selectedLineList: self.selectedLineList,
                                   selectedNew: self.segmentedNew.selectedSegmentIndex,
                                   selectedEssential: self.segmentedEssential.selectedSegmentIndex,
                                   selectedCollection: self.selectedCollection,
                                   selectedSeasonsCarried: self.selectedSeasonsCarried,
                                   selectedProductCategory: self.selectedProductCategory,
                                   selectedProductType: self.selectedProductType,
                                   selectedProductSubtype: self.selectedProductSubtype,
                                   selectedDivision: self.selectedDivision,
                                   selectedProductClass: self.selectedProductClass,
                                   selectedProductDetails: self.selectedProductDetails)
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
                print("No indexPath found in prepare(for: sender:) in ProductFilterController.")
                return
            }
            
            let nc = segue.destination as! UINavigationController
            let controller = nc.topViewController as! ProductSubFilterController
            let spinnerOffset = -controller.view.frame.height / 3
            
            controller.navigationItem.title = "Select"
            controller.delegate = self
            self.selectedSection = indexPath.section
            
            switch self.selectedSection {
            case FilterItem.lineList.rawValue:
                controller.selections = K.ProductFilter.selectionLineList
                controller.selectedItems = [self.selectedLineList]
                controller.allowsMultiSelection = false
                controller.navigationItem.title! += " Line List"
                
                if K.ProductFilter.selectionLineList.isEmpty {
                    controller.startSpinner(in: controller.view, offset: CGPoint(x: 0, y: spinnerOffset))
                }
            case FilterItem.collection.rawValue:
                controller.selections = [K.ProductFilter.wildcard] + K.ProductFilter.selectionCollection
                controller.selectedItems = [self.selectedCollection]
                controller.allowsMultiSelection = false
                controller.navigationItem.title! += " Collection"
                
                if K.ProductFilter.selectionCollection.isEmpty {
                    controller.startSpinner(in: controller.view, offset: CGPoint(x: 0, y: spinnerOffset))
                }
            case FilterItem.seasonsCarried.rawValue:
                controller.selections = [K.ProductFilter.wildcard] + K.ProductFilter.selectionSeasonsCarried
                controller.selectedItems = self.selectedSeasonsCarried
                controller.navigationItem.title! += " Seasons Carried"
                
                if K.ProductFilter.selectionSeasonsCarried.isEmpty {
                    controller.startSpinner(in: controller.view, offset: CGPoint(x: 0, y: spinnerOffset))
                }
            case FilterItem.productCategory.rawValue:
                controller.selections = [K.ProductFilter.wildcard] + K.ProductFilter.selectionProductCategory
                controller.selectedItems = self.selectedProductCategory
                controller.navigationItem.title! += " Product Category"
                
                if K.ProductFilter.selectionProductCategory.isEmpty {
                    controller.startSpinner(in: controller.view, offset: CGPoint(x: 0, y: spinnerOffset))
                }
            case FilterItem.productType.rawValue:
                if let selectedProductCategory = K.ProductFilter.categories.search(self.selectedProductCategory.joined()) {
                    controller.selections = [K.ProductFilter.wildcard] + selectedProductCategory.getChildren()
                }
                else {
                    controller.selections = [K.ProductFilter.wildcard] + K.ProductFilter.selectionProductType
                }
                
                controller.selectedItems = self.selectedProductType
                controller.navigationItem.title! += " Product Type"
                
                if K.ProductFilter.selectionProductType.isEmpty {
                    controller.startSpinner(in: controller.view, offset: CGPoint(x: 0, y: spinnerOffset))
                }
            case FilterItem.productSubtype.rawValue:
                if let selectedProductCategory = K.ProductFilter.categories.search(self.selectedProductCategory.joined()),
                   let selectedProductType = selectedProductCategory.children.first(where: { $0.value == self.selectedProductType.joined() }) {
                    controller.selections = [K.ProductFilter.wildcard] + selectedProductType.getChildren()
                }
                else {
                    controller.selections = [K.ProductFilter.wildcard] + K.ProductFilter.selectionProductSubtype
                }
                
                controller.selectedItems = self.selectedProductSubtype
                controller.navigationItem.title! += " Product Subtype"
                
                if K.ProductFilter.selectionProductSubtype.isEmpty {
                    controller.startSpinner(in: controller.view, offset: CGPoint(x: 0, y: spinnerOffset))
                }
            case FilterItem.division.rawValue:
                controller.selections = [K.ProductFilter.wildcard] + K.ProductFilter.selectionDivision
                controller.selectedItems = self.selectedDivision
                controller.navigationItem.title! += " Division"
                
                if K.ProductFilter.selectionDivision.isEmpty {
                    controller.startSpinner(in: controller.view, offset: CGPoint(x: 0, y: spinnerOffset))
                }
            case FilterItem.productClass.rawValue:
                if let selectedProductCategory = K.ProductFilter.categories.search(self.selectedProductCategory.joined()),
                   let selectedProductType = selectedProductCategory.children.first(where: { $0.value == self.selectedProductType.joined() }),
                   let selectedProductSubtype = selectedProductType.children.first(where: { $0.value == self.selectedProductSubtype.joined() }) {
                    controller.selections = [K.ProductFilter.wildcard] + selectedProductSubtype.getChildren()
                }
                else {
                    controller.selections = [K.ProductFilter.wildcard] + K.ProductFilter.selectionProductClass
                }
                
                controller.selectedItems = self.selectedProductClass
                controller.navigationItem.title! += " Product Class"
                
                if K.ProductFilter.selectionProductClass.isEmpty {
                    controller.startSpinner(in: controller.view, offset: CGPoint(x: 0, y: spinnerOffset))
                }
            case FilterItem.productDetails.rawValue:
                controller.selections = [K.ProductFilter.wildcard] + K.ProductFilter.selectionProductDetails
                controller.selectedItems = self.selectedProductDetails
                controller.navigationItem.title! += " Product Details"
                
                if K.ProductFilter.selectionProductDetails.isEmpty {
                    controller.startSpinner(in: controller.view, offset: CGPoint(x: 0, y: spinnerOffset))
                }
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

extension ProductFilterController {
    func didSelectItems(selectedItems: [String]) {
        switch self.selectedSection {
        case FilterItem.lineList.rawValue:
            self.resetFilters(clear: true)
            self.selectedLineList = selectedItems[0]
        case FilterItem.collection.rawValue: self.selectedCollection = selectedItems[0]
        case FilterItem.seasonsCarried.rawValue: self.selectedSeasonsCarried = selectedItems
        case FilterItem.productCategory.rawValue:
            self.selectedProductCategory = selectedItems
            resetFilterSpecific(productType: true, productSubtype: true, productClass: true)
        case FilterItem.productType.rawValue:
            self.selectedProductType = selectedItems
            resetFilterSpecific(productType: false, productSubtype: true, productClass: true)
        case FilterItem.productSubtype.rawValue:
            self.selectedProductSubtype = selectedItems
            resetFilterSpecific(productType: false, productSubtype: false, productClass: true)
        case FilterItem.division.rawValue: self.selectedDivision = selectedItems
        case FilterItem.productClass.rawValue: self.selectedProductClass = selectedItems
        case FilterItem.productDetails.rawValue: self.selectedProductDetails = selectedItems
        default: print("Wrong selection!")
        }
    }
    
    private func resetFilterSpecific(productType: Bool, productSubtype: Bool, productClass: Bool) {
        let resetFilters = [K.ProductFilter.wildcard]

        if productType { self.selectedProductType = resetFilters }
        if productSubtype { self.selectedProductSubtype = resetFilters }
        if productClass { self.selectedProductClass = resetFilters }
    }
}
