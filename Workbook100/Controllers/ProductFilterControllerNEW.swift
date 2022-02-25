//
//  ProductFilterControllerNEW.swift
//  Workbook100
//
//  Created by Eddie Char on 2/25/22.
//

import UIKit

class ProductFilterControllerNEW: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 9 {
            
            return 100
        }
        
        return 40
    }
}
