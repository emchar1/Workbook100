//
//  CollectionCellText.swift
//  Workbook100
//
//  Created by Eddie Char on 5/18/22.
//

import UIKit

class CollectionCellText: UICollectionViewCell {
    class var reuseID: String { "CollectionCellText" }
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        titleLabel.font = .workbookTextTitle
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        descriptionLabel.font = .workbookTextDescription
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
                                     titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.frame.height / 4),
                                     contentView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 40),
                                     descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
                                     descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
                                     contentView.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor, constant: 40)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error loading CollectionCellText")
    }
    
    
}
