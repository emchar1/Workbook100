//
//  ProductFilterController.swift
//  Workbook100
//
//  Created by Eddie Char on 1/15/22.
//

import UIKit

protocol ProductFilterControllerDelegate {
    func youDonePressedDone()
}

class ProductFilterController: UIViewController {
    var delegate: ProductFilterControllerDelegate?
    
    var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(donePressed(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func donePressed(_ sender: UIButton) {
        delegate?.youDonePressedDone()
    }
    
    override func viewDidLoad() {
        view.addSubview(doneButton)
        NSLayoutConstraint.activate([doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
                                     doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                     doneButton.widthAnchor.constraint(equalToConstant: 60),
                                     doneButton.heightAnchor.constraint(equalToConstant: 40)])
    }
}
