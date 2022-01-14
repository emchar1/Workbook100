//
//  Test.swift
//  Workbook100
//
//  Created by Eddie Char on 1/13/22.
//

import Foundation
import Firebase

class Test: Codable {
    static let teacher = "Peter"
    var gender: Bool
    var name: String
    var id = UUID()
//    var image: StorageReference?
    
    init(gender: Bool, name: String) {
        self.gender = gender
        self.name = name
    }
}
