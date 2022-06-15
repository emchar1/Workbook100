//
//  Extension+UICollectionViewCell.swift
//  Workbook100
//
//  Created by Eddie Char on 3/28/22.
//

import UIKit

extension UICollectionViewCell {
    // MARK: - Properties

    static let collectionCellWidth: CGFloat = 180
    static var collectionCellHeight: CGFloat { collectionCellWidth * 3 / 2 }

//    static var cellMultiplier: CGFloat = (UIScreen.main.traitCollection.horizontalSizeClass == .compact) ? 3 : 6
//    static let padding: CGFloat = 8
//    static let customCornerRadius: CGFloat = 8

//    /**
//     Obtains the width = view.bounds.width / cellMultiplier - (2 x padding), where cellMultiplier = (UIScreen.main.traitCollection.horizontalSizeClass == .compact) ? 3 : 6
//     */
//    static func adjustedWidth(in view: UIView) -> CGFloat {
//        return view.bounds.width / cellMultiplier - (2 * padding)
//
//    }
//
//    /**
//     Obtains the height = adjustedWidth x 1.5
//     */
//    static func adjustedHeight(in view: UIView) -> CGFloat {
//        return adjustedWidth(in: view) * 3 / 2
//    }
    
    
    // MARK: - Functions
    
    /**
     Used to toggle the select feature of a CollectionCell.
     */
    func setSelected(_ isSelected: Bool, in contentView: UIView) {
        let overlayTag = 100
        
        let selectedOverlay: UIView = {
            let view = UIView()
            view.tag = overlayTag
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let checkmarkView = UIImageView()
            checkmarkView.image = UIImage(systemName: "checkmark.circle.fill")
            checkmarkView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(checkmarkView)
            NSLayoutConstraint.activate([checkmarkView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
                                         view.trailingAnchor.constraint(equalTo: checkmarkView.trailingAnchor, constant: 0),
                                         checkmarkView.widthAnchor.constraint(equalToConstant: 30),
                                         checkmarkView.heightAnchor.constraint(equalToConstant: 30)])

            return view
        }()
        
        //Nested function
        func removeOverlay() {
            if let viewWithTag = contentView.viewWithTag(overlayTag) {
                viewWithTag.removeFromSuperview()
            }
        }

        
        if isSelected {
            removeOverlay()
            
            contentView.addSubview(selectedOverlay)
            NSLayoutConstraint.activate([selectedOverlay.topAnchor.constraint(equalTo: contentView.topAnchor),
                                         selectedOverlay.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                         contentView.trailingAnchor.constraint(equalTo: selectedOverlay.trailingAnchor),
                                         contentView.bottomAnchor.constraint(equalTo: selectedOverlay.bottomAnchor)])
        }
        else {
            removeOverlay()
        }
    }
    
    /**
     Resizes the cell to the prescribed dimensions
     */
    func transformCell(in contentView: UIView) {
//        let cellFrame = self.convert(self.bounds, to: contentView)
//        let transformOffset: CGFloat = 0//collectionView.bounds.height * 2 / 3
//        let percent: CGFloat = 1//max(min((cellFrame.minY - transformOffset) / (contentView.bounds.height - transformOffset), 1), 0)
//        let maxScaleDifference: CGFloat = 0.8
//        let scale = percent * maxScaleDifference
        
//        self.transform = CGAffineTransform(scaleX: 1 - scale, y: 1 - scale)
        let factor = contentView.bounds.width / 6 - (7 * 8)
        let scale = factor / UICollectionViewCell.collectionCellWidth // factor
        self.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
}
