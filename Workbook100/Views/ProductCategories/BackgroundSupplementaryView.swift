//
//  BackgroundSupplementaryView.swift
//  Workbook100
//
//  Created by Eddie Char on 5/2/22.
//

import UIKit

final class BackgroundSupplementaryView: UICollectionReusableView {
    class var reuseID: String { "BackgroundSupplementaryViewID" }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 1, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
