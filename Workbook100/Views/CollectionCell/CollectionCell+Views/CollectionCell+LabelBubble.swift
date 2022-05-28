//
//  CollectionCell+LabelBubble.swift
//  Workbook100
//
//  Created by Eddie Char on 5/10/22.
//

import UIKit

class CollectionCellLabelBubble: UILabel {
    
    // MARK: - Properties
    
    enum LabelBubbleType {
        case new, essential, blank
    }
    
    var type: LabelBubbleType {
        didSet {
            customizeType(type)
        }
    }
    
    
    // MARK: - Initialization
    
    init(frame: CGRect = .zero, type: LabelBubbleType) {
        self.type = type
        super.init(frame: frame)

        commonInit(type: type)
    }
    
    required init?(coder: NSCoder) {
        self.type = .new
        super.init(coder: coder)
        
        commonInit(type: type)
    }
    
    
    // MARK: - Helper Functions
    
    private func commonInit(type: LabelBubbleType) {
        self.textColor = .white
        self.textAlignment = .center
        self.font = .workbookBubbleTitle
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        
//        adjustsFontSizeToFitWidth = true
//        minimumScaleFactor = 0.05
        
        if frame == .zero {
            self.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func customizeType(_ type: LabelBubbleType) {
        switch type {
        case .new:
            self.backgroundColor = .red
            self.text = "New"
        case .essential:
            self.backgroundColor = .black
            self.text = "Essential"
        case .blank:
            self.backgroundColor = .clear
            self.text = ""
        }
    }
}
