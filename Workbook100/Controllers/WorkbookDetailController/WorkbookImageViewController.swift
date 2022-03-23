//
//  WorkbookImageViewController.swift
//  Workbook100
//
//  Created by Eddie Char on 3/22/22.
//

import UIKit

class WorkbookImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var spinner = ActivitySpinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFill
    }
    
    
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
