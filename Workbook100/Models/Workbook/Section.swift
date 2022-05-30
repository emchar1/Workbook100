//
//  Section.swift
//  Workbook100
//
//  Created by Eddie Char on 5/4/22.
//

import UIKit


enum SectionType: Int, CaseIterable {
    case size_1x1
    case size_2x1
    case size_6x3
    case size_3x3x2
}

enum SectionPlaceholder: Int {
    case photo = 0
    case text
    case item
}

final class Section: NSObject {
    
    // MARK: - Properties
    
    static let backgroundPadding: CGFloat = 40
    static let aspectRatio: CGFloat = 520 / 800
    
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
        case .size_6x3:
            data = Array(repeating: .item, count: 18)
        case .size_3x3x2:
            data = Array(repeating: .item, count: 9) + [.photo]
        }
        
        self.init(id: id, type: type, data: data)
    }
}


// MARK: - Comparable, Identifiable

extension Section: Comparable, Identifiable {
    static func < (lhs: Section, rhs: Section) -> Bool {
        lhs.id < rhs.id
    }
    
    static func == (lhs: Section, rhs: Section) -> Bool {
        return lhs.id == rhs.id
    }
}


// MARK: - NSItemProviderWriting

extension Section: NSItemProviderWriting {
    static var writableTypeIdentifiersForItemProvider: [String] {
        return []
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        return nil
    }
}
