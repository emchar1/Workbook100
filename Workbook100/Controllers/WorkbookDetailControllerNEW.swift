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
    @IBOutlet weak var tfSmall: UITextField!
    @IBOutlet weak var tfMedium: UITextField!
    @IBOutlet weak var tfLarge: UITextField!
    @IBOutlet weak var tfXL: UITextField!
    @IBOutlet weak var tfXXL: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    var model: CollectionModel!
    
    override func viewDidLoad() {
        if model == nil {
            self.model = CollectionModel(showNew: true,
                                         showEssential: true,
                                         labelTitle: "Product Title",
                                         labelSubtitle: "Product Subtitle",
                                         imageName: "20026-20",
                                         sizes: [
                                            CollectionModel.Size(size: CollectionModel.Size.sm, sku: "00000-00001"),
                                            CollectionModel.Size(size: CollectionModel.Size.md, sku: "00000-00002"),
                                            CollectionModel.Size(size: CollectionModel.Size.lg, sku: "00000-00003"),
                                            CollectionModel.Size(size: CollectionModel.Size.xl, sku: "00000-00004"),
                                            CollectionModel.Size(size: nil, sku: "00000-00005")
                                         ],
                                         image: nil)
        }
        
        title = model.labelTitle
        
        switchNew.isOn = model.showNew
        switchEssential.isOn = model.showEssential
        tfTitle.text = model.labelTitle
        tfSubtitle.text = model.labelSubtitle
        tfSmall.text = model.sizes.filter({ $0.size == CollectionModel.Size.sm }).first?.sku
        tfMedium.text = model.sizes.filter({ $0.size == CollectionModel.Size.md }).first?.sku
        tfLarge.text = model.sizes.filter({ $0.size == CollectionModel.Size.lg }).first?.sku
        tfXL.text = model.sizes.filter({ $0.size == CollectionModel.Size.xl }).first?.sku
        tfXXL.text = model.sizes.filter({ $0.size == CollectionModel.Size.xxl }).first?.sku

        if let image = model.image {
            imageView.sd_setImage(with: image)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // FIXME: didSelectRow switch cases - not sure I like this???
        switch (indexPath.section, indexPath.row) {
        case (1, 0): tfTitle.becomeFirstResponder()
        case (1, 1): tfSubtitle.becomeFirstResponder()
        case (2, 0): tfSmall.becomeFirstResponder()
        case (2, 1): tfMedium.becomeFirstResponder()
        case (2, 2): tfLarge.becomeFirstResponder()
        case (2, 3): tfXL.becomeFirstResponder()
        case (2, 4): tfXXL.becomeFirstResponder()
        default: break
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        print("Cancel pressed")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        if let row = K.items.firstIndex(where: { $0.id == model.id }) {
            print(K.items[row])
            
            // FIXME: Need to update K.items with edited model/item
            //Update Model
            let newModel = CollectionModel(showNew: switchNew.isOn,
                                           showEssential: switchEssential.isOn,
                                           labelTitle: tfTitle.text!,
                                           labelSubtitle: tfSubtitle.text!,
                                           imageName: K.items[row].imageName,
                                           sizes: [
                                            CollectionModel.Size(size: CollectionModel.Size.sm, sku: tfSmall.text!),
                                            CollectionModel.Size(size: CollectionModel.Size.md, sku: tfMedium.text!),
                                            CollectionModel.Size(size: CollectionModel.Size.lg, sku: tfLarge.text!),
                                            CollectionModel.Size(size: CollectionModel.Size.xl, sku: tfXL.text!),
                                            CollectionModel.Size(size: CollectionModel.Size.xxl, sku: tfXXL.text!),
                                           ],
                                           image: Storage.storage().reference().child(K.items[row].imageName + ".jpg"))
            K.items[row] = newModel
            
            //Update Firebase
            let itemRef: [String: Any] = ["showNew": String(switchNew.isOn).uppercased(),//String(item.showNew).uppercased(),
                                          "showEssential": String(switchEssential.isOn).uppercased(),
                                          "labelTitle": tfTitle.text!,//item.labelTitle,
                                          "labelSubtitle": tfSubtitle.text!,// item.labelSubtitle,
                                          "imageName": K.items[row].imageName,
                                          CollectionModel.Size.sm: newModel.sizes.filter({ $0.size == CollectionModel.Size.sm }).first?.sku ?? "",
                                          CollectionModel.Size.md: newModel.sizes.filter({ $0.size == CollectionModel.Size.md }).first?.sku ?? "",
                                          CollectionModel.Size.lg: newModel.sizes.filter({ $0.size == CollectionModel.Size.lg }).first?.sku ?? "",
                                          CollectionModel.Size.xl: newModel.sizes.filter({ $0.size == CollectionModel.Size.xl }).first?.sku ?? "",
                                          CollectionModel.Size.xxl: newModel.sizes.filter({ $0.size == CollectionModel.Size.xxl }).first?.sku ?? ""]
            let ref = Database.database().reference().child(K.items[row].imageName)
            ref.setValue(itemRef)
        }
        
        print("Done pressed")
        dismiss(animated: true, completion: nil)
    }
}
