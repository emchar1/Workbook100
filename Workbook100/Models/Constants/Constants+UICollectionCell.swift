//
//  Constants+UICollectionCell.swift
//  Workbook100
//
//  Created by Eddie Char on 3/28/22.
//

import UIKit

extension K {
    struct CollectionCell {
        static var cellMultiplier: CGFloat = (UIScreen.main.traitCollection.horizontalSizeClass == .compact) ? 3 : 6
        static let padding: CGFloat = 8
        static let cornerRadius: CGFloat = 8
        static let width: CGFloat = 200
        static var height: CGFloat { width * 3 / 2 }

        static func adjustedWidth(in view: UIView) -> CGFloat {
            return view.bounds.width / cellMultiplier - (2 * padding)
            
        }

        static func adjustedHeight(in view: UIView) -> CGFloat {
            return adjustedWidth(in: view) * 3 / 2
        }
    }
}
