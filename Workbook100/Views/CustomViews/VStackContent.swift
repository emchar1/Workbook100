//
//  VStackContent.swift
//  Workbook100
//
//  Created by Eddie Char on 2/23/22.
//

import UIKit


class VStackContent: UIStackView {
    static let cellPadding: CGFloat = 8.0
    
    var titleView: UIView!
    var selectionView: UIView!
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .workbookMenuTitle
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var titleText: String
    var selectionItems: [String]
    var selectedItem: String
    var hStack: HStackSelection!
    
    init(frame: CGRect, titleText: String, selectionItems: [String], selectedItem: String) {
        self.titleText = titleText
        self.selectionItems = selectionItems
        self.selectedItem = selectedItem

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
        
        titleLabel.text = titleText + ":"
        titleView.addSubview(titleLabel)
        NSLayoutConstraint.activate([titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: VStackContent.cellPadding),
                                     titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor)])
        
        hStack = HStackSelection(frame: .zero, selectedItem: selectedItem)
        selectionView.addSubview(hStack)
        NSLayoutConstraint.activate([hStack.topAnchor.constraint(equalTo: selectionView.topAnchor, constant: VStackContent.cellPadding),
                                     hStack.leadingAnchor.constraint(equalTo: selectionView.leadingAnchor, constant: VStackContent.cellPadding),
                                     selectionView.trailingAnchor.constraint(equalTo: hStack.trailingAnchor, constant: VStackContent.cellPadding),
                                     selectionView.bottomAnchor.constraint(equalTo: hStack.bottomAnchor, constant: VStackContent.cellPadding)])
    }
    
    
    func addTrailingPadding(in superView: UIView, padding: CGFloat) {
        NSLayoutConstraint.activate([superView.trailingAnchor.constraint(equalTo: selectionView.trailingAnchor,
                                                                         constant: padding + VStackContent.cellPadding)])
    }
}
