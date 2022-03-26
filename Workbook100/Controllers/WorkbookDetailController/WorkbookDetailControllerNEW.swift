//
//  WorkbookDetailControllerNEW.swift
//  Workbook100
//
//  Created by Eddie Char on 1/5/22.
//

import UIKit
import Firebase

class WorkbookDetailControllerNEW: UITableViewController {
    @IBOutlet weak var switchNew: UISwitch!
    @IBOutlet weak var switchEssential: UISwitch!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfSubtitle: UITextField!
    @IBOutlet weak var tfSize0: UITextField!
    @IBOutlet weak var tfSize1: UITextField!
    @IBOutlet weak var tfSize2: UITextField!
    @IBOutlet weak var tfSize3: UITextField!
    @IBOutlet weak var tfSize4: UITextField!
    @IBOutlet weak var tfSize5: UITextField!
    @IBOutlet weak var tfSize6: UITextField!
    @IBOutlet weak var tfSKU0: UITextField!
    @IBOutlet weak var tfSKU1: UITextField!
    @IBOutlet weak var tfSKU2: UITextField!
    @IBOutlet weak var tfSKU3: UITextField!
    @IBOutlet weak var tfSKU4: UITextField!
    @IBOutlet weak var tfSKU5: UITextField!
    @IBOutlet weak var tfSKU6: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    var model: CollectionModel!
    
