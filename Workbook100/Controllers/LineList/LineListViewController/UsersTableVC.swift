//
//  UsersTableVC.swift
//  Workbook100
//
//  Created by Eddie Char on 12/13/22.
//

import UIKit

class UsersTableVC: UITableViewController {

    // MARK: - Properties

    var users: [String] = [
        "FE Sports",
        "LeMANS",
        "Matrix"
    ]
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersCell.reuseID, for: indexPath) as! UsersCell

        cell.label.text = users[indexPath.row]

        return cell
    }
}
