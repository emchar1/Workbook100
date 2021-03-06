//
//  CollectionCell+RuleLineVertical.swift
//  Workbook100
//
//  Created by Eddie Char on 6/21/22.
//

import UIKit

class RuleLineVertical: UIView {
    init(frame: CGRect, from: CGPoint, to: CGPoint) {
        super.init(frame: frame)
        
        commonInit(from: from, to: to)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit(from: CGPoint(x: 0, y: 0), to: CGPoint(x: 0, y: bounds.height * 2))
    }
    
    private func commonInit(from: CGPoint, to: CGPoint) {
        let ruleLine = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: from)//CGPoint(x: 0, y: frame.height / 2))
        linePath.addLine(to: to)//CGPoint(x: frame.width, y: frame.height / 2))
        ruleLine.path = linePath.cgPath
        ruleLine.strokeColor = UIColor.black.cgColor
        ruleLine.lineWidth = 0.5
        layer.addSublayer(ruleLine)
    }
}