    override func viewDidLoad() {
        if model == nil {
            self.model = CollectionModel.getBlankModel()
        }
        
        title = model.productNameDescription
        
        switchNew.isOn = !model.carryOver
        switchEssential.isOn = model.essential
        tfTitle.text = model.productNameDescription
        tfSubtitle.text = model.colorway
        
        tfSize0.text = model.sizes[0].size
        tfSize1.text = model.sizes[1].size
        tfSize2.text = model.sizes[2].size
        tfSize3.text = model.sizes[3].size
        tfSize4.text = model.sizes[4].size
        tfSize5.text = model.sizes[5].size
        tfSize6.text = model.sizes[6].size

        tfSKU0.text = model.sizes[0].colorwaySKU
        tfSKU1.text = model.sizes[1].colorwaySKU
        tfSKU2.text = model.sizes[2].colorwaySKU
        tfSKU3.text = model.sizes[3].colorwaySKU
        tfSKU4.text = model.sizes[4].colorwaySKU
        tfSKU5.text = model.sizes[5].colorwaySKU
        tfSKU6.text = model.sizes[6].colorwaySKU

//        if let image = model.image {
//            imageView.sd_setImage(with: image)
//        }
        
        if let url = URL(string: model.imageURLs[0]) {
            print("Success loading image: \(url)")
            imageView.loadImage(at: url, completion: { print("Image loaded on thread: \(Thread.current)")})
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // FIXME: didSelectRow switch cases - not sure I like this???
        switch (indexPath.section, indexPath.row) {
        case (1, 0): tfTitle.becomeFirstResponder()
        case (1, 1): tfSubtitle.becomeFirstResponder()
        case (2, 0): tfSize0.becomeFirstResponder()
        case (2, 1): tfSize1.becomeFirstResponder()
        case (2, 2): tfSize2.becomeFirstResponder()
        case (2, 3): tfSize3.becomeFirstResponder()
        case (2, 4): tfSize4.becomeFirstResponder()
        case (2, 5): tfSize5.becomeFirstResponder()
        case (2, 6): tfSize6.becomeFirstResponder()
        default: break
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pdfPressed(_ sender: UIBarButtonItem) {
        let pdfFilePath = self.view.exportAsPDFFromView()
        print("PDF saved to: \(pdfFilePath)")
        
        if let pdfData = pdfFilePath.pdfData {
            self.present(UIActivityViewController(activityItems: [pdfData], applicationActivities: []), animated: true, completion: nil)
        }

    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        let items = K.ProductFilter.isFiltered ? K.filteredItems : K.items
        
        if let row = items.firstIndex(where: { $0.id == model.id }) {

            //Update Model
            let newModel = CollectionModel(hashNeedThis: items[row].hashNeedThis,
                                           division: items[row].division,
                                           collection: items[row].collection,
                                           productNameDescription: tfTitle.text!,
                                           productNameDescriptionSecondary: items[row].productNameDescriptionSecondary,
                                           productCategory: items[row].productCategory,
                                           productDepartment: items[row].productDepartment,
                                           launchSeason: items[row].launchSeason,
                                           seasonsCarried: items[row].seasonsCarried,
                                           productType: items[row].productType,
                                           productSubtype: items[row].productSubtype,
                                           productDetails: items[row].productDetails,
                                           youthWomen: items[row].youthWomen,
                                           colorway: tfSubtitle.text!,
                                           carryOver: !switchNew.isOn,
                                           essential: switchEssential.isOn,
                                           skuCode: items[row].skuCode,
                                           sizes: [
                                            CollectionModel.Size(size: tfSize0.text!, colorwaySKU: tfSKU0.text!),
                                            CollectionModel.Size(size: tfSize1.text!, colorwaySKU: tfSKU1.text!),
                                            CollectionModel.Size(size: tfSize2.text!, colorwaySKU: tfSKU2.text!),
                                            CollectionModel.Size(size: tfSize3.text!, colorwaySKU: tfSKU3.text!),
                                            CollectionModel.Size(size: tfSize4.text!, colorwaySKU: tfSKU4.text!),
                                            CollectionModel.Size(size: tfSize5.text!, colorwaySKU: tfSKU5.text!),
                                            CollectionModel.Size(size: tfSize6.text!, colorwaySKU: tfSKU6.text!)
                                           ],
                                           usMSRP: items[row].usMSRP,
                                           euMSRP: items[row].euMSRP,
                                           countryCode: items[row].countryCode,
                                           composition: items[row].composition,
                                           productDescription: items[row].productNameDescription,
                                           productFeatures: items[row].productFeatures,
                                           primaryImageURL: items[row].primaryImageURL,
                                           thumbURL: items[row].thumbURL,
                                           imageURLs: items[row].imageURLs,
                                           //This needs to be Storage.storage().reference.child(K.items[row].productCategory + ".png"))
                                           image: nil,
                                           savedLists: nil)
            
            if K.ProductFilter.isFiltered {
                K.filteredItems[row] = newModel
            }
            else {
                K.items[row] = newModel
            }
            
            //Update Firebase
            let itemRef: [String: Any] = [K.FIR.division: newModel.division,
                                          K.FIR.collection: newModel.collection,
                                          K.FIR.productNameDescription: tfTitle.text!,
                                          K.FIR.productNameDescriptionSecondary: model.productNameDescriptionSecondary,
                                          K.FIR.productCategory: model.productCategory,
                                          K.FIR.productDepartment: model.productDepartment,
                                          K.FIR.launchSeason: model.launchSeason,
                                          K.FIR.productType: model.productType,
                                          K.FIR.productSubtype: model.productSubtype,
                                          K.FIR.productDetails: model.productDetails,
                                          K.FIR.youthWomen: model.youthWomen,
                                          K.FIR.colorway: tfSubtitle.text!,
                                          K.FIR.carryOver: String(!switchNew.isOn).uppercased(),
                                          K.FIR.essential: String(switchEssential.isOn).uppercased(),
                                          K.FIR.skuCode: model.skuCode,
                                          K.FIR.colorwaySKU0: tfSKU0.text!,
                                          K.FIR.colorwaySKU1: tfSKU1.text!,
                                          K.FIR.colorwaySKU2: tfSKU2.text!,
                                          K.FIR.colorwaySKU3: tfSKU3.text!,
                                          K.FIR.colorwaySKU4: tfSKU4.text!,
                                          K.FIR.colorwaySKU5: tfSKU5.text!,
                                          K.FIR.colorwaySKU6: tfSKU6.text!,
                                          K.FIR.size0: tfSize0.text!,
                                          K.FIR.size1: tfSize1.text!,
                                          K.FIR.size2: tfSize2.text!,
                                          K.FIR.size3: tfSize3.text!,
                                          K.FIR.size4: tfSize4.text!,
                                          K.FIR.size5: tfSize5.text!,
                                          K.FIR.size6: tfSize6.text!,
                                          K.FIR.usRetailMSRP: model.usMSRP,
                                          K.FIR.euRetailMSRP: model.euMSRP,
                                          K.FIR.countryCode: model.countryCode,
                                          K.FIR.composition: model.composition,
                                          K.FIR.productDescription: model.productDescription,
                                          K.FIR.productFeatures: model.productFeatures,
                                          K.FIR.primaryImageURL: model.primaryImageURL,
                                          K.FIR.thumbURL: model.thumbURL,
                                          K.FIR.imageURL0: model.imageURLs[0],
                                          K.FIR.imageURL1: model.imageURLs[1],
                                          K.FIR.imageURL2: model.imageURLs[2],
                                          K.FIR.imageURL3: model.imageURLs[3],
                                          K.FIR.imageURL4: model.imageURLs[4],
                                          K.FIR.imageURL5: model.imageURLs[5],
                                          K.FIR.imageURL6: model.imageURLs[6],
                                          K.FIR.imageURL7: model.imageURLs[7],
                                          K.FIR.imageURL8: model.imageURLs[8],
                                          K.FIR.imageURL9: model.imageURLs[9],
                                          K.FIR.imageURL10: model.imageURLs[10],
            ]
            let ref = Database.database().reference().child(K.ProductFilter.isFiltered ? K.filteredItems[row].hashNeedThis : K.items[row].hashNeedThis)
            ref.setValue(itemRef)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
