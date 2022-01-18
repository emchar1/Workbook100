//
//  ProductFilterController.swift
//  Workbook100
//
//  Created by Eddie Char on 1/15/22.
//

import UIKit

// MARK: - HStackSelection

class HStackSelection: UIStackView {
    static let cellPadding: CGFloat = 8.0
    
    var selectedItemView: UIView!
    var dropdownView: UIView!
    var selectedItemLabel: UILabel = {
        let label = UILabel()
        label.font = K.Fonts.menuSelection
        label.textColor = .black
        label.backgroundColor = .systemOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var selectedItem: String

    
    init(frame: CGRect, selectedItem: String) {
        self.selectedItem = selectedItem

        super.init(frame: frame)
        
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("Error loading HStackSelection in ProductFilterController")
    }
    
    private func setupViews() {
        axis = .horizontal
        distribution = .fillProportionally
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        translatesAutoresizingMaskIntoConstraints = false
        
        selectedItemView = UIView()
        selectedItemView.backgroundColor = .systemCyan
        selectedItemView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        dropdownView = UIView()
        dropdownView.backgroundColor = .systemRed
        dropdownView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        addArrangedSubview(selectedItemView)
        addArrangedSubview(dropdownView)
        
        selectedItemLabel.text = selectedItem
        selectedItemView.addSubview(selectedItemLabel)
        NSLayoutConstraint.activate([selectedItemLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
                                     selectedItemLabel.heightAnchor.constraint(equalToConstant: 24),
                                     selectedItemLabel.centerYAnchor.constraint(equalTo: selectedItemView.centerYAnchor),
                                     selectedItemLabel.leadingAnchor.constraint(equalTo: selectedItemView.leadingAnchor,
                                                                                constant: HStackSelection.cellPadding)])

        let v = UILabel()
        v.font = K.Fonts.menuSelection
        v.text = "VVVVVVVVV"
        v.backgroundColor = .purple
        v.textColor = .white
        v.layer.borderWidth = 1.0
        v.layer.borderColor = UIColor.blue.cgColor
        v.translatesAutoresizingMaskIntoConstraints = false
        dropdownView.addSubview(v)
        NSLayoutConstraint.activate([v.widthAnchor.constraint(greaterThanOrEqualToConstant: 90),
                                     v.heightAnchor.constraint(equalToConstant: 24),
                                     v.centerYAnchor.constraint(equalTo: dropdownView.centerYAnchor),
                                     v.leadingAnchor.constraint(equalTo: dropdownView.leadingAnchor)])

    }
}


// MARK: - VStackContent

class VStackContent: UIStackView {
    static let cellPadding: CGFloat = 8.0
    
    var titleView: UIView!
    var selectionView: UIView!
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = K.Fonts.menuTitle
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var titleText: String
    var selectionItems: [String]
    var selectedItem: String
    
    init(frame: CGRect, titleText: String, selectionItems: [String]) {
        self.titleText = titleText
        self.selectionItems = selectionItems
        selectedItem = selectionItems.count > 0 ? selectionItems[0] : "Error"

        super.init(frame: frame)
        
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("Error loading VStackContent in ProductFilterController")
    }
    
    private func setupViews() {
        distribution = .fillEqually
        axis = .vertical

        titleView = UIView()
        titleView.backgroundColor = .systemYellow
        selectionView = UIView()
        selectionView.backgroundColor = .systemGreen
        addArrangedSubview(titleView)
        addArrangedSubview(selectionView)
        
//        NSLayoutConstraint.activate([selectionView.topAnchor.constraint(equalTo: arrangedSubviews[1].topAnchor, constant: VStackContent.cellPadding),
//                                     selectionView.leadingAnchor.constraint(equalTo: arrangedSubviews[1].leadingAnchor, constant: VStackContent.cellPadding),
//                                     arrangedSubviews[1].trailingAnchor.constraint(equalTo: selectionView.trailingAnchor, constant: VStackContent.cellPadding),
//                                     arrangedSubviews[1].bottomAnchor.constraint(equalTo: selectionView.bottomAnchor, constant: VStackContent.cellPadding)])

        titleLabel.text = titleText + ":"
        titleView.addSubview(titleLabel)
        NSLayoutConstraint.activate([titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
                                     titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: VStackContent.cellPadding),
                                     titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor)])

        let hv = HStackSelection(frame: .zero, selectedItem: "Product Category")
        selectionView.addSubview(hv)
        NSLayoutConstraint.activate([hv.topAnchor.constraint(equalTo: selectionView.topAnchor, constant: VStackContent.cellPadding),
                                     hv.leadingAnchor.constraint(equalTo: selectionView.leadingAnchor, constant: VStackContent.cellPadding),
                                     selectionView.trailingAnchor.constraint(equalTo: hv.trailingAnchor, constant: VStackContent.cellPadding),
                                     selectionView.bottomAnchor.constraint(equalTo: hv.bottomAnchor, constant: VStackContent.cellPadding)])
        
    }
}


// MARK: - ProductFilterController

protocol ProductFilterControllerDelegate {
    func youDonePressedDone()
}

class ProductFilterController: UIViewController {

    // MARK: - Properties
    
    var delegate: ProductFilterControllerDelegate?
    
    var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(donePressed(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func donePressed(_ sender: UIButton) {
        delegate?.youDonePressedDone()
    }
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        
        let vstack = VStackContent(frame: .zero, titleText: "Title", selectionItems: ["Red", "Green", "Blue"])
        vstack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vstack)
        NSLayoutConstraint.activate([vstack.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
                                     vstack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     vstack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     vstack.heightAnchor.constraint(equalToConstant: 80)])
        
        
        
        
        view.addSubview(doneButton)
        NSLayoutConstraint.activate([doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 360),
                                     doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                                     doneButton.widthAnchor.constraint(equalToConstant: 60),
                                     doneButton.heightAnchor.constraint(equalToConstant: 40)])
    }
}
