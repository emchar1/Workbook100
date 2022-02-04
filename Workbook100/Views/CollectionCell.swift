//
//  CollectionCell.swift
//  Workbook100
//
//  Created by Eddie Char on 12/17/21.
//

import UIKit
import FirebaseStorageUI


class CollectionCell: UICollectionViewCell {
    
    // MARK: - Properties
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
    
//    var ruleLine: RuleLine!
//    var hStackBottom: CollectionCellStack!
//    var labelSizesLeft: CollectionCellLabel!
//    var labelSizesRight: CollectionCellLabel!

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
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//
//        productImage.image = nil
//        productImage.cancelImageLoad()
//    }
    
    func setViews() {
        labelTitle.text = model.productNameDescription
        labelSubtitle.text = model.productNameDescriptionSecondary + "\n" + model.colorway
        
//
//        if contentView.frame.width >= 200 {
//            hStackBottom.isHidden = false
//            ruleLine.isHidden = false
//        }
//        else {
//            hStackBottom.isHidden = true
//            ruleLine.isHidden = true
//        }
//
//        labelSizesLeft.text = layoutSizes().left
//        labelSizesRight.text = layoutSizes().right
//
        //OLD WAY Uses images saved in Firebase Storage
//        if let image = model.image {
//            image.downloadURL { (url, error) in
//                self.productImageNoImg.isHidden = (url != nil ? true : false)
//            }
//
//            productImage.sd_setImage(with: image)
//        }
        //NEW WAY
        if let url = URL(string: model.thumbURL) {
            productImage.loadImage(at: url)
            productImageNoImg.isHidden = true
        }
        else {
            productImageNoImg.isHidden = false
        }

        // FIXME: - This is sooo clunky - hStackTop
        hStackTop.subviews[0].isHidden = model.carryOver
        hStackTop.subviews[1].isHidden = !model.essential
        hStackTop.subviews[2].isHidden = !(model.carryOver && !model.essential)
    }
    
    
    // MARK: - Helper Functions
    
    private func setupViews() {
        self.model = CollectionModel.getBlankModel()
        
        contentView.layer.cornerRadius = K.CollectionCell.cornerRadius
//        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
        
        vStack = CollectionCellStack(distribution: .fill, alignment: .fill, axis: .vertical)
        hStackTop = CollectionCellStack(spacing: 2, distribution: .fillEqually, alignment: .fill, axis: .horizontal)
        labelNew = CollectionCellLabelBubble(type: .new)
        labelEssential = CollectionCellLabelBubble(type: .essential)
        labelNothing = CollectionCellLabelBubble(type: .nothing)
        labelTitle = CollectionCellLabel(type: .title, text: model.productNameDescription)
        labelSubtitle = CollectionCellLabel(type: .subtitle, text: model.colorway)
        productImage = UIImageView()
//        ruleLine = RuleLine(frame: CGRect(x: 0, y: 0, width: K.CollectionCell.width, height: 20))
//        hStackBottom = CollectionCellStack(distribution: .fillEqually, alignment: .fill, axis: .horizontal)
//        labelSizesLeft =  CollectionCellLabel(type: .productSize, text: layoutSizes().left)
//        labelSizesRight =  CollectionCellLabel(type: .productSize, text: layoutSizes().right)
        
//        let padding: CGFloat = K.CollectionCell.padding

        contentView.addSubview(vStack)
        NSLayoutConstraint.activate([vStack.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     contentView.trailingAnchor.constraint(equalTo: vStack.trailingAnchor),
                                     contentView.bottomAnchor.constraint(equalTo: vStack.bottomAnchor)])
        
        //New and Essential
        vStack.addArrangedSubview(hStackTop)
        hStackTop.addArrangedSubview(labelNew)
        hStackTop.addArrangedSubview(labelEssential)
        hStackTop.addArrangedSubview(labelNothing)
        
        //Product Title
        vStack.addArrangedSubview(labelTitle)
        vStack.addArrangedSubview(labelSubtitle)

        // FIXME: - Product Image
        productImage.contentMode = .scaleAspectFill
        productImage.clipsToBounds = true
        productImage.backgroundColor = K.Colors.superLightGray
        productImage.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(productImage)
        NSLayoutConstraint.activate([productImage.widthAnchor.constraint(equalTo: contentView.widthAnchor)]) //K.CollectionCell.width)])//K.CollectionCell.adjustedHeight(in: contentView))])
        productImage.addSubview(productImageNoImg)
        NSLayoutConstraint.activate([productImageNoImg.centerXAnchor.constraint(equalTo: productImage.centerXAnchor),
                                     productImageNoImg.centerYAnchor.constraint(equalTo: productImage.centerYAnchor)])

        //Rule Line
//        vStack.addArrangedSubview(ruleLine)
        
        // FIXME: - Sizes
//        vStack.addArrangedSubview(hStackBottom)
//        hStackBottom.addArrangedSubview(labelSizesLeft)
//        hStackBottom.alignment = .top
//        labelSizesRight.textAlignment = .right
//        hStackBottom.addArrangedSubview(labelSizesRight)
    }
    
    
//    private func layoutSizes() -> (left: String, right: String) {
//        var leftReturn = ""
//        var rightReturn = ""
//        var sizesCount = 0
//        var sizesCountHalved: Int {
//            Int(ceil(Double(sizesCount) / 2.0))
//        }
//        var maxSizesCountHalved: Int {
//            Int(ceil(Double(model.sizes.count) / 2.0))
//        }
//
//        //Get the number of viable sizes
//        for (i, size) in model.sizes.enumerated() {
//            if size.size == "" && size.colorwaySKU == "" {
//                sizesCount = i
//                break
//            }
//        }
//
//        //Populate left side
//        for i in 0..<sizesCountHalved {
//            leftReturn += "\(model.sizes[i])"
//            leftReturn += (i < sizesCountHalved - 1) ? "\n" : ""
//        }
//
//        //Populate right side
//        for i in sizesCountHalved..<sizesCount {
//            rightReturn += "\(model.sizes[i])"
//            rightReturn += (i < sizesCount - 1) ? "\n" : ""
//        }
//
//        //Add "padding"
//        for _ in sizesCountHalved..<maxSizesCountHalved {
//            leftReturn += "\n"
//        }
//
//        return (leftReturn, rightReturn)
//    }
    
}
