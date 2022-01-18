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
        translatesAutoresizingMaskIntoConstraints = false
        
        selectedItemView = UIView()
        selectedItemView.backgroundColor = .white
        selectedItemView.layer.borderColor = UIColor.black.cgColor
        selectedItemView.layer.borderWidth = 1.0
        selectedItemView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        dropdownView = UIView()
        dropdownView.layer.borderColor = UIColor.black.cgColor
        dropdownView.layer.borderWidth = 1.0
        dropdownView.backgroundColor = .black
        dropdownView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        let v = UIView()
        v.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        v.translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(selectedItemView)
        addArrangedSubview(dropdownView)
        addArrangedSubview(v)
        
        selectedItemLabel.text = selectedItem
        selectedItemView.addSubview(selectedItemLabel)
        NSLayoutConstraint.activate([selectedItemView.widthAnchor.constraint(equalToConstant: 100),
                                     //selectedItemLabel.heightAnchor.constraint(equalToConstant: 24),
                                     selectedItemLabel.centerYAnchor.constraint(equalTo: selectedItemView.centerYAnchor),
                                     selectedItemLabel.leadingAnchor.constraint(equalTo: selectedItemView.leadingAnchor,
                                                                                constant: HStackSelection.cellPadding)])

        let triangle = UIImageView()
        triangle.image = UIImage(systemName: "arrowtriangle.down.fill")
        triangle.backgroundColor = .black
        triangle.tintColor = .white
        triangle.translatesAutoresizingMaskIntoConstraints = false
        dropdownView.addSubview(triangle)
//        let v = UILabel()
//        v.font = K.Fonts.menuSelection
//        v.text = "V"
//        v.backgroundColor = .purple
//        v.textColor = .white
//        v.textAlignment = .center
//        v.layer.borderWidth = 1.0
//        v.layer.borderColor = UIColor.blue.cgColor
//        v.translatesAutoresizingMaskIntoConstraints = false
//        dropdownView.addSubview(v)
        NSLayoutConstraint.activate([dropdownView.widthAnchor.constraint(equalToConstant: 30),
                                     triangle.widthAnchor.constraint(equalToConstant: 12),
                                     triangle.heightAnchor.constraint(equalToConstant: 14),
                                     triangle.centerYAnchor.constraint(equalTo: dropdownView.centerYAnchor),
                                     triangle.centerXAnchor.constraint(equalTo: dropdownView.centerXAnchor),
                                     v.widthAnchor.constraint(equalToConstant: 99)])

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
        selectionView = UIView()
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
                                     titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor)])

        let hv = HStackSelection(frame: .zero, selectedItem: selectedItem)
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
        view.backgroundColor = K.Colors.superLightGray
        
        let titleLabel = UILabel()
        titleLabel.text = "Filters (WIP)"
        titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
                                     titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     titleLabel.widthAnchor.constraint(equalToConstant: 100)])
        
        let vstack = VStackContent(frame: .zero, titleText: "Collection", selectionItems: ["SP23", "FA22", "SP22"])
        vstack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vstack)
        NSLayoutConstraint.activate([vstack.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
                                     vstack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     vstack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     vstack.heightAnchor.constraint(equalToConstant: 100)])
        
        let vstack2 = VStackContent(frame: .zero, titleText: "Product Category", selectionItems: ["Gear", "Apparel", "Accessories"])
        vstack2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vstack2)
        NSLayoutConstraint.activate([vstack2.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
                                     vstack2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     vstack2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     vstack2.heightAnchor.constraint(equalToConstant: 100)])

        let vstack3 = VStackContent(frame: .zero, titleText: "Class", selectionItems: ["Gloves", "Helmets", "Bibs"])
        vstack3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vstack3)
        NSLayoutConstraint.activate([vstack3.topAnchor.constraint(equalTo: view.topAnchor, constant: 260),
                                     vstack3.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     vstack3.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     vstack3.heightAnchor.constraint(equalToConstant: 100)])
        
        view.addSubview(doneButton)
        NSLayoutConstraint.activate([doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 440),
                                     doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
                                     doneButton.widthAnchor.constraint(equalToConstant: 80),
                                     doneButton.heightAnchor.constraint(equalToConstant: 50)])
    }
}
