//
//  Extension+UICollectionViewCell.swift
//  Workbook100
//
//  Created by Eddie Char on 3/28/22.
//

import UIKit

extension UICollectionViewCell {
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
}
