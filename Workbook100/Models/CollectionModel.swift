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

/*final*/ struct CollectionModel: /*NSObject, Codable,*/CustomStringConvertible, Identifiable { //removed CustomStringConvertible, Equatable, when I converted it from a struct to a class
    
    // MARK: - Properties
    
    
    let showNew: Bool
    let showEssential: Bool
    let labelTitle: String
    let labelSubtitle: String
    let imageName: String
    let sizes: [Size]
    let image: StorageReference?
    var id = UUID()
    
    var description: String {
        return imageName
    }

    struct Size: Codable, CustomStringConvertible {
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
    
    /*
    // MARK: - Initialization
    
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
}


// MARK: - Comparable

extension CollectionModel: Comparable {
    static func < (lhs: CollectionModel, rhs: CollectionModel) -> Bool {
        return lhs.imageName < rhs.imageName
    }

    static func == (lhs: CollectionModel, rhs: CollectionModel) -> Bool {
        return lhs.imageName == rhs.imageName
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
