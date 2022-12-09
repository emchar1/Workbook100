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
//        print("ProductFilter.isFiltered: \(ProductFilter.isFiltered)")
//        return ProductFilter.isFiltered ? filteredItems : items
        filteredItems
    }
    
    /**
     Returns the difference of filtered items, i.e. 1 - [filteredItems].
     */
    static var getRemainingItemsIfFiltered: [CollectionModel] {
        Array(Set(items).symmetricDifference(Set(filteredItems)))
    }
}
