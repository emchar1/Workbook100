//
//  ProductListCell.swift
//  Workbook100
//
//  Created by Eddie Char on 5/6/22.
//

import UIKit

class ProductListCell: UITableViewCell {
    static let reuseID = "ProductListCell"
    
    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: topAnchor),
                                    label.leadingAnchor.constraint(equalTo: leadingAnchor),
                                    trailingAnchor.constraint(equalTo: label.trailingAnchor),
                                    bottomAnchor.constraint(equalTo: label.bottomAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Can't bank worth a damn")
    }
}
