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
    @IBOutlet weak var labelSKU: CollectionCellLabel!
    @IBOutlet weak var labelQOH: CollectionCellLabel!

    class var reuseID: String { "CollectionCell2" }
    private var spinner = ActivitySpinner()
    private var model: CollectionModel!
    
    //Dimensions
    static let collectionCellWidth: CGFloat = 180
    static var collectionCellHeight: CGFloat { collectionCellWidth * 4 / 2 }
    static var collectionCellPadding: CGFloat = 8
    static var itemsPerRow: CGFloat = (UIScreen.main.traitCollection.horizontalSizeClass == .compact) ? 3 : 6
    
    
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
        labelSKU.type = .productSize
        labelQOH.type = .productSize
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
        labelSKU.text = layoutSizes().sku
        labelQOH.text = layoutSizes().qoh
    }
    
    private func layoutSizes() -> (size: String, sku: String, qoh: String) {
        let numberFormatter = NumberFormatter()
        var sizes = ""
        var skus = ""
        var qohs = ""
        
        numberFormatter.numberStyle = .decimal
        
        for (i, size) in model.sizes.enumerated() {
            if i < model.sizes.count && size.size != "" {
                sizes += "\(size.size ?? "NA"): \n"
                skus += "\(size.colorwaySKU ?? "XXXXX-XXXXX")\n"
                qohs += "QOH: \(numberFormatter.string(from: NSNumber(value: size.qoh ?? -9999))!)\n"
            }
            else {
                sizes += "\n"
                skus += "\n"
                qohs += "\n"
            }
            
//            sizes += "\(size.size ?? "NA"): " + ((i >= model.sizes.count) ? "" : "\n")
//            skus += "\(size.colorwaySKU ?? "XXXXX-XXXXX") " + ((i >= model.sizes.count) ? "" : "\n")
//            qohs += "QOH: \(size.qoh ?? -9999)" + ((i >= model.sizes.count) ? "" : "\n")
        }
        
        return (sizes, skus, qohs)
    }
}
