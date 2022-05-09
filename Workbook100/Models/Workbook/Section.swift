//
//  Section.swift
//  Workbook100
//
//  Created by Eddie Char on 5/4/22.
//

import Foundation


enum SectionType: Int, CaseIterable {
    case size_1x1
    case size_2x1
    case size_6x3
    case size_3x3x2
}

final class Section: NSObject, Comparable, Identifiable, NSItemProviderWriting {
    let id: Int
    let type: SectionType
    var data: [Any]
    
    override var description: String {
        return "This is a section with id: \(id) and sectionType: \(type). There is also an array here. Would you like to see the contents of the array? Y/N. Jk you can't actually select it, obviously."
    }
    
    init(id: Int, type: SectionType, data: [Any]) {
        self.id = id
        self.type = type
        self.data = data
    }
    
    static func < (lhs: Section, rhs: Section) -> Bool {
        lhs.id < rhs.id
    }
    
    static func == (lhs: Section, rhs: Section) -> Bool {
        return lhs.id == rhs.id
    }
}


// MARK: - NSItemProviderWriting

extension Section {
    static var writableTypeIdentifiersForItemProvider: [String] {
        return []
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        return nil
    }
}