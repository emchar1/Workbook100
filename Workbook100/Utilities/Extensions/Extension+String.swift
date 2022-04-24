//
//  Extension+String.swift
//  Workbook100
//
//  Created by Eddie Char on 3/28/22.
//

import Foundation

extension String {
    func wrap(in separator: String) -> String {
        return separator + self + separator
    }
    
    func containsElementInArray(_ array: [String]) -> Bool {
//        //Similarly...
//        for item in array {
//            if self.contains(item) {
//                return true
//            }
//        }
//        
//        return false
        
        return array.contains { contains($0) }
    }
}
