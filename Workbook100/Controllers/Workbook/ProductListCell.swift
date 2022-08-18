//
//  ProductListCell.swift
//  Workbook100
//
//  Created by Eddie Char on 5/6/22.
//

import UIKit

class ProductListCell: UITableViewCell {
    static let reuseID = "ProductListCell"
    static let imageSize: CGFloat = 95
    
    var hStackView: UIStackView!

    var productView: UIView!
    var productImage: UIImageView!
    var productImageNoImg: UILabel!

    var hSubStackView: UIStackView!

    var vStackView: UIStackView!
    var hNewEssentialStackView: UIStackView!
    var labelNew: CollectionCellLabelBubble!
    var labelEssential: CollectionCellLabelBubble!
    var labelBlank: CollectionCellLabelBubble!
    
    var labelTitle: UILabel!
    var labelSubtitle: UILabel!

    var labelSizes: UILabel!

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
        productImageNoImg.text = "Image\nComing\nSoon"
        productImageNoImg.numberOfLines = 0
        productImageNoImg.font = .workbookNoimg// UIFont(name: "AvenirNextCondensed-DemiBold", size: 14)
        productImageNoImg.textColor = .lightGray
        productImageNoImg.textAlignment = .center
        productImageNoImg.translatesAutoresizingMaskIntoConstraints = false
        
        hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.distribution = .fill
        hStackView.spacing = 20
        hStackView.translatesAutoresizingMaskIntoConstraints = false

        hSubStackView = UIStackView()
        hSubStackView.axis = .horizontal
        hSubStackView.distribution = .fillEqually
        hSubStackView.spacing = 20
        hSubStackView.translatesAutoresizingMaskIntoConstraints = false
        
        hNewEssentialStackView = UIStackView()
        hNewEssentialStackView.axis = .horizontal
        hNewEssentialStackView.distribution = .fillEqually
        hNewEssentialStackView.translatesAutoresizingMaskIntoConstraints = false
        
        labelNew = CollectionCellLabelBubble(type: .new)
        labelEssential = CollectionCellLabelBubble(type: .essential)
        labelBlank = CollectionCellLabelBubble(type: .blank)

        vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.distribution = .fillProportionally
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        labelTitle = UILabel()
        labelTitle.font = .productListTitle
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        
        labelSubtitle = UILabel()
        labelSubtitle.font = .productListViewText
        labelSubtitle.translatesAutoresizingMaskIntoConstraints = false
        
