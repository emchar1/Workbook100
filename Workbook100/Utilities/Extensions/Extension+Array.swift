//
//  Extension+Array.swift
//  Workbook100
//
//  Created by Eddie Char on 4/23/22.
//

import Foundation

extension Array where Element == String {
    func joinAndWrap(in separator: String) -> String {
        return self.joined(separator: separator).wrap(in: separator)
    }
    
    func jContains(_ element: String) -> Bool {
        return self.joined().contains(element)
    }
}
