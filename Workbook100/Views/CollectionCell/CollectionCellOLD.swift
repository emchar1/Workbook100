//
//  CollectionCellOLD.swift
//  Workbook100
//
//  Created by Eddie Char on 12/17/21.
//

import UIKit

//Need this Obj-C wrapper to supress an error when compiling for non-Mac Catalyst simulator. But need AppKit for Mac Catalyst
#if targetEnvironment(macCatalyst)
import AppKit
#endif

class CollectionCellOLD: UICollectionViewCell {
    
    // MARK: - Properties
    class var reuseID: String { "CollectionCellOLD" }
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
        noimg.textColor = .red
        noimg.translatesAutoresizingMaskIntoConstraints = false
        return noimg
    }()
    
    var ruleLine: RuleLine!
    var hStackBottom: CollectionCellStack!
    var labelSizesLeft: CollectionCellLabel!
    var labelSizesRight: CollectionCellLabel!
    
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
    
    //THIS PREVENTS IMAGES FROM RECYCLE LOADING, WHICH LOOKS WEIRD!!
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
        
        switch model.productCategory {
        case "Accessories":
            labelSubtitle.text = model.colorway + "\n"
        case "Apparel":
            if model.productType == "Cap" {
                labelSubtitle.text = model.colorway + "/" + model.productSubtype + "\n" + model.productDetails
            }
            else {
                labelSubtitle.text = model.colorway + "\n" + model.productNameDescriptionSecondary
            }
        case "Goggles":
            labelSubtitle.text = model.colorway + "\n" + model.productNameDescriptionSecondary
        case "Gear", "Gloves", "Helmets", "Protection":
            labelSubtitle.text = model.productNameDescriptionSecondary + "\n" + model.colorway
        default:
            labelSubtitle.text = model.productNameDescriptionSecondary + "\n" + model.colorway
        }
        
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
        
        labelSizesLeft.text = layoutSizes().left
        labelSizesRight.text = layoutSizes().right
    }
    
    
    // MARK: - Helper Functions
    
    func setupViews() {
        self.model = CollectionModel.getBlankModel()
        
        //==SETUP==//
        //Content View
        contentView.backgroundColor = .blue
//        contentView.layer.cornerRadius = K.CollectionCell.cornerRadius
        contentView.clipsToBounds = true

        //VStack
        vStack = CollectionCellStack(distribution: .fill, alignment: .fill, axis: .vertical)
        
        //New & Essential Stack
        hStackTop = CollectionCellStack(spacing: 2, distribution: .fillEqually, alignment: .fill, axis: .horizontal)
        labelNew = CollectionCellLabelBubble(type: .new)
        labelEssential = CollectionCellLabelBubble(type: .essential)
        labelNothing = CollectionCellLabelBubble(type: .blank)
        
        //Product Title
        labelTitle = CollectionCellLabel(type: .title, text: model.productNameDescription)
        labelSubtitle = CollectionCellLabel(type: .subtitle, text: model.productNameDescriptionSecondary)
        
        //Product Image
        productImage = UIImageView()
        
        //hStackBottom
        ruleLine = RuleLine(frame: CGRect(x: 0, y: 0, width: K.CollectionCell.width, height: 20),
                            from: CGPoint(x: 0, y: K.CollectionCell.height / 2),
                            to: CGPoint(x: frame.width, y: K.CollectionCell.height / 2))
        hStackBottom = CollectionCellStack(distribution: .fillEqually, alignment: .fill, axis: .horizontal)
        labelSizesLeft = CollectionCellLabel(type: .productSize, text: layoutSizes().left)
        labelSizesRight = CollectionCellLabel(type: .productSize, text: layoutSizes().right)
        

        
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
        
        //hStackBottom
        vStack.addArrangedSubview(ruleLine)
        vStack.addArrangedSubview(hStackBottom)
        hStackBottom.addArrangedSubview(labelSizesLeft)
        hStackBottom.alignment = .top
        labelSizesRight.textAlignment = .right
        hStackBottom.addArrangedSubview(labelSizesRight)
    }
    
    private func layoutSizes() -> (left: String, right: String) {
        var leftReturn = ""
        var rightReturn = ""
        var sizesCount = 0
        var sizesCountHalved: Int {
            Int(ceil(Double(sizesCount) / 2.0))
        }
        var maxSizesCountHalved: Int {
            Int(ceil(Double(model.sizes.count) / 2.0))
        }
        
        //Get the number of viable sizes
        for (i, size) in model.sizes.enumerated() {
            if size.size == "" && size.colorwaySKU == "" {
                sizesCount = i
                break
            }
        }
        
        //Populate left side
        for i in 0..<sizesCountHalved {
            leftReturn += "\(model.sizes[i])"
            leftReturn += (i < sizesCountHalved - 1) ? "\n" : ""
        }
        
        //Populate right side
        for i in sizesCountHalved..<sizesCount {
            rightReturn += "\(model.sizes[i])"
            rightReturn += (i < sizesCount - 1) ? "\n" : ""
        }
        
        //Add "padding"
        for _ in sizesCountHalved..<maxSizesCountHalved {
            leftReturn += "\n"
        }
        
        return (leftReturn, rightReturn)
    }
}
