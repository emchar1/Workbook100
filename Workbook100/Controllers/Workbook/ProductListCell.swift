//
//  ProductListCell.swift
//  Workbook100
//
//  Created by Eddie Char on 5/6/22.
//

import UIKit

class ProductListCell: UITableViewCell {
    static let reuseID = "ProductListCell"
    
    let stackView = UIStackView()
    let labelSKU = UILabel()
    let labelDesc = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.addArrangedSubview(labelSKU)
        stackView.addArrangedSubview(labelDesc)
        
//        addSubview(labelSKU)
//        labelSKU.translatesAutoresizingMaskIntoConstraints = false
//
//        addSubview(labelDesc)
//        labelDesc.translatesAutoresizingMaskIntoConstraints = false
        
//        NSLayoutConstraint.activate([labelSKU.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//                                     labelDesc.leadingAnchor.constraint(equalTo: labelSKU.trailingAnchor, constant: 40),
//                                     labelSKU.centerYAnchor.constraint(equalTo: centerYAnchor),
//                                     trailingAnchor.constraint(equalTo: labelDesc.trailingAnchor, constant: 20),
//                                     labelDesc.centerYAnchor.constraint(equalTo: centerYAnchor)])
        
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: topAnchor),
                                     stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                                     trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 20),
                                     bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
                                     stackView.arrangedSubviews[0].widthAnchor.constraint(equalToConstant: 125)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error loading ProductListCell")
    }
}
