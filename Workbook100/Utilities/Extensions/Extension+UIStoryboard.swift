//
//  Extension+UIStoryboard.swift
//  Workbook100
//
//  Created by Eddie Char on 2/28/22.
//

import UIKit

extension UIStoryboard {
    static var mainStoryboard: UIStoryboard {
        UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    // 2/26/22 Changed these from ProductFilterController to ProductFilterControllerNEW. And back to ProductFilterController on 4/11/22.
    static var leftViewController: ProductFilterController? {
        mainStoryboard.instantiateViewController(withIdentifier: "ProductFilterController") as? ProductFilterController
    }
    
    static var centerViewController: LineListViewController? {
        mainStoryboard.instantiateViewController(withIdentifier: "LineListViewController") as? LineListViewController
    }
    
    // FIXME: - Test
    static var leftNavigationController: UINavigationController? {
        mainStoryboard.instantiateViewController(withIdentifier: "Nav2") as? UINavigationController
    }
}

/*
- 2/18 RayWenderlich Dismiss Keyboard
 // Add responder for keyboards to dismiss when tap or drag outside of text fields
 scrollView.addGestureRecognizer(UITapGestureRecognizer(target: scrollView, action: #selector(UIView.endEditing(_:))))
 scrollView.keyboardDismissMode = .onDrag

 */
