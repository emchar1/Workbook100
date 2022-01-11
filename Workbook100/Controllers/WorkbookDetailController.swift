//
//  WorkbookDetailController.swift
//  Workbook100
//
//  Created by Eddie Char on 12/27/21.
//

import UIKit

class WorkbookDetailController: UIViewController {
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
    var labelSizes: CollectionCellLabel!
    var labelSizes2: CollectionCellLabel!
    var model: CollectionModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        if model == nil {
            self.model = CollectionModel(showNew: true,
                                         showEssential: true,
                                         labelTitle: "Product Title",
                                         labelSubtitle: "Product Subtitle",
                                         imageName: "20026-20",
                                         sizes: [
                                            CollectionModel.Size(size: "SM", sku: "00000-00001"),
                                            CollectionModel.Size(size: "MD", sku: "00000-00002"),
                                            CollectionModel.Size(size: "LG", sku: "00000-00003"),
                                            CollectionModel.Size(size: "XL", sku: "00000-00004"),
                                            CollectionModel.Size(size: nil, sku: "00000-00005")
                                         ],
                                         image: nil)
        }
        
        vStack = CollectionCellStack(distribution: .fill, alignment: .fill, axis: .vertical)
        hStackTop = CollectionCellStack(spacing: 2, distribution: .fillEqually, alignment: .fill, axis: .horizontal)
        labelNew = CollectionCellLabelBubble(type: .new)
        labelEssential = CollectionCellLabelBubble(type: .essential)
        labelNothing = CollectionCellLabelBubble(type: .nothing)
        labelTitle = CollectionCellLabel(type: .title, text: model.labelTitle)
        labelSubtitle = CollectionCellLabel(type: .subtitle, text: model.labelSubtitle)
        productImage = UIImageView()
        ruleLine = RuleLine(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 20))
        hStackBottom = CollectionCellStack(distribution: .fillEqually, alignment: .fill, axis: .horizontal)
        labelSizes =  CollectionCellLabel(type: .productSize,
                                          text: "\(model.sizes[0])\n\(model.sizes[1])")
        labelSizes2 =  CollectionCellLabel(type: .productSize,
                                           text: "\(model.sizes[2])\n\(model.sizes[3])\n\(model.sizes[4])")
        
        
        let padding: CGFloat = 0//K.CollectionCell.padding

        view.addSubview(vStack)
        NSLayoutConstraint.activate([vStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
                                     vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                                     view.trailingAnchor.constraint(equalTo: vStack.trailingAnchor, constant: padding),
                                     view.bottomAnchor.constraint(equalTo: vStack.bottomAnchor, constant: padding)])
        
        //New and Essential
        vStack.addArrangedSubview(hStackTop)
        hStackTop.addArrangedSubview(labelNew)
        hStackTop.addArrangedSubview(labelEssential)
        hStackTop.addArrangedSubview(labelNothing)
        
        // FIXME: - This is sooo clunky - hStackTop
        hStackTop.subviews[0].isHidden = !model.showNew
        hStackTop.subviews[1].isHidden = !model.showEssential
        hStackTop.subviews[2].isHidden = !(!model.showNew && !model.showEssential)

        
        //Product Title
        vStack.addArrangedSubview(labelTitle)
        vStack.addArrangedSubview(labelSubtitle)

        // FIXME: - Product Image
        productImage.contentMode = .scaleAspectFit
        productImage.backgroundColor = .gray
        productImage.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(productImage)
        NSLayoutConstraint.activate([productImage.heightAnchor.constraint(equalToConstant: view.frame.width / 2)])
        
        if let image = model.image {
            productImage.sd_setImage(with: image)
        }

        
        //Rule Line
        vStack.addArrangedSubview(ruleLine)
        
        // FIXME: - Sizes
        vStack.addArrangedSubview(hStackBottom)
        hStackBottom.addArrangedSubview(labelSizes)
        hStackBottom.alignment = .top
        labelSizes2.textAlignment = .right
        hStackBottom.addArrangedSubview(labelSizes2)
    }
}
