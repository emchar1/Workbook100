//
//  Extensions.swift
//  Workbook100
//
//  Created by Eddie Char on 2/28/22.
//

import UIKit


// MARK: - UIStoryboard

extension UIStoryboard {
    static var mainStoryboard: UIStoryboard {
        UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    // 2/26/22 Changed these from ProductFilterController to ProductFilterControllerNEW
    static var leftViewController: ProductFilterControllerNEW? {
        mainStoryboard.instantiateViewController(withIdentifier: "ProductFilterControllerNEW") as? ProductFilterControllerNEW
    }
    
    static var centerViewController: WorkbookViewController? {
        mainStoryboard.instantiateViewController(withIdentifier: "WorkbookViewController") as? WorkbookViewController
    }
    
    // FIXME: - Test
    static var leftNavigationController: UINavigationController? {
        mainStoryboard.instantiateViewController(withIdentifier: "Nav2") as? UINavigationController
    }
}


// MARK: - UICollectionViewCell

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


// MARK: - UIFont Extension

extension UIFont {
    static let workbookTitle = UIFont(name: "AvenirNext-Bold", size: 14)!
    static let workbookBubbleTitle = UIFont(name: "AvenirNext-Bold", size: 12)!
    static let workbookSubtitle = UIFont(name: "TimesNewRomanPS-ItalicMT", size: 9)!
    static let workbookFooterTitle = UIFont(name: "TimesNewRomanPS-ItalicMT", size: 10)!
    static let workbookMenuTitle = UIFont(name: "AvenirNext-DemiBold", size: 12)!
    static let workbookMenuSelection = UIFont(name: "AvenirNext-Regular", size: 12)!
    static let workbookNoimg = UIFont(name: "AvenirNext-Regular", size: 16)!
}


// MARK: - UIColor Extension

extension UIColor {
    static let workbookSuperLightGray = UIColor(named: "superLightGray")
    static let workbookIsSelected = UIColor(named: "isSelected")
}



/*
- 2/18 RayWenderlich Dismiss Keyboard
 // Add responder for keyboards to dismiss when tap or drag outside of text fields
 scrollView.addGestureRecognizer(UITapGestureRecognizer(target: scrollView, action: #selector(UIView.endEditing(_:))))
 scrollView.keyboardDismissMode = .onDrag

 */
