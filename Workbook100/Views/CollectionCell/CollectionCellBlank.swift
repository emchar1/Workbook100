//
//  CollectionCellBlank.swift
//  Workbook100
//
//  Created by Eddie Char on 1/28/22.
//

import UIKit

class CollectionCellBlank: UICollectionViewCell {
    class var reuseID: String { "CollectionCellBlank" }
    
//    override var isSelected: Bool {
//        didSet {
//            setSelected(isSelected, in: contentView)
//        }
//    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error loading CollectionCellBlank")
    }
} 
