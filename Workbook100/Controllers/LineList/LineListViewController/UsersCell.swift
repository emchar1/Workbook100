//
//  UsersCell.swift
//  Workbook100
//
//  Created by Eddie Char on 12/13/22.
//

import UIKit

class UsersCell: UITableViewCell {
    
    // MARK: - Properties
    
    class var reuseID: String { "usersCell" }
    var label: UILabel!
    
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        layoutViews()
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        setupViews()
//        layoutViews()
//    }
    
//    override init(frame: CGRect) {
//        setupViews()
//        layoutViews()
//
//        super.init(frame: frame)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        label = UILabel()
        label.font = UIFont(name: "AvenirNext-Regular", size: 12)
        label.textColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false

    }
    
    private func layoutViews() {
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: label.trailingAnchor)
        ])
    }
}
