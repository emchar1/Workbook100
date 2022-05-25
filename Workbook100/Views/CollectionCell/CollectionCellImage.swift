//
//  CollectionCellImage.swift
//  Workbook100
//
//  Created by Eddie Char on 5/17/22.
//

import UIKit

class CollectionCellImage: UICollectionViewCell {
    class var reuseID: String { "CollectionCellImage" }
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     contentView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
                                     contentView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error loading CollectionCellImage")
    }
}
