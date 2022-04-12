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
    
    /**
     Property that determines which array to return, based on if filters have been set.
     */
    static var getFilteredItemsIfFiltered: [CollectionModel] {
        ProductFilter.isFiltered ? filteredItems : items
    }
    
    /**
     Returns the difference of filtered items, i.e. 1 - [filteredItems].
     */
    static var getRemainingItems: [CollectionModel] {
        Array(Set(items).symmetricDifference(Set(filteredItems)))
    }
}
