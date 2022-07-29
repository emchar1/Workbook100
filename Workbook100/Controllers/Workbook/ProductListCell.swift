//
//  ProductListCell.swift
//  Workbook100
//
//  Created by Eddie Char on 5/6/22.
//

import UIKit

class ProductListCell: UITableViewCell {
    static let reuseID = "ProductListCell"
    static let imageSize: CGFloat = 80
    
    var hStackView: UIStackView!
    var vStackView: UIStackView!
    var labelSKU: UILabel!
    var labelDesc: UILabel!
    var labelQOH: UILabel!
    var productView: UIView!
    var productImage: UIImageView!
    var productImageNoImg: UILabel!
    private var spinner = ActivitySpinner()

        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error loading ProductListCell")
    }
    
    //THIS PREVENTS IMAGES FROM RECYCLE LOADING, WHICH LOOKS WEIRD!!
    override func prepareForReuse() {
        super.prepareForReuse()

        productImage.image = nil
        productImage.cancelImageLoad()
    }
    
    private func setupViews() {
        productView = UIView()
        productView.translatesAutoresizingMaskIntoConstraints = false
                
        productImage = UIImageView()
        productImage.layer.cornerRadius = 6
        productImage.clipsToBounds = true
        productImage.translatesAutoresizingMaskIntoConstraints = false
        
        productImageNoImg = UILabel()
        productImageNoImg.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 14)
        productImageNoImg.textColor = .lightGray
        productImageNoImg.textAlignment = .center
        productImageNoImg.translatesAutoresizingMaskIntoConstraints = false
        
        hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .fill
        hStackView.spacing = 20
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        
        vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.distribution = .fillEqually
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        labelSKU = UILabel()
        labelSKU.font = .productListViewText
        labelSKU.translatesAutoresizingMaskIntoConstraints = false
        
        labelDesc = UILabel()
        labelDesc.font = .productListViewText
        labelDesc.translatesAutoresizingMaskIntoConstraints = false
        
        labelQOH = UILabel()
        labelQOH.font = .productListViewText
        labelQOH.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layoutViews() {
        let imageViewPadding: CGFloat = 4
        
        addSubview(hStackView)
        hStackView.addArrangedSubview(productView)
        productView.addSubview(productImage)
        productView.addSubview(productImageNoImg)
        hStackView.addArrangedSubview(vStackView)
        
        vStackView.addArrangedSubview(labelSKU)
        vStackView.addArrangedSubview(labelDesc)
        vStackView.addArrangedSubview(labelQOH)
        
        NSLayoutConstraint.activate([
            hStackView.topAnchor.constraint(equalTo: topAnchor),
            hStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: hStackView.trailingAnchor),
            bottomAnchor.constraint(equalTo: hStackView.bottomAnchor),
            
            productView.topAnchor.constraint(equalTo: hStackView.arrangedSubviews[0].topAnchor),
            productView.leadingAnchor.constraint(equalTo: hStackView.arrangedSubviews[0].leadingAnchor),
            hStackView.arrangedSubviews[0].trailingAnchor.constraint(equalTo: productView.trailingAnchor),
            hStackView.arrangedSubviews[0].bottomAnchor.constraint(equalTo: productView.bottomAnchor),
            productView.widthAnchor.constraint(equalToConstant: ProductListCell.imageSize),
            
            productImage.centerXAnchor.constraint(equalTo: productView.centerXAnchor),
            productImage.centerYAnchor.constraint(equalTo: productView.centerYAnchor),
            productImage.widthAnchor.constraint(equalToConstant: ProductListCell.imageSize - 2 * imageViewPadding),
            productImage.heightAnchor.constraint(equalTo: productImage.widthAnchor),
            
            productImageNoImg.centerXAnchor.constraint(equalTo: productView.centerXAnchor),
            productImageNoImg.centerYAnchor.constraint(equalTo: productView.centerYAnchor),
            
            vStackView.topAnchor.constraint(equalTo: hStackView.arrangedSubviews[1].topAnchor),
            vStackView.leadingAnchor.constraint(equalTo: hStackView.arrangedSubviews[1].leadingAnchor),
            hStackView.arrangedSubviews[1].trailingAnchor.constraint(equalTo: vStackView.trailingAnchor),
            hStackView.arrangedSubviews[1].bottomAnchor.constraint(equalTo: vStackView.bottomAnchor),
            
            labelSKU.centerYAnchor.constraint(equalTo: vStackView.arrangedSubviews[0].centerYAnchor),
            labelSKU.leadingAnchor.constraint(equalTo: vStackView.arrangedSubviews[0].leadingAnchor),
            vStackView.arrangedSubviews[0].trailingAnchor.constraint(equalTo: labelSKU.trailingAnchor),

            labelDesc.centerYAnchor.constraint(equalTo: vStackView.arrangedSubviews[1].centerYAnchor),
            labelDesc.leadingAnchor.constraint(equalTo: vStackView.arrangedSubviews[1].leadingAnchor),
            vStackView.arrangedSubviews[1].trailingAnchor.constraint(equalTo: labelDesc.trailingAnchor),

            labelQOH.centerYAnchor.constraint(equalTo: vStackView.arrangedSubviews[2].centerYAnchor),
            labelQOH.leadingAnchor.constraint(equalTo: vStackView.arrangedSubviews[2].leadingAnchor),
            vStackView.arrangedSubviews[2].trailingAnchor.constraint(equalTo: labelQOH.trailingAnchor),
        ])
    }
    
    func setViews(_ model: CollectionModel) {
        labelSKU.text = model.skuCode
        labelDesc.text = model.productNameDescription + " - " + model.productNameDescriptionSecondary
        labelQOH.text = "QOH: \(model.sizes[0].qoh ?? -999), \(model.sizes[1].qoh ?? -999)"
        
        
        //NEW WAY Product Image - Load images from Amplifi using ImageLoader Utility
        if let url = URL(string: model.thumbURL) {
            spinner.startSpinner(in: productImage)
            productImage.loadImage(at: url, completion: {
                self.spinner.stopSpinner()
            })
            
            productImageNoImg.isHidden = model.thumbURL != "#N/A" ? true : false
        }
    }
 
}
