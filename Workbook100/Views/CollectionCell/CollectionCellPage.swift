//
//  CollectionCellPage.swift
//  Workbook100
//
//  Created by Eddie Char on 4/27/22.
//

import UIKit

class CollectionCellPage: UICollectionViewCell {
    class var reuseId: String { "CollectionCellPage" }
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    override var isSelected: Bool {
//        didSet {
//            setSelected(isSelected, in: contentView)
//        }
//    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        contentView.layer.shadowColor = UIColor.darkGray.cgColor
        contentView.layer.shadowOffset = CGSize(width: 8, height: 8)
        contentView.layer.shadowOpacity = 0.5
        
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
                                    containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                    contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                                    contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error loading CollectionCellPage")
    }
}
