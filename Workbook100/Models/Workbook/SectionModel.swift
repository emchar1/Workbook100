//
//  SectionModel.swift
//  Workbook100
//
//  Created by Eddie Char on 5/4/22.
//

import UIKit
import Firebase

/**
 Section grid size, e.g. size_1x1, size_6x3.
 */
enum SectionType: String, CaseIterable {
    case size_1x1
    case size_2x1
    case size_2x1reversed
    case size_6x3
    case size_3x3x2
}

/**
 Section Placeholder, either photo, text, or item.
 */
enum SectionPlaceholder: Int {
    case photo = 0
    case text
    case item
}

/**
 Swift Section model object.
 */
final class SectionModel: NSObject {
    
    // MARK: - Properties
    
    static let backgroundPadding: CGFloat = 40
    
    /**
     Aspect ratio of a page in the InDesign workbook
     */
    static let aspectRatio: CGFloat = 520 / 800
    
    static let sectionSectionPlaceholder = "sec: "
    static let sectionImage = "img: "
    static let sectionText = "txt: "
    static let sectionItem = "itm: "
    static let sectionPrefix = 5
    static let mb: Int64 = 1 * 1024 * 1024
    static let maxImageSize: Int64 = 5

    
    //Section properties
    let id: Int
    let type: SectionType
    var data: [Any]
    
    override var description: String {
        return "id: \(id); sectionType: \(type); data: \(data)"
    }
    
    
    // MARK: - Initialization
    
    init(id: Int, type: SectionType, data: [Any]) {
        self.id = id
        self.type = type
        self.data = data
    }
    
    convenience init(id: Int, type: SectionType) {
        var data: [SectionPlaceholder]
        
        switch type {
        case .size_1x1:
            data = [.photo]
        case .size_2x1:
            data = [.text, .photo]
        case .size_2x1reversed:
            data = [.photo, .text]
        case .size_6x3:
            data = Array(repeating: .item, count: 18)
        case .size_3x3x2:
            data = Array(repeating: .item, count: 9) + [.photo]
        }
        
        self.init(id: id, type: type, data: data)
    }
    
    
    // MARK: - Helper Functions
    
    /**
     Converts data from Firestore into Workbook-friendly cells. The completion handler, the way it passes the parameter, data into it to return the new data, seems messy
     */
    func convertData(_ data: [Any], completion: @escaping ([Any]) -> ()) {
        var newData: [Any] = []
        var isImage = false
        
        for datum in data {
            guard let datum = datum as? String else { return }
            
            let datumPrefix = datum.prefix(SectionModel.sectionPrefix)
            let datumSuffix = datum.dropFirst(SectionModel.sectionPrefix)
            
            switch datumPrefix {
            case SectionModel.sectionSectionPlaceholder:
                newData.append(SectionPlaceholder(rawValue: Int(datumSuffix) ?? 0)!)
            case SectionModel.sectionImage:
                let imageRef = Storage.storage().reference().child("\(datumSuffix)")
                
                isImage = true
                
                //This closure, calls my closure!
                imageRef.getData(maxSize: SectionModel.maxImageSize * SectionModel.mb) { (data, error) in
                    guard error == nil else { return print("Error getting imageRef in SectionModel: \(error!)")}
                    
                    newData.append(UIImage(data: data!) ?? UIImage(named: "noimg")!)
                    completion(newData)
                }
            case SectionModel.sectionText:
                guard datum.contains("|") else { return }

                let textArray = datum.dropFirst(SectionModel.sectionPrefix).components(separatedBy: "|")
                
                newData.append((textArray[0], textArray[1]))
            case SectionModel.sectionItem:
                let sku = datum.dropFirst(SectionModel.sectionPrefix)
                
                newData.append(K.items.first { $0.skuCode == String(sku) } ?? sku)
            default:
                print("Invalid section!")
            }
        }
        
        if !isImage {
            completion(newData)
        }
    }
    
}


// MARK: - Comparable, Identifiable

extension SectionModel: Comparable, Identifiable {
    static func < (lhs: SectionModel, rhs: SectionModel) -> Bool {
        lhs.id < rhs.id
    }
    
    static func == (lhs: SectionModel, rhs: SectionModel) -> Bool {
        return lhs.id == rhs.id
    }
}


// MARK: - NSItemProviderWriting

extension SectionModel: NSItemProviderWriting {
    static var writableTypeIdentifiersForItemProvider: [String] {
        return []
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        return nil
    }
}
