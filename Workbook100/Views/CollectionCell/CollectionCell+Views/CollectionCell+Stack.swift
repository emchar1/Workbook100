//
//  CollectionCell+Stack.swift
//  Workbook100
//
//  Created by Eddie Char on 5/10/22.
//

import UIKit

class CollectionCellStack: UIStackView {
    init(frame: CGRect = .zero, backgroundColor: UIColor? = nil, spacing: CGFloat = 0, distribution: Distribution, alignment: Alignment, axis: NSLayoutConstraint.Axis) {
        super.init(frame: frame)

        //Convenient properties to initialize
        self.backgroundColor = backgroundColor
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = alignment
        self.axis = axis
        
        //Assumes user intends to use NSLayoutConstraints
        if frame == .zero {
            self.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
