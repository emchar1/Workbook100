//
//  LineListFIR.swift
//  Workbook100
//
//  Created by Eddie Char on 9/18/22.
//

import Foundation
import FirebaseFirestoreSwift

struct LineListFIR: Codable, Identifiable {
    @DocumentID public var id: String?
    
    let hashNeedThis: [HashNeedThis]
}

struct HashNeedThis: Codable {
    let hash: String
    let isExcluded: Bool
}

struct LineListNaming {
    static let hash = "hash"
    static let isExcluded = "isExcluded"
}
