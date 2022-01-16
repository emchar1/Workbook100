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
    
    struct Fonts {
        static let bubbleTitle = UIFont(name: "AvenirNext-Bold", size: 12)
        static let title = UIFont(name: "AvenirNext-Bold", size: 14)
        static let subtitle = UIFont(name: "TimesNewRomanPS-ItalicMT", size: 9)
        static let footerTitle = UIFont(name: "TimesNewRomanPS-ItalicMT", size: 10)
        static let noimg = UIFont(name: "AvenirNext", size: 16)
    }
    
    struct CollectionCell {
        static let identifier = "CVCell"
        static let padding: CGFloat = 8
        static let width: CGFloat = 200
        static let height: CGFloat = CollectionCell.width * 3 / 2
    }
    
    struct FIR {
        static let division = "Division"
        static let collection = "Collection"
        static let productNameDescription = "ProductNameDescription"
        static let productCategory = "ProductCategory"
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
    }
}


// MARK: - UIStoryboard

extension UIStoryboard {
    static var mainStoryboard: UIStoryboard {
        UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    static var leftViewController: ProductFilterController? {
        mainStoryboard.instantiateViewController(withIdentifier: "ProductFilterController") as? ProductFilterController
    }
    
    static var centerViewController: WorkbookViewController? {
        mainStoryboard.instantiateViewController(withIdentifier: "WorkbookViewController") as? WorkbookViewController
    }
    
    // FIXME: - Test
    static var leftNavigationController: UINavigationController? {
        mainStoryboard.instantiateViewController(withIdentifier: "Nav2") as? UINavigationController
    }
}
