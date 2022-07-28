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

    let hashNeedThis: String
    let division: String
    let collection: String
    let productNameDescription: String
    let productNameDescriptionSecondary: String
    let productCategory: String
    let productDepartment: String
    let launchSeason: String
    let seasonsCarried: String
    let productType: String
    let productSubtype: String
    let productDetails: String
    let productClass: String
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
    let lineListOrder: Int
    let lineList: String
    let primaryImageURL: String
    let thumbURL: String
    let imageURLs: [String]
    let image: StorageReference?
    var savedLists: [String]?
    
    var id = UUID()
    var isRemoved = false
    
    override var description: String {
        return skuCode
    }

    struct Size: Codable, CustomStringConvertible {
        let size: String?
        let colorwaySKU: String?
        let qoh: Int?

        var description: String {
            guard let size = size, let sku = colorwaySKU, sku.count > 0/*, let qoh = qoh*/ else {
                return ""
            }
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal

            return size + ": " + sku// + ", QOH: " + numberFormatter.string(from: NSNumber(value: qoh))!
        }
    }
    
    
    // MARK: - Initialization
    
    init(hashNeedThis: String,
         division: String,
         collection: String,
         productNameDescription: String,
         productNameDescriptionSecondary: String,
         productCategory: String,
         productDepartment: String,
         launchSeason: String,
         seasonsCarried: String,
         productType: String,
         productSubtype: String,
         productDetails: String,
         productClass: String,
         colorway: String,
         carryOver: Bool,
         essential: Bool,
         skuCode: String,
         sizes: [Size],
         usMSRP: Double,
         euMSRP: Double,
         countryCode: String,
         composition: String,
         productDescription: String,
         productFeatures: String,
         lineListOrder: Int,
         lineList: String,
         primaryImageURL: String,
         thumbURL: String,
         imageURLs: [String],
         image: StorageReference?,
         savedLists: [String]?,
         isRemoved: Bool = false) {

        self.hashNeedThis = hashNeedThis
        self.division = division
        self.collection = collection
        self.productNameDescription = productNameDescription
        self.productNameDescriptionSecondary = productNameDescriptionSecondary
        self.productCategory = productCategory
        self.productDepartment = productDepartment
        self.launchSeason = launchSeason
        self.seasonsCarried = seasonsCarried
        self.productType = productType
        self.productSubtype = productSubtype
        self.productDetails = productDetails
        self.productClass = productClass
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
        self.lineListOrder = lineListOrder
        self.lineList = lineList
        self.primaryImageURL = primaryImageURL
        self.thumbURL = thumbURL
        self.imageURLs = imageURLs
        self.image = image
        self.savedLists = savedLists
        self.isRemoved = isRemoved
        
        super.init()
    }
    
    static func getBlankModel() -> CollectionModel {
        let model = CollectionModel(hashNeedThis: "00000-00000",
                                    division: K.ProductFilter.wildcard,
                                    collection: K.ProductFilter.wildcard,
                                    productNameDescription: "Product Name Description",
                                    productNameDescriptionSecondary: "Product Name Description Secondary",
                                    productCategory: K.ProductFilter.wildcard,
                                    productDepartment: "Product Department",
                                    launchSeason: "Launch Season",
                                    seasonsCarried: "Seasons Carried",
                                    productType: "Product Type",
                                    productSubtype: "Product Subtype",
                                    productDetails: "Product Details",
                                    productClass: "Product Class",
                                    colorway: "Color",
                                    carryOver: false,
                                    essential: true,
                                    skuCode: "00000-00000",
                                    sizes: [
                                        CollectionModel.Size(size: "Size 0", colorwaySKU: "00000-00000", qoh: 9999),
                                        CollectionModel.Size(size: "Size 1", colorwaySKU: "00000-00001", qoh: 9999),
                                        CollectionModel.Size(size: "Size 2", colorwaySKU: "00000-00002", qoh: 9999),
                                        CollectionModel.Size(size: "Size 3", colorwaySKU: "00000-00003", qoh: 9999),
                                        CollectionModel.Size(size: "Size 4", colorwaySKU: "00000-00004", qoh: 9999),
                                        CollectionModel.Size(size: "Size 5", colorwaySKU: "00000-00005", qoh: 9999),
                                        CollectionModel.Size(size: "Size 6", colorwaySKU: "00000-00006", qoh: 9999),
                                        CollectionModel.Size(size: "Size 7", colorwaySKU: "00000-00007", qoh: 9999)
                                    ],
                                    usMSRP: 9.99,
                                    euMSRP: 10.01,
                                    countryCode: "US",
                                    composition: "Composition",
                                    productDescription: "Product Description",
                                    productFeatures: "Product Features",
                                    lineListOrder: 0,
                                    lineList: "Line List",
                                    primaryImageURL: "https://cdn.shopify.com/s/files/1/0042/0190/6234/t/217/assets/logo.svg?v=1247933254295750364", //100% Logo
                                    thumbURL: "https://cdn.shopify.com/s/files/1/0042/0190/6234/t/217/assets/logo.svg?v=1247933254295750364", //100% Logo
                                    imageURLs: ["https://cdn.shopify.com/s/files/1/0042/0190/6234/t/217/assets/logo.svg?v=1247933254295750364"],
                                    image: nil,
                                    savedLists: nil)
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
