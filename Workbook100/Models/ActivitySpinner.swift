//
//  ActivitySpinner.swift
//  Workbook100
//
//  Created by Eddie Char on 2/28/22.
//

import UIKit

class ActivitySpinner {
    private var spinner = UIActivityIndicatorView()

    var isAnimating: Bool {
        spinner.isAnimating
    }

    
    init(style: UIActivityIndicatorView.Style = .medium, color: UIColor = .systemGray) {
        spinner.style = style
        spinner.color = color
    }
    
    func startSpinner(in view: UIView, offset: CGPoint = .zero) {
        spinner.hidesWhenStopped = true
        spinner.center = CGPoint(x: view.center.x + offset.x,
                                 y: view.center.y + offset.y)
        view.addSubview(spinner)
        
        spinner.startAnimating()
    }
    
    func stopSpinner() {
        OperationQueue.main.addOperation {
            self.spinner.stopAnimating()
        }
    }
}
