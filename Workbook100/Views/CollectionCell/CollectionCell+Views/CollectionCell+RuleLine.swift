//
//  CollectionCell+RuleLine.swift
//  Workbook100
//
//  Created by Eddie Char on 5/10/22.
//

import UIKit

class RuleLine: UIView {
    init(frame: CGRect, from: CGPoint, to: CGPoint) {
        super.init(frame: frame)
        
        let ruleLine = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: from)//CGPoint(x: 0, y: frame.height / 2))
        linePath.addLine(to: to)//CGPoint(x: frame.width, y: frame.height / 2))
        ruleLine.path = linePath.cgPath
        ruleLine.strokeColor = UIColor.black.cgColor
        ruleLine.lineWidth = 0.5
        layer.addSublayer(ruleLine)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
