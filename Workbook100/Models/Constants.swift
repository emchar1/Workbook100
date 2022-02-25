//
//  Constants.swift
//  Workbook100
//
//  Created by Eddie Char on 12/23/21.
//

import Foundation
import UIKit


// MARK: - Constant

struct K {
    static var items: [CollectionModel] = []
    static var filteredItems: [CollectionModel] = []
    
    struct CollectionCell {
        static var cellMultiplier: CGFloat = (UIScreen.main.traitCollection.horizontalSizeClass == .compact) ? 3 : 6
        static let padding: CGFloat = 8
        static let cornerRadius: CGFloat = 8
        static let width: CGFloat = 200
        static var height: CGFloat { width * 3 / 2 }

        static func adjustedWidth(in view: UIView) -> CGFloat {
            return view.bounds.width / cellMultiplier - (2 * padding)
            
        }        

        static func adjustedHeight(in view: UIView) -> CGFloat {
            return adjustedWidth(in: view) * 3 / 2
        }
    }
    
    struct ProductFilterSelection {
        static let wildcard = "[All]"
        
        static let selectionCollection: [String] = [wildcard, "SP23", "SP22", "FA22"]
        static let selectionProductCategory: [String] = [wildcard, "Accessories", "Apparel", "Brad Binder", "Gear", "Gloves", "Goggle Accessories", "Goggles", "Helmet Parts and Accessories", "Helmets", "Protection", "Sunglass Parts and Lenses", "Sunglasses"]
        static let selectionDivision: [String] = [wildcard, "Bike", "Moto", "Bike, Moto"]
        static let selectionProductDepartment: [String] = [wildcard, "Eyewear", "Hard Goods", "Soft Goods"]
        static let selectionLaunchSeason: [String] = [wildcard, "Essential", "FA17", "SP18", "FA18", "SP19", "FA19", "SP20", "FA20", "SP21", "FA21", "SP22", "FA22"]
        static let selectionProductType: [String] = [wildcard, "Accessories", "Backpack", "Beanie", "Bibs", "Bottoms", "Cap", "Fleece", "Gloves", "Goggle Case", "Goggle System", "Helmet Parts", "Helmet System", "Jackets", "Nose Parts", "Protection", "Replacement Lenses", "Socks", "Sunglass System", "Tear-Offs", "Tees", "Tops", "Umbrella", "Vest"]
        static let selectionProductSubtype: [String] = [wildcard, "Active Performance", "Athletic", "Base Layers", "Camper", "Casual", "Clear", "Dual", "Dual Pane", "Dual Pane Sonic Bumps", "Dual Pane Vented", "Elbow", "Flexfit", "Full Face", "HiPER", "Injected", "Jersey", "Knee", "Laminated", "Liners", "Mirror", "Misc.", "Mud", "Nose Bridges", "Nose Pads", "Open Face", "Pants", "Performance", "Perimeter Seal", "Photochromic", "Premium", "Regular", "Replacement Lenses", "Screws", "Shield", "Short Fingers", "Shorts", "Sleeves", "Snapback", "Sonic Bumps", "Spare Parts", "Sport Performance", "Standard", "Tech", "Trucker", "Unstructured", "Upper", "Varied", "Visors", "Water Resistant", "Waterproof", "Windproof", "Wool"]

        static var selectedCollection: String = wildcard
        static var selectedProductCategory: String = wildcard
        static var selectedDivision: String = wildcard
        static var selectedProductDepartment: String = wildcard
        static var selectedLaunchSeason: String = wildcard
        static var selectedProductType: String = wildcard
        static var selectedProductSubtype: String = wildcard
        
        static var isFiltered: Bool {
            return !(selectedCollection == wildcard && selectedProductCategory == wildcard && selectedDivision == wildcard && selectedProductDepartment == wildcard && selectedLaunchSeason == wildcard && selectedProductType == wildcard && selectedProductSubtype == wildcard)
        }
    }
    
    struct FIR {
        static let division = "Division"
        static let collection = "Collection"
        static let productNameDescription = "ProductNameDescription"
        static let productNameDescriptionSecondary = "ProductNameDescriptionSecondary"
        static let productCategory = "ProductCategory"
        static let productDepartment = "ProductDepartment"
        static let launchSeason = "LaunchSeason"
        static let productType = "ProductType"
        static let productSubtype = "ProductSubtype"
        static let youthWomen = "YouthWomen"
        static let colorway = "Colorway"
        static let carryOver = "CarryOver"
        static let essential = "Essential"
        static let skuCode = "SKUCode"
        static let colorwaySKU0 = "ColorwaySKU0"
        static let colorwaySKU1 = "ColorwaySKU1"
        static let colorwaySKU2 = "ColorwaySKU2"
        static let colorwaySKU3 = "ColorwaySKU3"
        static let colorwaySKU4 = "ColorwaySKU4"
        static let colorwaySKU5 = "ColorwaySKU5"
        static let colorwaySKU6 = "ColorwaySKU6"
        static let size0 = "Size0"
        static let size1 = "Size1"
        static let size2 = "Size2"
        static let size3 = "Size3"
        static let size4 = "Size4"
        static let size5 = "Size5"
        static let size6 = "Size6"
        static let usRetailMSRP = "USRetailMSRP"
        static let euRetailMSRP = "EURetailMSRP"
        static let countryCode = "CountryCode"
        static let composition = "Composition"
        static let productDescription = "ProductDescription"
        static let productFeatures = "ProductFeatures"
        static let imageURL = "imageURL"
        static let thumbURL = "thumbURL"
    }
}


