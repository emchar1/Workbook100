//
//  GloveCell.swift
//  Workbook100
//
//  Created by Eddie Char on 2/4/22.
//

import UIKit

class GloveCell: CollectionCell {
    var ruleLine: RuleLine!
    var hStackBottom: CollectionCellStack!
    var labelSizesLeft: CollectionCellLabel!
    var labelSizesRight: CollectionCellLabel!
    
    override func setViews() {
        super.setViews()

//        if contentView.frame.width >= 200 {
//            hStackBottom.isHidden = false
//            ruleLine.isHidden = false
//        }
//        else {
//            hStackBottom.isHidden = true
//            ruleLine.isHidden = true
//        }
        
        labelSizesLeft.text = layoutSizes().left
        labelSizesRight.text = layoutSizes().right
    }
    
    override func setupViews() {
        super.setupViews()
        
        ruleLine = RuleLine(frame: CGRect(x: 0, y: 0, width: K.CollectionCell.width, height: 20))
        hStackBottom = CollectionCellStack(distribution: .fillEqually, alignment: .fill, axis: .horizontal)
        labelSizesLeft =  CollectionCellLabel(type: .productSize, text: layoutSizes().left)
        labelSizesRight =  CollectionCellLabel(type: .productSize, text: layoutSizes().right)

        //Rule Line
        vStack.addArrangedSubview(ruleLine)

        // FIXME: - Sizes
        vStack.addArrangedSubview(hStackBottom)
        hStackBottom.addArrangedSubview(labelSizesLeft)
        hStackBottom.alignment = .top
        labelSizesRight.textAlignment = .right
        hStackBottom.addArrangedSubview(labelSizesRight)
    }
    
    private func layoutSizes() -> (left: String, right: String) {
        var leftReturn = ""
        var rightReturn = ""
        var sizesCount = 0
        var sizesCountHalved: Int {
            Int(ceil(Double(sizesCount) / 2.0))
        }
        var maxSizesCountHalved: Int {
            Int(ceil(Double(model.sizes.count) / 2.0))
        }
        
        //Get the number of viable sizes
        for (i, size) in model.sizes.enumerated() {
            if size.size == "" && size.colorwaySKU == "" {
                sizesCount = i
                break
            }
        }
        
        //Populate left side
        for i in 0..<sizesCountHalved {
            leftReturn += "\(model.sizes[i])"
            leftReturn += (i < sizesCountHalved - 1) ? "\n" : ""
        }
        
        //Populate right side
        for i in sizesCountHalved..<sizesCount {
            rightReturn += "\(model.sizes[i])"
            rightReturn += (i < sizesCount - 1) ? "\n" : ""
        }
        
        //Add "padding"
        for _ in sizesCountHalved..<maxSizesCountHalved {
            leftReturn += "\n"
        }
        
        return (leftReturn, rightReturn)
    }
}


