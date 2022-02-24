//
//  CollectionCell.swift
//  Workbook100
//
//  Created by Eddie Char on 12/17/21.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    // MARK: - Properties
    class var reuseId: String { "CollectionCell" }
    var spinner = ActivitySpinner()
    var model: CollectionModel!

    var vStack: CollectionCellStack!
    
    var hStackTop: CollectionCellStack!
    var labelNew: CollectionCellLabelBubble!
    var labelEssential: CollectionCellLabelBubble!
    var labelNothing: CollectionCellLabelBubble!
    
    var labelTitle: CollectionCellLabel!
    var labelSubtitle: CollectionCellLabel!
    
    var productImage: UIImageView!
    var productImageNoImg: UILabel = {
        let noimg = UILabel()
        noimg.text = "No Image"
        noimg.textColor = .gray
        noimg.translatesAutoresizingMaskIntoConstraints = false
        return noimg
    }()
    
    override var isSelected: Bool {
        didSet {
            setSelected(isSelected, in: contentView)
        }
    }
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        productImage.image = nil
        productImage.cancelImageLoad()
    }
    
    func setViews() {
        //New & Essential Stack
        hStackTop.subviews[0].isHidden = model.carryOver
        hStackTop.subviews[1].isHidden = !model.essential
        hStackTop.subviews[2].isHidden = !(model.carryOver && !model.essential)

        //Product Title
        labelTitle.text = model.productNameDescription
        labelSubtitle.text = model.productNameDescriptionSecondary
        
        //OLD WAY Uses images saved in Firebase Storage
//        if let image = model.image {
//            image.downloadURL { (url, error) in
//                self.productImageNoImg.isHidden = (url != nil ? true : false)
//            }
//
//            productImage.sd_setImage(with: image)
//        }
        
        //NEW WAY Product Image - Load images from Amplifi using ImageLoader Utility
        if let url = URL(string: model.thumbURL) {
            spinner.startSpinner(in: contentView)
            productImage.loadImage(at: url, completion: { self.spinner.stopSpinner() })
            productImageNoImg.isHidden = true
        }
        else {
            productImageNoImg.isHidden = false
        }
    }
    
    
    // MARK: - Helper Functions
    
    func setupViews() {
        self.model = CollectionModel.getBlankModel()
        
        //==SETUP==//
        //Content View
//        contentView.backgroundColor = .magenta
//        contentView.layer.cornerRadius = K.CollectionCell.cornerRadius
//        contentView.clipsToBounds = true

        //VStack
        vStack = CollectionCellStack(distribution: .fill, alignment: .fill, axis: .vertical)
        
        //New & Essential Stack
        hStackTop = CollectionCellStack(spacing: 2, distribution: .fillEqually, alignment: .fill, axis: .horizontal)
        labelNew = CollectionCellLabelBubble(type: .new)
        labelEssential = CollectionCellLabelBubble(type: .essential)
        labelNothing = CollectionCellLabelBubble(type: .nothing)
        
        //Product Title
        labelTitle = CollectionCellLabel(type: .title, text: model.productNameDescription)
        labelSubtitle = CollectionCellLabel(type: .subtitle, text: model.productNameDescriptionSecondary)
        
        //Product Image
        productImage = UIImageView()
        

        
        //==SUBVIEWS==//
        //VStack
        contentView.addSubview(vStack)
        NSLayoutConstraint.activate([vStack.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     contentView.trailingAnchor.constraint(equalTo: vStack.trailingAnchor),
                                     contentView.bottomAnchor.constraint(equalTo: vStack.bottomAnchor)])
        
        //New & Essential Stack
        vStack.addArrangedSubview(hStackTop)
        hStackTop.addArrangedSubview(labelNew)
        hStackTop.addArrangedSubview(labelEssential)
        hStackTop.addArrangedSubview(labelNothing)
        
        //Product Title
        vStack.addArrangedSubview(labelTitle)
        vStack.addArrangedSubview(labelSubtitle)

        //Product Image
        productImage.contentMode = .scaleAspectFill
        productImage.clipsToBounds = true
        productImage.backgroundColor = .workbookSuperLightGray
        productImage.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(productImage)
        NSLayoutConstraint.activate([productImage.widthAnchor.constraint(equalTo: contentView.widthAnchor)])
        productImage.addSubview(productImageNoImg)
        NSLayoutConstraint.activate([productImageNoImg.centerXAnchor.constraint(equalTo: productImage.centerXAnchor),
                                     productImageNoImg.centerYAnchor.constraint(equalTo: productImage.centerYAnchor)])
    }
}
