//
//  SectionFIR.swift
//  Workbook100
//
//  Created by Eddie Char on 5/31/22.
//

import Foundation
import FirebaseFirestoreSwift

/**
 Firestore model object
 */
struct SectionFIR: Codable, Identifiable {
    @DocumentID public var id: String?
    let sections: [SectionData]
}

/**
 Firestore model object helper for SectionFIR, for data[] and type.
 */
struct SectionData: Codable {
    let data: [String]
    let type: String
}

/**
 Used to match the property names in SectionFIR model object. When adding/editing property names, make sure to update them here too.
 */
struct SectionNaming {
    static let sections = "sections"
    static let data = "data"
    static let type = "type"
}
