//
//  RightMenuController.swift
//  Workbook100
//
//  Created by Eddie Char on 1/25/22.
//

import UIKit

class RightMenuCell: UITableViewCell {
    @IBOutlet weak var menuItemLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}


protocol RightMenuControllerDelegate {
    func menuItemTapped(_ item: RightMenuController.MenuItem)
}

class RightMenuController: UITableViewController {
    enum MenuItem: String {
        case addBlank = "Add Blank"
        case multiSelect = "Multi-Select"
        case cancel = "Cancel"
        case export = "Export"
    }
    
    var menuItems: [MenuItem] = [.addBlank, .multiSelect, .cancel, .export]
    var delegate: RightMenuControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.layer.borderWidth = 10
//        view.layer.borderColor = UIColor.magenta.cgColor
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuItemCell", for: indexPath) as! RightMenuCell
        cell.menuItemLabel.text = menuItems[indexPath.row].rawValue
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuItems.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.menuItemTapped(menuItems[indexPath.row])

        //eventually I want to animate your selection so it blinks 3 times (3 on, 3 off)
        self.dismiss(animated: true, completion: nil)
    }
}
