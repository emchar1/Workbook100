//
//  TextEntryController.swift
//  Workbook100
//
//  Created by Eddie Char on 5/19/22.
//

import UIKit
import CoreGraphics

typealias SectionText = (title: String, description: String)
protocol TextEntryControllerDelegate: AnyObject {
    func saveText(text: SectionText)
}

class TextEntryController: UIViewController {
    let mainStack = UIStackView()
    let titleTF = UITextField()
    let descriptionTF = UITextField()
    let buttonStack = UIStackView()
    let saveButton = UIButton()
    let cancelButton = UIButton()
    
    weak var delegate: TextEntryControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let padding: CGFloat = 8.0
        
        mainStack.axis = .vertical
        mainStack.distribution = .fill
        mainStack.spacing = padding
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        titleTF.placeholder = "Enter Title"
        titleTF.borderStyle = .roundedRect
        titleTF.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionTF.placeholder = "Enter Description"
        descriptionTF.borderStyle = .roundedRect
        descriptionTF.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.label, for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)

        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.label, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        
        buttonStack.axis = .horizontal
        buttonStack.distribution = .equalSpacing
        buttonStack.spacing = padding
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.addArrangedSubview(saveButton)

        mainStack.addArrangedSubview(titleTF)
        mainStack.addArrangedSubview(descriptionTF)
        mainStack.addArrangedSubview(buttonStack)
        
        view.addSubview(mainStack)
        
        NSLayoutConstraint.activate([mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     mainStack.widthAnchor.constraint(equalToConstant: 300)])
        
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        delegate?.saveText(text: (titleTF.text!, descriptionTF.text!))
        dismiss(animated: true)
    }
}
