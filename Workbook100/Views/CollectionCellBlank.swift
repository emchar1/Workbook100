//
//  CollectionCellBlank.swift
//  Workbook100
//
//  Created by Eddie Char on 1/28/22.
//

import UIKit

class CollectionCellBlank: UICollectionViewCell {
    override var isSelected: Bool {
        didSet {
            setSelected(isSelected, in: contentView)
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = K.CollectionCell.cornerRadius
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error loading CollectionCellBlank")
    }
}
