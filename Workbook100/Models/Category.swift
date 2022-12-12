//
//  Category.swift
//  Workbook100
//
//  Created by Eddie Char on 3/11/22.
//

import Foundation

/**
 Represents a filter item used in the left menu.
 */
class Category<T> {
    var value: T
    var children: [Category] = []
    weak var parent: Category?
    
    init(_ value: T) {
        self.value = value
    }
    
    func add(_ child: Category) {
        children.append(child)
        child.parent = self
    }
    
    func getChildren() -> [T] {
        var childrenToReturn: [T] = []

        for child in children {
            childrenToReturn.append(child.value)
        }
        
        return childrenToReturn
    }
}

extension Category: CustomStringConvertible {
    var description: String {
        var text = "\(value)"
        
        if !children.isEmpty {
            text += " {" + children.map { $0.description }.joined(separator: ", ") + "}"
        }
        
        return text
    }
}

extension Category where T: Equatable {
    func search(_ value: T) -> Category? {
        if value == self.value {
            return self
        }
        
        for child in children {
            if let found = child.search(value) {
                return found
            }
        }
        
        return nil
    }
}
