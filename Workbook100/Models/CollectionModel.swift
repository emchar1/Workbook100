//
//  CollectionModel.swift
//  Workbook100
//
//  Created by Eddie Char on 12/23/21.
//

import Foundation
import FirebaseStorage
import MobileCoreServices
import UniformTypeIdentifiers


// MARK: - CollectionModel

final class CollectionModel: NSObject, Comparable, Identifiable, NSItemProviderWriting {
    //removed CustomStringConvertible, Equatable, when I converted it from a struct to a class

    
    // MARK: - Properties

    let division: String
    let collection: String
    let productNameDescription: String
    let productNameDescriptionSecondary: String
    let productCategory: String
    let colorway: String
    let carryOver: Bool
    let essential: Bool
    let skuCode: String
    let sizes: [Size]
    let usMSRP: Double
    let euMSRP: Double
    let countryCode: String
    let composition: String
    let productDescription: String
    let productFeatures: String
    let image: StorageReference?
    var id = UUID()
    
    override var description: String {
        return skuCode
    }

    struct Size: Codable, CustomStringConvertible {
        let size: String?
        let colorwaySKU: String?

        var description: String {
            guard let size = size, let sku = colorwaySKU, sku.count > 0 else {
                return ""
            }

            return size + ": " + sku
        }
    }
    
    
    // MARK: - Initialization
    
    init(division: String, collection: String, productNameDescription: String, productNameDescriptionSecondary: String, productCategory: String, colorway: String, carryOver: Bool, essential: Bool, skuCode: String, sizes: [Size], usMSRP: Double, euMSRP: Double, countryCode: String, composition: String, productDescription: String, productFeatures: String, image: StorageReference?) {

        self.division = division
        self.collection = collection
        self.productNameDescription = productNameDescription
        self.productNameDescriptionSecondary = productNameDescriptionSecondary
        self.productCategory = productCategory
        self.colorway = colorway
        self.carryOver = carryOver
        self.essential = essential
        self.skuCode = skuCode
        self.sizes = sizes
        self.usMSRP = usMSRP
        self.euMSRP = euMSRP
        self.countryCode = countryCode
        self.composition = composition
        self.productDescription = productDescription
        self.productFeatures = productFeatures
        self.image = image
        
        super.init()
    }
    
    static func getBlankModel() -> CollectionModel {
        let model = CollectionModel(division: "Division",
                                    collection: "SP23",
                                    productNameDescription: "Product Name Description",
                                    productNameDescriptionSecondary: "Product Name Description Secondary",
                                    productCategory: "Product Category",
                                    colorway: "Color",
                                    carryOver: false,
                                    essential: true,
                                    skuCode: "00000-00000",
                                    sizes: [
                                       CollectionModel.Size(size: "Size 0", colorwaySKU: "00000-00000"),
                                       CollectionModel.Size(size: "Size 1", colorwaySKU: "00000-00001"),
                                       CollectionModel.Size(size: "Size 2", colorwaySKU: "00000-00002"),
                                       CollectionModel.Size(size: "Size 3", colorwaySKU: "00000-00003"),
                                       CollectionModel.Size(size: "Size 4", colorwaySKU: "00000-00004"),
                                       CollectionModel.Size(size: "Size 5", colorwaySKU: "00000-00005"),
                                       CollectionModel.Size(size: "Size 6", colorwaySKU: "00000-00006")
                                    ],
                                    usMSRP: 9.99,
                                    euMSRP: 10.01,
                                    countryCode: "US",
                                    composition: "Composition",
                                    productDescription: "Product Description",
                                    productFeatures: "Product Features",
                                    image: nil)//Storage.storage().reference().child("10000-00000.jpg"))
        return model
    }
}


// MARK: - Comparable

extension CollectionModel {
    static func < (lhs: CollectionModel, rhs: CollectionModel) -> Bool {
        return lhs.skuCode < rhs.skuCode
    }

    static func == (lhs: CollectionModel, rhs: CollectionModel) -> Bool {
        return lhs.skuCode == rhs.skuCode
    }
}


// MARK: - NSItemProviderWriting

extension CollectionModel {
    static var writableTypeIdentifiersForItemProvider: [String] {
        return []
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        return nil
    }
}
