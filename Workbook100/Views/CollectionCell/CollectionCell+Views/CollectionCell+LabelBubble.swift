//
//  CollectionCell+LabelBubble.swift
//  Workbook100
//
//  Created by Eddie Char on 5/10/22.
//

import UIKit

class CollectionCellLabelBubble: UILabel {
    enum LabelBubbleType {
        case new, essential, nothing
    }
    
    init(frame: CGRect = .zero, type: LabelBubbleType) {
        super.init(frame: frame)

        self.text = text
        self.textColor = type == .essential ? .systemBackground : .white
        self.textAlignment = .center
        self.font = .workbookBubbleTitle
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.05
        
        if frame == .zero {
            self.translatesAutoresizingMaskIntoConstraints = false
        }
        
        customizeType(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeType(_ type: LabelBubbleType) {
        switch type {
        case .new:
            self.backgroundColor = .red
            self.text = "New"
        case .essential:
            self.backgroundColor = .label
            self.text = "Essential"
        case .nothing:
            self.backgroundColor = .clear
            self.text = ""
        }
    }
}
