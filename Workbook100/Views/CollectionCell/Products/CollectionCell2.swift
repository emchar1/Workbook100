//
//  CollectionCell2.swift
//  Workbook100
//
//  Created by Eddie Char on 7/12/22.
//

import UIKit

class CollectionCell2: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var labelNew: CollectionCellLabelBubble!
    @IBOutlet weak var labelEssential: CollectionCellLabelBubble!
    @IBOutlet weak var labelBlank: CollectionCellLabelBubble!
    @IBOutlet weak var labelTitle: CollectionCellLabel!
    @IBOutlet weak var labelSubtitle: CollectionCellLabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productImageNoImg: UILabel!
    @IBOutlet weak var labelSize: CollectionCellLabel!
    @IBOutlet weak var labelQOH: CollectionCellLabel!
    @IBOutlet weak var labelStatus: CollectionCellLabel!
    @IBOutlet weak var labelROS: CollectionCellLabel!
    @IBOutlet weak var removeView: UIView!
    private var removeImage: UIImageView!

    class var reuseID: String { "CollectionCell2" }
    private var spinner = ActivitySpinner()
    var model: CollectionModel!
    
    //Dimensions
    static let collectionCellWidth: CGFloat = 180
    static var collectionCellHeight: CGFloat { collectionCellWidth * 4 / 2 }
    static var collectionCellPadding: CGFloat = 8
    static var itemsPerRow: CGFloat = (UIScreen.main.traitCollection.horizontalSizeClass == .compact) ? 4 : 6
    
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        model = CollectionModel.getBlankModel()

        setupViews()
    }
    
    private func setupViews() {
        labelNew.type = .new
        labelEssential.type = .essential
        labelBlank.type = .blank
        labelTitle.type = .title
        labelSubtitle.type = .subtitle
        labelSize.type = .productSize
        labelQOH.type = .productSize
        labelStatus.type = .productSize
        labelROS.type = .productSize

        removeImage = UIImageView(image: UIImage(systemName: "xmark"))
        removeImage.tintColor = .systemRed
        removeImage.isHidden = true
        removeImage.translatesAutoresizingMaskIntoConstraints = false
        
        removeView.backgroundColor = .white
        removeView.alpha = 0.5
        removeView.layer.borderWidth = 2
        removeView.layer.borderColor = UIColor.gray.cgColor
        removeView.layer.cornerRadius = 6
        removeView.clipsToBounds = true
        removeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didRemoveItem(_:))))
        removeView.addSubview(removeImage)
        
        NSLayoutConstraint.activate([
            removeImage.topAnchor.constraint(equalTo: removeView.topAnchor),
            removeImage.leadingAnchor.constraint(equalTo: removeView.leadingAnchor),
            removeView.trailingAnchor.constraint(equalTo: removeImage.trailingAnchor),
            removeView.bottomAnchor.constraint(equalTo: removeImage.bottomAnchor)
        ])
    }
    
    //THIS PREVENTS IMAGES FROM RECYCLE LOADING, WHICH LOOKS WEIRD!!
    override func prepareForReuse() {
        super.prepareForReuse()

        productImage.image = nil
        productImage.cancelImageLoad()
    }
    
    
    // MARK: - Helper Functions

    /**
     Sets the views. Call this usually from cellForRowAt in the View Controller
     */
    func setViews(with model: CollectionModel) {
        self.model = model
        
        labelNew.isHidden = model.carryOver
        labelEssential.isHidden = !model.essential
        labelBlank.isHidden = !(model.carryOver && !model.essential)
        
        labelTitle.text = model.productNameDescription
        labelSubtitle.text = model.productNameDescriptionSecondary
        
        //NEW WAY Product Image - Load images from Amplifi using ImageLoader Utility
        if let url = URL(string: model.thumbURL) {
            spinner.startSpinner(in: productImage)
            productImage.loadImage(at: url, completion: {
                self.spinner.stopSpinner()
            })
            
            productImageNoImg.isHidden = model.thumbURL != "#N/A" ? true : false
        }
        
        labelSize.text = layoutSizes().size
        labelQOH.text = layoutSizes().qoh
        labelStatus.text = layoutSizes().status
        labelROS.text = layoutSizes().ros
        removeImage.isHidden = model.isRemoved ? false : true
    }
    
    private func layoutSizes() -> (size: String, sku: String, qoh: String, status: String, ros: String) {
        let numberFormatter = NumberFormatter()
        var sizes = ""
        var skus = ""
        var qohs = ""
        var statuses = ""
        var roses = ""
        
        numberFormatter.numberStyle = .decimal
        
        for (i, size) in model.sizes.enumerated() {
            if i < model.sizes.count && size.size != "" {
                sizes += "\(size.size ?? "NA"): \n"
                skus += "\(size.colorwaySKU ?? "XXXXX-XXXXX")\n"
                qohs += "QOH: \(numberFormatter.string(from: NSNumber(value: size.qoh ?? -9999))!)\n"
                statuses += "Status: \(numberFormatter.string(from: NSNumber(value: size.status ?? -9999))!)\n"
                roses += "ROS: N/A\n"
            }
            else {
                sizes += "\n"
                skus += "\n"
                qohs += "\n"
                statuses += "\n"
                roses += "\n"
            }
            
//            sizes += "\(size.size ?? "NA"): " + ((i >= model.sizes.count) ? "" : "\n")
//            skus += "\(size.colorwaySKU ?? "XXXXX-XXXXX") " + ((i >= model.sizes.count) ? "" : "\n")
//            qohs += "QOH: \(size.qoh ?? -9999)" + ((i >= model.sizes.count) ? "" : "\n")
        }
        
        return (sizes, skus, qohs, statuses, roses)
    }

    @objc private func didRemoveItem(_ sender: UITapGestureRecognizer) {
        model.isRemoved.toggle()
        removeImage.isHidden = model.isRemoved ? false : true
    }
}
