//
//  CollectionCellPage.swift
//  Workbook100
//
//  Created by Eddie Char on 4/27/22.
//

import UIKit

class CollectionCellPage: UICollectionViewCell {
    class var reuseId: String { "CollectionCellPage" }
    
//    override var isSelected: Bool {
//        didSet {
//            setSelected(isSelected, in: contentView)
//        }
//    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .systemYellow
        contentView.layer.cornerRadius = K.CollectionCell.cornerRadius
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error loading CollectionCellBlank")
    }
}
