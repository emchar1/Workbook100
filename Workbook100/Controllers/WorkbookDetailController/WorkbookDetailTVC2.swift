//
//  WorkbookDetailTVC2.swift
//  Workbook100
//
//  Created by Eddie Char on 3/21/22.
//

import UIKit

class WorkbookDetailTVC2: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Properties
    
    @IBOutlet weak var newLabel: UILabel!
    @IBOutlet weak var essentialLabel: UILabel!
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productNameSecondaryLabel: UILabel!
    @IBOutlet weak var colorwayLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var productCategoryLabel: UILabel!
    @IBOutlet weak var productDeptLabel: UILabel!
    @IBOutlet weak var productTypeLabel: UILabel!
    @IBOutlet weak var productSubtypeLabel: UILabel!
    @IBOutlet weak var productDetailsLabel: UILabel!
    @IBOutlet weak var size0Label: UILabel!
    @IBOutlet weak var size1Label: UILabel!
    @IBOutlet weak var size2Label: UILabel!
    @IBOutlet weak var size3Label: UILabel!
    @IBOutlet weak var size4Label: UILabel!
    @IBOutlet weak var size5Label: UILabel!
    @IBOutlet weak var size6Label: UILabel!
    @IBOutlet weak var sku0Label: UILabel!
    @IBOutlet weak var sku1Label: UILabel!
    @IBOutlet weak var sku2Label: UILabel!
    @IBOutlet weak var sku3Label: UILabel!
    @IBOutlet weak var sku4Label: UILabel!
    @IBOutlet weak var sku5Label: UILabel!
    @IBOutlet weak var sku6Label: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var savedListsLabel: UILabel!

    let imageSize: CGFloat = 200
    var model: CollectionModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Ensures model is never nil.
        if model == nil {
            self.model = CollectionModel.getBlankModel()
        }
        
        title = model.productNameDescription
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: K.CollectionCell.padding,
                                           left: K.CollectionCell.padding,
                                           bottom: K.CollectionCell.padding,
                                           right: K.CollectionCell.padding)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout

        loadModel()
    }
    
    private func loadModel() {
        newLabel.isHidden = model.carryOver ? true : false
        essentialLabel.isHidden = model.essential ? false : true
        collectionLabel.text = model.collection
        productNameLabel.text = model.productNameDescription
        productNameSecondaryLabel.text = model.productNameDescriptionSecondary
        colorwayLabel.text = model.colorway
        classLabel.text = model.youthWomen
        productCategoryLabel.text = model.productCategory
        productDeptLabel.text = model.productDepartment
        productTypeLabel.text = model.productType
        productSubtypeLabel.text = model.productSubtype
        productDetailsLabel.text = model.productDetails
        size0Label.text = model.sizes[0].size
        size1Label.text = model.sizes[1].size
        size2Label.text = model.sizes[2].size
        size3Label.text = model.sizes[3].size
        size4Label.text = model.sizes[4].size
        size5Label.text = model.sizes[5].size
        size6Label.text = model.sizes[6].size
        sku0Label.text = model.sizes[0].colorwaySKU
        sku1Label.text = model.sizes[1].colorwaySKU
        sku2Label.text = model.sizes[2].colorwaySKU
        sku3Label.text = model.sizes[3].colorwaySKU
        sku4Label.text = model.sizes[4].colorwaySKU
        sku5Label.text = model.sizes[5].colorwaySKU
        sku6Label.text = model.sizes[6].colorwaySKU
        savedListsLabel.text = model.savedLists?.joined(separator: K.ProductFilter.multiSeparator)
    }
    
    
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageSegue" {            
            if let indexPaths = collectionView.indexPathsForSelectedItems,
               let indexPath = indexPaths.first,
               let url = URL(string: model.imageURLs[indexPath.row]) {
                
                let nc = segue.destination as! UINavigationController
                let controller = nc.topViewController as! WorkbookImageViewController
                
                controller.title = model.productNameDescription
                controller.spinner.startSpinner(in: controller.view)
                controller.imageView.loadImage(at: url, completion: { controller.spinner.stopSpinner() })
            }
        }
    }
    
}


// MARK: - TableView Delegate

extension WorkbookDetailTVC2 {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultHeight: CGFloat = 44
        
        switch indexPath.section {
        case 3:
            guard model.sizes[indexPath.row].colorwaySKU!.count > 0 || model.sizes[indexPath.row].size!.count > 0 else {
                return 0
            }
            
            return defaultHeight
        case 4:
            return imageSize
        default:
            return defaultHeight
        }
    }
}


// MARK: - Collection View Delegate, Data Source, Flow Layout

extension WorkbookDetailTVC2 {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productImageCell", for: indexPath) as! ImageViewCollectionCell
        
        if let url = URL(string: model.imageURLs[indexPath.row]) {
            cell.spinner.startSpinner(in: cell.contentView)
            cell.imageView.loadImage(at: url, completion: { cell.spinner.stopSpinner() })
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0

        for imageURL in model.imageURLs {
            guard imageURL.count > 0 else { break }
            
            count += 1
        }

        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "imageSegue", sender: nil)
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imageSize, height: imageSize)
    }
}
