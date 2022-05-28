//
//  CollectionCell.swift
//  Workbook100
//
//  Created by Eddie Char on 5/27/22.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var labelNew: CollectionCellLabelBubble!
    @IBOutlet weak var labelEssential: CollectionCellLabelBubble!
    @IBOutlet weak var labelBlank: CollectionCellLabelBubble!
    @IBOutlet weak var labelTitle: CollectionCellLabel!
    @IBOutlet weak var labelSubtitle: CollectionCellLabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productImageNoImg: UILabel!
    @IBOutlet weak var labelSKULeft: CollectionCellLabel!
    @IBOutlet weak var labelSKURight: CollectionCellLabel!
    
    class var reuseID: String { "CollectionCell" }
    private var spinner = ActivitySpinner()
    private var model: CollectionModel!
    
    
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
        labelSKULeft.type = .productSize
        labelSKURight.type = .productSize
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
        
        let sizes = layoutSizes()
        labelSKULeft.text = sizes.left
        labelSKURight.text = sizes.right
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
        
        return (leftReturn, rightReturn)
    }
}
