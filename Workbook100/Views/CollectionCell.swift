//
//  CollectionCell.swift
//  Workbook100
//
//  Created by Eddie Char on 12/17/21.
//

import UIKit
import FirebaseStorageUI


// MARK: - Collection Cell Stack

class CollectionCellStack: UIStackView {
    init(frame: CGRect = .zero, backgroundColor: UIColor = .clear, spacing: CGFloat = 0, distribution: Distribution, alignment: Alignment, axis: NSLayoutConstraint.Axis) {
        super.init(frame: frame)

        //Convenient properties to initialize
        self.backgroundColor = backgroundColor
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = alignment
        self.axis = axis
        
        //Assumes user intends to use NSLayoutConstraints
        if frame == .zero {
            self.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Collection Cell Label Bubble

class CollectionCellLabelBubble: UILabel {
    enum LabelBubbvarype {
        case new, essential, nothing
    }
    
    init(frame: CGRect = .zero, type: LabelBubbvarype) {
        super.init(frame: frame)

        self.text = text
        self.textColor = .white
        self.textAlignment = .center
        self.font = K.Fonts.bubbleTitle
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
        
        if frame == .zero {
            self.translatesAutoresizingMaskIntoConstraints = false
        }
        
        customizeType(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeType(_ type: LabelBubbvarype) {
        switch type {
        case .new:
            self.backgroundColor = .red
            self.text = "New"
        case .essential:
            self.backgroundColor = .black
            self.text = "Essential"
        case .nothing:
            self.backgroundColor = .clear
            self.text = ""
        }
    }
    
    func setConstraints(to view: UIView, padding: CGFloat) {
        NSLayoutConstraint.activate([topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
                                     leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                                     view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: padding),
                                     view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: padding)])
    }
}


// MARK: - Collection Cell Label

class CollectionCellLabel: UILabel {
    enum LabelType {
        case title, subtitle, productSize
    }
    
    init(frame: CGRect = .zero, type: LabelType, text: String) {
        super.init(frame: frame)

        self.text = text
        self.textColor = .black
        self.numberOfLines = (type != .productSize) ? 1 : 0
        
        if frame == .zero {
            self.translatesAutoresizingMaskIntoConstraints = false
        }
        
        customizeType(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeType(_ type: LabelType) {
        switch type {
        case .title:
            self.font = K.Fonts.title
        case .subtitle:
            self.font = K.Fonts.subtitle
        case .productSize:
            self.font = K.Fonts.footerTitle
        }
    }
}


// MARK: - Rule Line

class RuleLine: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let ruleLine = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: frame.height / 2))
        linePath.addLine(to: CGPoint(x: frame.width, y: frame.height / 2))
        ruleLine.path = linePath.cgPath
        ruleLine.strokeColor = UIColor.black.cgColor
        ruleLine.lineWidth = 0.5
        layer.addSublayer(ruleLine)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Collection Cell

class CollectionCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    //are these needed???
//    static var identifier = "CVCell"
//    static var padding: CGFloat = 8.0
//    static var widthImageView: CGFloat = UIScreen.main.bounds.width / 3 - padding * 1.5
//    static var heightImageView: CGFloat = widthImageView
//    static var heightDescriptionLabel: CGFloat = 60
//    static var heightStack: CGFloat = heightImageView * heightDescriptionLabel
//    var imageView: UIImageView = {
//        var imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.backgroundColor = .cyan
//        return imageView
//    }()
    
    
    //new properties
    var vStack: CollectionCellStack!
    var hStackTop: CollectionCellStack!
    var labelNew: CollectionCellLabelBubble!
    var labelEssential: CollectionCellLabelBubble!
    var labelNothing: CollectionCellLabelBubble!
    var labelTitle: CollectionCellLabel!
    var labelSubtitle: CollectionCellLabel!
    var productImage: UIImageView!
    var ruleLine: RuleLine!
    var hStackBottom: CollectionCellStack!
    var labelSizesLeft: CollectionCellLabel!
    var labelSizesRight: CollectionCellLabel!
    var model: CollectionModel!

    
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
        
//        productImage.image = nil
//        productImage.cancelImageLoad()
    }
    
    
    // MARK: - Helper Functions
    
    func setViews() {
        labelTitle.text = model.productNameDescription
        labelSubtitle.text = model.colorway
        
        labelSizesLeft.text = layoutSizes().left
        labelSizesRight.text = layoutSizes().right
        
        if let image = model.image {
            productImage.sd_setImage(with: image)
        }

        // FIXME: - This is sooo clunky - hStackTop
        hStackTop.subviews[0].isHidden = model.carryOver
        hStackTop.subviews[1].isHidden = !model.essential
        hStackTop.subviews[2].isHidden = !(model.carryOver && !model.essential)
    }
    
    
    private func setupViews() {
        /*
        self.model = CollectionModel(showNew: true,
                                     showEssential: true,
                                     labelTitle: "Product Title",
                                     labelSubtitle: "Product Subtitle",
                                     imageName: "20026-20",
                                     sizes: [
                                        CollectionModel.Size.init(size: "SM", sku: "00000-00001"),
                                        CollectionModel.Size.init(size: "MD", sku: "00000-00002"),
                                        CollectionModel.Size.init(size: "LG", sku: "00000-00003"),
                                        CollectionModel.Size.init(size: "XL", sku: "00000-00004"),
                                        CollectionModel.Size.init(size: nil, sku: "00000-00005")
                                     ],
                                     image: nil)
         */
        
        self.model = CollectionModel(division: "Division",
                                     collection: "SP23",
                                     productNameDescription: "Product Name Description",
                                     productCategory: "Product Category",
                                     colorway: "Color",
                                     carryOver: false,
                                     essential: true,
                                     skuCode: "00000-00000",
                                     sizes: [
                                        CollectionModel.Size(size: "Size 0", colorwaySKU: "00000-00000"),
                                        CollectionModel.Size(size: "Size 1", colorwaySKU: "00000-00001"),
                                        CollectionModel.Size(size: "Size 2", colorwaySKU: "00000-00002"),
                                        CollectionModel.Size(size: "Size 3", colorwaySKU: "00000-00003"),
                                        CollectionModel.Size(size: "Size 4", colorwaySKU: "00000-00004"),
                                        CollectionModel.Size(size: "Size 5", colorwaySKU: "00000-00005"),
                                        CollectionModel.Size(size: "Size 6", colorwaySKU: "00000-00006")
                                     ],
                                     usMSRP: 9.99,
                                     euMSRP: 10.01,
                                     countryCode: "US",
                                     composition: "Composition",
                                     productDescription: "Product Description",
                                     productFeatures: "Product Features",
                                     image: nil)
        
        vStack = CollectionCellStack(distribution: .fill, alignment: .fill, axis: .vertical)
        hStackTop = CollectionCellStack(spacing: 2, distribution: .fillEqually, alignment: .fill, axis: .horizontal)
        labelNew = CollectionCellLabelBubble(type: .new)
        labelEssential = CollectionCellLabelBubble(type: .essential)
        labelNothing = CollectionCellLabelBubble(type: .nothing)
        labelTitle = CollectionCellLabel(type: .title, text: model.productNameDescription)
        labelSubtitle = CollectionCellLabel(type: .subtitle, text: model.colorway)
        productImage = UIImageView()
        ruleLine = RuleLine(frame: CGRect(x: 0, y: 0, width: K.CollectionCell.width, height: 20))
        hStackBottom = CollectionCellStack(distribution: .fillEqually, alignment: .fill, axis: .horizontal)
        labelSizesLeft =  CollectionCellLabel(type: .productSize, text: layoutSizes().left)
        labelSizesRight =  CollectionCellLabel(type: .productSize, text: layoutSizes().right)
        
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
        productImage.contentMode = .scaleAspectFit
        productImage.backgroundColor = K.Colors.superLightGray
        productImage.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(productImage)
        NSLayoutConstraint.activate([productImage.heightAnchor.constraint(equalToConstant: K.CollectionCell.width)])
        
        //Rule Line
        vStack.addArrangedSubview(ruleLine)
        
        // FIXME: - Sizes
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


/*
// MARK: - TEST!!!

class CollectionCell2: UICollectionViewCell {
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        label.text = "Test"
        label.textColor = .black
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("DOH!")
    }
}
*/
