//
//  CollectionCell+Label.swift
//  Workbook100
//
//  Created by Eddie Char on 5/10/22.
//

import UIKit

class CollectionCellLabel: UILabel {
    
    // MARK: - Properties
    
    enum LabelType {
        case title, subtitle, productSize
    }
    
    var type: LabelType {
        didSet {
            customizeType(type)
        }
    }
    
    
    // MARK: - Initialization
    
    init(frame: CGRect = .zero, type: LabelType, text: String) {
        self.type = type
        super.init(frame: frame)
        self.text = text

        commonInit(type: type)
    }
    
    required init?(coder: NSCoder) {
        self.type = .title
        super.init(coder: coder)
        
        commonInit(type: type)
    }
    
    private func commonInit(type: LabelType) {
        self.textColor = .black
        
//        adjustsFontSizeToFitWidth = true
//        minimumScaleFactor = 0.05
        
        if frame == .zero {
            self.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    
    // MARK: - Helper Functions
    
    private func customizeType(_ type: LabelType) {
        self.numberOfLines = (type != .title) ? 0 : 1

        switch type {
        case .title:
            self.font = .workbookTitle
        case .subtitle:
            self.font = .workbookSubtitle
        case .productSize:
            self.font = .workbookFooterTitle
        }
    }
}
