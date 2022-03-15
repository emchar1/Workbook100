//
//  WorkbookDetailController.swift
//  Workbook100
//
//  Created by Eddie Char on 12/27/21.
//

import UIKit

class WorkbookDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView()
    var model: CollectionModel!
    var modelArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)

        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: view.topAnchor),
                                     tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
                                     view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)])
        
        
        if model == nil {
            model = CollectionModel.getBlankModel()
        }
        
        modelArray.append("Division: \(model.division)")
        modelArray.append("Collection: \(model.collection)")
        modelArray.append("Product Name Description: \(model.productNameDescription)")
        modelArray.append("Product Name Description Secondary: \(model.productNameDescriptionSecondary)")
        modelArray.append("Product Category: \(model.productCategory)")
        modelArray.append("Product Department: \(model.productDepartment)")
        modelArray.append("Launch Season: \(model.launchSeason)")
        modelArray.append("Seasons Carried: \(model.seasonsCarried)")
        modelArray.append("Product Type: \(model.productType)")
        modelArray.append("Product Subtype: \(model.productSubtype)")
        modelArray.append("Youth/Women: \(model.youthWomen)")
        modelArray.append("Colorway: \(model.colorway)")
        modelArray.append("New: \(!model.carryOver)")
        modelArray.append("Essential: \(model.essential)")
        modelArray.append("SKU Code: \(model.skuCode)")
        for (index, size) in model.sizes.enumerated() {
            modelArray.append("#\(index) SKU: \(size.colorwaySKU ?? "N/A"), Size: \(size.size ?? "N/A")")
        }
        modelArray.append("US MSRP: \(model.usMSRP)")
        modelArray.append("EU MSRP: \(model.euMSRP)")
        modelArray.append("Country Code: \(model.countryCode)")
        modelArray.append("Composition: \(model.composition)")
        modelArray.append("Product Description: \(model.productDescription)")
        modelArray.append("Product Features: \(model.productFeatures)")

    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = "\(modelArray[indexPath.row])"
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    
    
    
    
    /*
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
            self.model = CollectionModel.getBlankModel()
        }
        
        vStack = CollectionCellStack(distribution: .fill, alignment: .fill, axis: .vertical)
        hStackTop = CollectionCellStack(spacing: 2, distribution: .fillEqually, alignment: .fill, axis: .horizontal)
        labelNew = CollectionCellLabelBubble(type: .new)
        labelEssential = CollectionCellLabelBubble(type: .essential)
        labelNothing = CollectionCellLabelBubble(type: .nothing)
        labelTitle = CollectionCellLabel(type: .title, text: model.productNameDescription)
        labelSubtitle = CollectionCellLabel(type: .subtitle, text: model.productNameDescriptionSecondary + " - " + model.colorway)
        productImage = UIImageView()
//        ruleLine = RuleLine(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 20))
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
        hStackTop.subviews[0].isHidden = model.carryOver
        hStackTop.subviews[1].isHidden = !model.essential
        hStackTop.subviews[2].isHidden = !(model.carryOver && !model.essential)

        
        //Product Title
        vStack.addArrangedSubview(labelTitle)
        vStack.addArrangedSubview(labelSubtitle)

        // FIXME: - Product Image
        productImage.contentMode = .scaleAspectFit
        productImage.backgroundColor = .gray
        productImage.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(productImage)
        NSLayoutConstraint.activate([productImage.heightAnchor.constraint(equalToConstant: view.frame.width / 2)])
        
//        if let image = model.image {
//            productImage.sd_setImage(with: image)
//        }

        if let url = URL(string: model.imageURL) {
            print("Success loading image: \(url)")
            productImage.loadImage(at: url, completion: { print("Image loaded on thread: \(Thread.current)")})
        }
        
        //Rule Line
//        vStack.addArrangedSubview(ruleLine)
        
        // FIXME: - Sizes
        vStack.addArrangedSubview(hStackBottom)
        hStackBottom.addArrangedSubview(labelSizes)
        hStackBottom.alignment = .top
        labelSizes2.textAlignment = .right
        hStackBottom.addArrangedSubview(labelSizes2)
    }
     */
}

