//
//  CollectionHeaderView.swift
//  Workbook100
//
//  Created by Eddie Char on 4/6/22.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "HeaderID"
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "HEADER"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont(name: "Avenir Next Condensed Demi Bold Italic", size: 32)
        return label
    }()
    
    func configure() {
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //Makes the frame the entirety of the header view. Neat!
        label.frame = bounds
        
        label.frame.origin.x = 8
    }
}