// MARK: - UIStoryboard

extension UIStoryboard {
    static var mainStoryboard: UIStoryboard {
        UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    // 2/26/22 Changed these from ProductFilterController to ProductFilterControllerNEW
    static var leftViewController: ProductFilterControllerNEW? {
        mainStoryboard.instantiateViewController(withIdentifier: "ProductFilterControllerNEW") as? ProductFilterControllerNEW
    }
    
    static var centerViewController: WorkbookViewController? {
        mainStoryboard.instantiateViewController(withIdentifier: "WorkbookViewController") as? WorkbookViewController
    }
    
    // FIXME: - Test
    static var leftNavigationController: UINavigationController? {
        mainStoryboard.instantiateViewController(withIdentifier: "Nav2") as? UINavigationController
    }
}


// MARK: - UICollectionViewCell

extension UICollectionViewCell {
    func setSelected(_ isSelected: Bool, in contentView: UIView) {
        let overlayTag = 100
        
        let selectedOverlay: UIView = {
            let view = UIView()
            view.tag = overlayTag
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let checkmarkView = UIImageView()
            checkmarkView.image = UIImage(systemName: "checkmark.circle.fill")
            checkmarkView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(checkmarkView)
            NSLayoutConstraint.activate([checkmarkView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
                                         view.trailingAnchor.constraint(equalTo: checkmarkView.trailingAnchor, constant: 0),
                                         checkmarkView.widthAnchor.constraint(equalToConstant: 30),
                                         checkmarkView.heightAnchor.constraint(equalToConstant: 30)])

            return view
        }()
        
        func removeOverlay() {
            if let viewWithTag = contentView.viewWithTag(overlayTag) {
                viewWithTag.removeFromSuperview()
            }
        }

        
        if isSelected {
            removeOverlay()
            
            contentView.addSubview(selectedOverlay)
            NSLayoutConstraint.activate([selectedOverlay.topAnchor.constraint(equalTo: contentView.topAnchor),
                                         selectedOverlay.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                         contentView.trailingAnchor.constraint(equalTo: selectedOverlay.trailingAnchor),
                                         contentView.bottomAnchor.constraint(equalTo: selectedOverlay.bottomAnchor)])
        }
        else {
            removeOverlay()
        }
    }
}


// MARK: - ActivitySpinner

class ActivitySpinner {
    private var spinner = UIActivityIndicatorView()
    
    init(style: UIActivityIndicatorView.Style = .medium, color: UIColor = .darkGray) {
        spinner.style = style
        spinner.color = color
    }
    
    func startSpinner(in view: UIView) {
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    func stopSpinner() {
        OperationQueue.main.addOperation {
            self.spinner.stopAnimating()
        }
    }
}


// MARK: - UIFont Extension

extension UIFont {
    static let workbookTitle = UIFont(name: "AvenirNext-Bold", size: 14)!
    static let workbookBubbleTitle = UIFont(name: "AvenirNext-Bold", size: 12)!
    static let workbookSubtitle = UIFont(name: "TimesNewRomanPS-ItalicMT", size: 9)!
    static let workbookFooterTitle = UIFont(name: "TimesNewRomanPS-ItalicMT", size: 10)!
    static let workbookMenuTitle = UIFont(name: "AvenirNext-DemiBold", size: 12)!
    static let workbookMenuSelection = UIFont(name: "AvenirNext-Regular", size: 12)!
    static let workbookNoimg = UIFont(name: "AvenirNext-Regular", size: 16)!
}


// MARK: - UIColor Extension

extension UIColor {
    static let workbookSuperLightGray = UIColor(named: "superLightGray")
    static let workbookIsSelected = UIColor(named: "isSelected")
}



/*
- 2/18 RayWenderlich Dismiss Keyboard
 // Add responder for keyboards to dismiss when tap or drag outside of text fields
 scrollView.addGestureRecognizer(UITapGestureRecognizer(target: scrollView, action: #selector(UIView.endEditing(_:))))
 scrollView.keyboardDismissMode = .onDrag

 */
