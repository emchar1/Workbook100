//
//  ActivitySpinner.swift
//  Workbook100
//
//  Created by Eddie Char on 2/28/22.
//

import UIKit

class ActivitySpinner {
    private var spinner = UIActivityIndicatorView()
    
    init(style: UIActivityIndicatorView.Style = .medium, color: UIColor = .darkGray) {
        spinner.style = style
        spinner.color = color
    }
    
    func startSpinner(in view: UIView) {
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    func stopSpinner() {
        OperationQueue.main.addOperation {
            self.spinner.stopAnimating()
        }
    }
}
