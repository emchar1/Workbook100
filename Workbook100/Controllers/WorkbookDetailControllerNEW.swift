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
        
        if let url = URL(string: model.imageURL) {
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
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        if let row = K.items.firstIndex(where: { $0.id == model.id }) {

            //Update Model
            let newModel = CollectionModel(division: K.items[row].division,
                                           collection: K.items[row].collection,
                                           productNameDescription: tfTitle.text!,
                                           productNameDescriptionSecondary: K.items[row].productNameDescriptionSecondary,
                                           productCategory: K.items[row].productCategory,
                                           colorway: tfSubtitle.text!,
                                           carryOver: !switchNew.isOn,
                                           essential: switchEssential.isOn,
                                           skuCode: K.items[row].skuCode,
                                           sizes: [
                                            CollectionModel.Size(size: tfSize0.text!, colorwaySKU: tfSKU0.text!),
                                            CollectionModel.Size(size: tfSize1.text!, colorwaySKU: tfSKU1.text!),
                                            CollectionModel.Size(size: tfSize2.text!, colorwaySKU: tfSKU2.text!),
                                            CollectionModel.Size(size: tfSize3.text!, colorwaySKU: tfSKU3.text!),
                                            CollectionModel.Size(size: tfSize4.text!, colorwaySKU: tfSKU4.text!),
                                            CollectionModel.Size(size: tfSize5.text!, colorwaySKU: tfSKU5.text!),
                                            CollectionModel.Size(size: tfSize6.text!, colorwaySKU: tfSKU6.text!)
                                           ],
                                           usMSRP: K.items[row].usMSRP,
                                           euMSRP: K.items[row].euMSRP,
                                           countryCode: K.items[row].countryCode,
                                           composition: K.items[row].composition,
                                           productDescription: K.items[row].productNameDescription,
                                           productFeatures: K.items[row].productFeatures,
                                           imageURL: K.items[row].imageURL,
                                           thumbURL: K.items[row].thumbURL,
                                           //This needs to be Storage.storage().reference.child(K.items[row].productCategory + ".png"))
                                           image: nil)
            K.items[row] = newModel
            
            //Update Firebase
            let itemRef: [String: Any] = [K.FIR.division: newModel.division,
                                          K.FIR.collection: newModel.collection,
                                          K.FIR.productNameDescription: tfTitle.text!,
                                          K.FIR.productNameDescriptionSecondary: model.productNameDescriptionSecondary,
                                          K.FIR.productCategory: model.productCategory,
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
                                          K.FIR.imageURL: model.imageURL,
                                          K.FIR.thumbURL: model.thumbURL]
            let ref = Database.database().reference().child(K.items[row].skuCode)
            ref.setValue(itemRef)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
