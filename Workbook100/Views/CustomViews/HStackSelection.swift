//
//  HStackSelection.swift
//  Workbook100
//
//  Created by Eddie Char on 2/23/22.
//

import UIKit


class HStackSelection: UIStackView {
    static let cellPadding: CGFloat = 8.0
    
    var selectedItemView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var dropdownButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        button.backgroundColor = .black
        button.layer.borderColor = UIColor.black.cgColor
        button.tintColor = .white
        button.layer.borderWidth = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var selectedItemLabel: UILabel = {
        let label = UILabel()
        label.font = .workbookMenuSelection
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
        
        selectedItemLabel.text = selectedItem
        
        addArrangedSubview(selectedItemView)
        addArrangedSubview(dropdownButton)
        selectedItemView.addSubview(selectedItemLabel)

        NSLayoutConstraint.activate([selectedItemLabel.centerYAnchor.constraint(equalTo: selectedItemView.centerYAnchor),
                                     selectedItemLabel.leadingAnchor.constraint(equalTo: selectedItemView.leadingAnchor,
                                                                                constant: HStackSelection.cellPadding),
                                     selectedItemView.trailingAnchor.constraint(equalTo: selectedItemLabel.trailingAnchor,
                                                                                constant: HStackSelection.cellPadding)])
        
        NSLayoutConstraint.activate([dropdownButton.widthAnchor.constraint(equalToConstant: 34)])
    }
}
