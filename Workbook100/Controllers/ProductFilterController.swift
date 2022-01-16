//
//  ProductFilterController.swift
//  Workbook100
//
//  Created by Eddie Char on 1/15/22.
//

import UIKit

protocol ProductFilterControllerDelegate {
    func youDonePressedDone(_ tfVar: Int)
}

class ProductFilterController: UITableViewController {
    @IBOutlet weak var tf: UITextField!
    
    var tfVar: Int = 0
    var delegate: ProductFilterControllerDelegate?
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        tfVar = Int(tf.text!)!
        delegate?.youDonePressedDone(tfVar)
    }
    
    override func viewDidLoad() {
        
    }
}
