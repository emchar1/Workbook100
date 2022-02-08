//
//  GloveCell.swift
//  Workbook100
//
//  Created by Eddie Char on 2/4/22.
//

import UIKit

class GloveCell: CollectionCell {
    override class var reuseId: String { "GloveCell" }
    var hStack: CollectionCellStack!
    var labelSizes: CollectionCellLabel!
    
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
        
        labelSizes.text = layoutSizes()
//        labelSizesRight.text = layoutSizes().right
    }
    
    override func setupViews() {
        super.setupViews()
        
        //HStack
        hStack = CollectionCellStack(spacing: 0, distribution: .fillEqually, alignment: .fill, axis: .horizontal)
        labelSizes = CollectionCellLabel(type: .productSize, text: layoutSizes())
        productImage.removeFromSuperview()
        labelSubtitle.removeFromSuperview()

        //Subviews
        hStack.addArrangedSubview(productImage)
        hStack.addArrangedSubview(labelSizes)
        vStack.addArrangedSubview(hStack)
    }
    
    private func layoutSizes() -> String {
        var stringToReturn = ""
        
        for i in 0..<model.sizes.count {
            stringToReturn += "\(model.sizes[i])\n"
        }
        
        return stringToReturn
    }
    
    /*
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
     */
}


