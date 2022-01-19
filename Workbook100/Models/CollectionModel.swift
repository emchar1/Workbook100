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

final class CollectionModel: NSObject, /*Codable, CustomStringConvertible,*/ Identifiable, NSItemProviderWriting {
    //removed CustomStringConvertible, Equatable, when I converted it from a struct to a class

    
    // MARK: - NSItemProviderWriting
    
    static var writableTypeIdentifiersForItemProvider: [String] {
        return []
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        return nil
    }
    
    // MARK: - Properties
    
    /*
    let showNew: Bool
    let showEssential: Bool
    let labelTitle: String
    let labelSubtitle: String
    let imageName: String
    let sizes: [Size]
    let image: StorageReference?
     */
    
    let division: String
    let collection: String
    let productNameDescription: String
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
        /*
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
         */
        
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
    
    init(division: String, collection: String, productNameDescription: String, productCategory: String, colorway: String, carryOver: Bool, essential: Bool, skuCode: String, sizes: [Size], usMSRP: Double, euMSRP: Double, countryCode: String, composition: String, productDescription: String, productFeatures: String, image: StorageReference?) {

        self.division = division
        self.collection = collection
        self.productNameDescription = productNameDescription
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
     
}


// MARK: - Comparable

extension CollectionModel: Comparable {
    static func < (lhs: CollectionModel, rhs: CollectionModel) -> Bool {
        return lhs.skuCode < rhs.skuCode
    }

    static func == (lhs: CollectionModel, rhs: CollectionModel) -> Bool {
        return lhs.skuCode == rhs.skuCode
    }
}

/*
// MARK: - NSItemProviderWriting

extension CollectionModel: NSItemProviderWriting {
    static var writableTypeIdentifiersForItemProvider: [String] {
        return [kUTTypeData as String]
    }

    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        
        let progress = Progress(totalUnitCount: 100)
        
        do {
            //Here the object is encoded to a JSON data object and sent to the completion handler
            let data = try JSONEncoder().encode(self)
            progress.completedUnitCount = 100
            completionHandler(data, nil)
        } catch {
            completionHandler(nil, error)
        }
        
        return progress
    }
}


// MARK: - NSItemProviderReading

extension CollectionModel: NSItemProviderReading {
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [kUTTypeData as String]
    }
    
    //This function actually has a return type of Self, but that really messes things up when you are trying to return your object, so if you mark your class as final as I've done above, then you can change the return type to return your class type.
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> CollectionModel {
        let decoder = JSONDecoder()
        
        do {
            //Here we decode the object back to it's class representation and return it
            let subject = try decoder.decode(CollectionModel.self, from: data)
            return subject
        } catch {
            fatalError("\(error)")
        }
    }
}
*/
