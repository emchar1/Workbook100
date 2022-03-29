//
//  Constants.swift
//  Workbook100
//
//  Created by Eddie Char on 12/23/21.
//

import Foundation

struct K {
    static var items: [CollectionModel] = []
    static var filteredItems: [CollectionModel] = []
    
    static var getFilteredItemsIfFiltered: [CollectionModel] {
        ProductFilter.isFiltered ? filteredItems : items
    }
    
    static var getRemainingItems: [CollectionModel] {
        Array(Set(items).symmetricDifference(Set(filteredItems)))
    }
}
