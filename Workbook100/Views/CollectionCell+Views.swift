//
//  CollectionCell+Views.swift
//  Workbook100
//
//  Created by Eddie Char on 1/28/22.
//

import UIKit


// MARK: - Collection Cell Stack

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


// MARK: - Collection Cell Label Bubble

class CollectionCellLabelBubble: UILabel {
    enum LabelBubbleType {
        case new, essential, nothing
    }
    
    init(frame: CGRect = .zero, type: LabelBubbleType) {
        super.init(frame: frame)

        self.text = text
        self.textColor = .white
        self.textAlignment = .center
        self.font = K.Fonts.bubbleTitle
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        
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
            self.backgroundColor = .black
            self.text = "Essential"
        case .nothing:
            self.backgroundColor = .clear
            self.text = ""
        }
    }
    
//    func setConstraints(to view: UIView, padding: CGFloat) {
//        NSLayoutConstraint.activate([topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
//                                     leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
//                                     view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: padding),
//                                     view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: padding)])
//    }
}


// MARK: - Collection Cell Label

class CollectionCellLabel: UILabel {
    enum LabelType {
        case title, subtitle, productSize
    }
    
    init(frame: CGRect = .zero, type: LabelType, text: String) {
        super.init(frame: frame)

        self.text = text
        self.textColor = .black
        self.numberOfLines = (type != .title) ? 0 : 1
        
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
            self.font = K.Fonts.title
        case .subtitle:
            self.font = K.Fonts.subtitle
        case .productSize:
            self.font = K.Fonts.footerTitle
        }
    }
}


// MARK: - Rule Line

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

