//
//  CollectionCell+Label.swift
//  Workbook100
//
//  Created by Eddie Char on 5/10/22.
//

import UIKit
import Darwin

class CollectionCellLabel: UILabel {
    enum LabelType {
        case title, subtitle, productSize
    }
    
    init(frame: CGRect = .zero, type: LabelType, text: String) {
        super.init(frame: frame)

        self.text = text
        self.textColor = .black
        self.numberOfLines = (type != .title) ? 0 : 1
        
//        adjustsFontSizeToFitWidth = true
//        minimumScaleFactor = 0.05
        
        if frame == .zero {
            self.translatesAutoresizingMaskIntoConstraints = false
        }
        
        customizeType(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeType(_ type: LabelType) {
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
