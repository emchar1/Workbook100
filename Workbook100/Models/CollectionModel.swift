//
//  CollectionModel.swift
//  Workbook100
//
//  Created by Eddie Char on 12/23/21.
//

import Foundation
import FirebaseStorage


// MARK: - Collection Model - for the object used in the Cell

struct CollectionModel: Equatable, Identifiable, Comparable, CustomStringConvertible { //removed CustomStringConvertible, Equatable, when I converted it from a struct to a class
    
    struct Size: CustomStringConvertible {
        static let sm = "SM"
        static let md = "MD"
        static let lg = "LG"
        static let xl = "XL"
        static let xxl = "XXL"
        
        let size: String?
        let sku: String?
        
        var description: String {
            guard let size = size, let sku = sku, sku.count > 0 else {
                return ""
            }
            
            return size + ": " + sku
        }
    }
    
    let showNew: Bool
    let showEssential: Bool
    let labelTitle: String
    let labelSubtitle: String
    let imageName: String
    let sizes: [Size]
    let image: StorageReference?
    var id = UUID()
    
    /*
    init(showNew: Bool, showEssential: Bool, labelTitle: String, labelSubtitle: String, imageName: String, sizes: [Size], image: StorageReference?) {
        self.showNew = showNew
        self.showEssential = showEssential
        self.labelTitle = labelTitle
        self.labelSubtitle = labelSubtitle
        self.imageName = imageName
        self.sizes = sizes
        self.image = image
        
        super.init()
    }
     */
    
    var description: String {
        return imageName
    }
    
    static func < (lhs: CollectionModel, rhs: CollectionModel) -> Bool {
        return lhs.imageName < rhs.imageName
    }

    static func == (lhs: CollectionModel, rhs: CollectionModel) -> Bool {
        return lhs.imageName == rhs.imageName
    }
}
