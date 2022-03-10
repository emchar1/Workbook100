//
//  WorkbookTableVC.swift
//  Workbook100
//
//  Created by Eddie Char on 3/1/22.
//

import UIKit

class WorkbookTableVC: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = "\(indexPath.row + 1): \(K.items[indexPath.row].skuCode)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return K.items.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMe" {
            let nc = segue.destination as! UINavigationController
            let controller = nc.topViewController as! WorkbookDetailControllerNEW

            if let indexPath = tableView.indexPathForSelectedRow {
                controller.model = K.items[indexPath.row]
            }
        }
    }
}