        labelSizes = UILabel()
        labelSizes.numberOfLines = 0
        labelSizes.font = .productListViewText
        labelSizes.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layoutViews() {
        let imageViewPadding: CGFloat = 4
        let labelBubbleSize: CGFloat = 20
        
        addSubview(hStackView)
        
        hStackView.addArrangedSubview(productView)
        productView.addSubview(productImage)
        productView.addSubview(productImageNoImg)
        
        hStackView.addArrangedSubview(hSubStackView)
        hSubStackView.addArrangedSubview(vStackView)
        
        vStackView.addArrangedSubview(hNewEssentialStackView)
        hNewEssentialStackView.addArrangedSubview(labelNew)
        hNewEssentialStackView.addArrangedSubview(labelEssential)
        hNewEssentialStackView.addArrangedSubview(labelBlank)
        
        vStackView.addArrangedSubview(labelTitle)
        vStackView.addArrangedSubview(labelSubtitle)
        
        hSubStackView.addArrangedSubview(labelSizes)
        
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

            hSubStackView.topAnchor.constraint(equalTo: hStackView.arrangedSubviews[1].topAnchor),
            hSubStackView.leadingAnchor.constraint(equalTo: hStackView.arrangedSubviews[1].leadingAnchor),
            hStackView.arrangedSubviews[1].trailingAnchor.constraint(equalTo: hSubStackView.trailingAnchor),
            hStackView.arrangedSubviews[1].bottomAnchor.constraint(equalTo: hSubStackView.bottomAnchor),

            vStackView.topAnchor.constraint(equalTo: hSubStackView.arrangedSubviews[0].topAnchor),
            vStackView.leadingAnchor.constraint(equalTo: hSubStackView.arrangedSubviews[0].leadingAnchor),
            hSubStackView.arrangedSubviews[0].trailingAnchor.constraint(equalTo: vStackView.trailingAnchor),
            hSubStackView.arrangedSubviews[0].bottomAnchor.constraint(equalTo: vStackView.bottomAnchor),

            hNewEssentialStackView.centerYAnchor.constraint(equalTo: vStackView.arrangedSubviews[0].centerYAnchor),
            hNewEssentialStackView.leadingAnchor.constraint(equalTo: vStackView.arrangedSubviews[0].leadingAnchor),
            vStackView.arrangedSubviews[0].trailingAnchor.constraint(equalTo: hNewEssentialStackView.trailingAnchor),
            hNewEssentialStackView.heightAnchor.constraint(equalToConstant: labelBubbleSize),

            labelNew.centerYAnchor.constraint(equalTo: hNewEssentialStackView.arrangedSubviews[0].centerYAnchor),
            labelNew.leadingAnchor.constraint(equalTo: hNewEssentialStackView.arrangedSubviews[0].leadingAnchor),
            hNewEssentialStackView.arrangedSubviews[0].trailingAnchor.constraint(equalTo: labelNew.trailingAnchor),
            labelNew.heightAnchor.constraint(equalToConstant: labelBubbleSize),
            labelEssential.centerYAnchor.constraint(equalTo: hNewEssentialStackView.arrangedSubviews[1].centerYAnchor),
            labelEssential.leadingAnchor.constraint(equalTo: hNewEssentialStackView.arrangedSubviews[1].leadingAnchor),
            hNewEssentialStackView.arrangedSubviews[1].trailingAnchor.constraint(equalTo: labelEssential.trailingAnchor),
            labelEssential.heightAnchor.constraint(equalToConstant: labelBubbleSize),
            labelBlank.centerYAnchor.constraint(equalTo: hNewEssentialStackView.arrangedSubviews[2].centerYAnchor),
            labelBlank.leadingAnchor.constraint(equalTo: hNewEssentialStackView.arrangedSubviews[2].leadingAnchor),
            hNewEssentialStackView.arrangedSubviews[2].trailingAnchor.constraint(equalTo: labelBlank.trailingAnchor),
            labelBlank.heightAnchor.constraint(equalToConstant: labelBubbleSize),

            labelTitle.centerYAnchor.constraint(equalTo: vStackView.arrangedSubviews[1].centerYAnchor),
            labelTitle.leadingAnchor.constraint(equalTo: vStackView.arrangedSubviews[1].leadingAnchor),
            vStackView.arrangedSubviews[1].trailingAnchor.constraint(equalTo: labelTitle.trailingAnchor),

            labelSubtitle.centerYAnchor.constraint(equalTo: vStackView.arrangedSubviews[2].centerYAnchor),
            labelSubtitle.leadingAnchor.constraint(equalTo: vStackView.arrangedSubviews[2].leadingAnchor),
            vStackView.arrangedSubviews[2].trailingAnchor.constraint(equalTo: labelSubtitle.trailingAnchor),

            labelSizes.centerYAnchor.constraint(equalTo: hSubStackView.arrangedSubviews[1].centerYAnchor),
            labelSizes.leadingAnchor.constraint(equalTo: hSubStackView.arrangedSubviews[1].leadingAnchor),
            hSubStackView.arrangedSubviews[1].trailingAnchor.constraint(equalTo: labelSizes.trailingAnchor),
        ])
    }
    
    func setViews(_ model: CollectionModel) {
        labelNew.type = .new
        labelEssential.type = .essential
        labelBlank.type = .blank
        
        labelNew.isHidden = model.carryOver
        labelEssential.isHidden = !model.essential
//        labelBlank.isHidden = !(model.carryOver && !model.essential)
        labelBlank.isHidden = !(labelNew.isHidden && labelEssential.isHidden)
        
        labelTitle.text = model.productNameDescription
        labelSubtitle.text = model.productNameDescriptionSecondary
        labelSizes.text = layoutSizes(model)
        
        
        //NEW WAY Product Image - Load images from Amplifi using ImageLoader Utility
        if let url = URL(string: model.thumbURL) {
            spinner.startSpinner(in: productImage)
            productImage.loadImage(at: url, completion: {
                self.spinner.stopSpinner()
            })
            
            productImageNoImg.isHidden = model.thumbURL != "#N/A" ? true : false
        }
    }
    
    private func layoutSizes(_ model: CollectionModel) -> String {
        let numberFormatter = NumberFormatter()
        var sizes = ""
        
        numberFormatter.numberStyle = .decimal

        for (i, size) in model.sizes.enumerated() {
            if i < model.sizes.count && size.size != "" {
                sizes += "\(size.size ?? "NA"):\t\(size.colorwaySKU ?? "XXXXX-XXXXX"),\tQOH: \(numberFormatter.string(from: NSNumber(value: size.qoh ?? -9999))!)\n"
            }
        }
        
        return sizes
    }
 
}
