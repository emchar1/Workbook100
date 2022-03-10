//
//  Constants.swift
//  Workbook100
//
//  Created by Eddie Char on 12/23/21.
//

import UIKit

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
    
    struct ProductFilter {
        static let wildcard = "[All]"
        static let segementedBoth = 0
        static let segementedOn = 1
        static let segementedOff = 2
        
        static let selectionCollection: [String] = [wildcard, "SP23", "SP22", "FA22"]
        static let selectionDivision: [String] = [wildcard, "Bike", "Moto", "Bike, Moto"]
        static let selectionLaunchSeason: [String] = [wildcard, "Essential", "FA17", "SP18", "FA18", "SP19", "FA19", "SP20", "FA20", "SP21", "FA21", "SP22", "FA22"]
        static let selectionSeasonsCarried: [String] = [wildcard, "FA18", "SP19", "FA19", "SP20", "FA20", "SP21", "FA21", "SP22", "FA22", "SP23"]
        static let selectionProductCategory: [String] = [wildcard, "Accessories", "Apparel", "Brad Binder", "Gear", "Gloves", "Goggle Accessories", "Goggles", "Helmet Parts and Accessories", "Helmets", "Protection", "Sunglass Parts and Lenses", "Sunglasses"]
        static let selectionProductDepartment: [String] = [wildcard, "Eyewear", "Hard Goods", "Soft Goods"]
        static let selectionProductType: [String] = [wildcard, "Accessories", "Backpack", "Beanie", "Bibs", "Bottoms", "Cap", "Fleece", "Gloves", "Goggle Case", "Goggle System", "Helmet Parts", "Helmet System", "Jackets", "Nose Parts", "Protection", "Replacement Lenses", "Socks", "Sunglass System", "Tear-Offs", "Tees", "Tops", "Umbrella", "Vest"]
        static let selectionProductSubtype: [String] = [wildcard, "Active Performance", "Athletic", "Base Layers", "Camper", "Casual", "Clear", "Dual", "Dual Pane", "Dual Pane Sonic Bumps", "Dual Pane Vented", "Elbow", "Flexfit", "Full Face", "HiPER", "Injected", "Jersey", "Knee", "Laminated", "Liners", "Mirror", "Misc.", "Mud", "Nose Bridges", "Nose Pads", "Open Face", "Pants", "Performance", "Perimeter Seal", "Photochromic", "Premium", "Regular", "Replacement Lenses", "Screws", "Shield", "Short Fingers", "Shorts", "Sleeves", "Snapback", "Sonic Bumps", "Spare Parts", "Sport Performance", "Standard", "Tech", "Trucker", "Unstructured", "Upper", "Varied", "Visors", "Water Resistant", "Waterproof", "Windproof", "Wool"]

        static var selectedCollection: String = wildcard
        static var selectedDivision: String = wildcard
        static var selectedLaunchSeason: String = wildcard
        static var selectedSeasonsCarried: String = wildcard
        static var selectedProductCategory: String = wildcard
        static var selectedProductDepartment: String = wildcard
        static var selectedProductType: String = wildcard
        static var selectedProductSubtype: String = wildcard
        static var selectedNew: Int = segementedBoth
        static var selectedEssential: Int = segementedBoth
        
        static var isFiltered: Bool {
            return !(selectedCollection == wildcard &&
                     selectedDivision == wildcard &&
                     selectedLaunchSeason == wildcard &&
                     selectedSeasonsCarried == wildcard &&
                     selectedProductCategory == wildcard &&
                     selectedProductDepartment == wildcard &&
                     selectedProductType == wildcard &&
                     selectedProductSubtype == wildcard &&
                     selectedNew == segementedBoth &&
                     selectedEssential == segementedBoth)
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
        static let seasonsCarried = "SeasonsCarried"
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
