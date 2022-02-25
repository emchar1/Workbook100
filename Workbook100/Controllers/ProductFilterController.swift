//
//  ProductFilterController.swift
//  Workbook100
//
//  Created by Eddie Char on 1/15/22.
//

import UIKit



// FIXME: - MAKE THIS A TABLEVIEW!!! CAN STILL HAVE DROP DOWN???

class TableViewCell: UITableViewCell { }


protocol ProductFilterControllerDelegate {
    func donePressed(selectedCollection: String,
                     selectedProductCategory: String,
                     selectedDivision: String,
                     selectedProductDepartment: String,
                     selectedLaunchSeason: String,
                     selectedProductType: String,
                     selectedProductSubtype: String)
}


class ProductFilterController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    
    let padding: CGFloat = 8.0
    let tableViewCellHeight: CGFloat = 34
    var expandDistance: CGFloat = 0
    var dataSource = [String]()
    var delegate: ProductFilterControllerDelegate?
    
    let transparentView = UIView()
    let tableView = UITableView()
    let titleLabel = UILabel()
    var selectedItemLabel = UILabel()
    
    lazy var vStackMain = UIStackView(arrangedSubviews: [vStackCollection, vStackProductCategory, vStackDivision, vStackProductDepartment, vStackLaunchSeason, vStackProductType, vStackProductSubtype])
    var vStackCollection: VStackContent!
    var vStackProductCategory: VStackContent!
    var vStackDivision: VStackContent!
    var vStackProductDepartment: VStackContent!
    var vStackLaunchSeason: VStackContent!
    var vStackProductType: VStackContent!
    var vStackProductSubtype: VStackContent!
    
    var clearButton: UIButton!
    var doneButton: UIButton!
    
    @objc func didTapDone(_ sender: UIButton) {
        delegate?.donePressed(selectedCollection: vStackCollection.hStack.selectedItemLabel.text!,
                              selectedProductCategory: vStackProductCategory.hStack.selectedItemLabel.text!,
                              selectedDivision: vStackDivision.hStack.selectedItemLabel.text!,
                              selectedProductDepartment: vStackProductDepartment.hStack.selectedItemLabel.text!,
                              selectedLaunchSeason: vStackLaunchSeason.hStack.selectedItemLabel.text!,
                              selectedProductType: vStackProductType.hStack.selectedItemLabel.text!,
                              selectedProductSubtype: vStackProductSubtype.hStack.selectedItemLabel.text!)
    }
    
    @objc func didTapClear(_ sender: UIButton) {
        for stacks in vStackMain.arrangedSubviews {
            let stack = stacks as! VStackContent
            
            stack.hStack.selectedItemLabel.text = K.ProductFilterSelection.wildcard
        }
        
//        vStackCollection.hStack.selectedItemLabel.text = K.ProductFilterSelection.wildcard
//        vStackProductCategory.hStack.selectedItemLabel.text = K.ProductFilterSelection.wildcard
//        vStackDivision.hStack.selectedItemLabel.text = K.ProductFilterSelection.wildcard
    }

    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        view.backgroundColor = .workbookSuperLightGray
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
                
        setupViews()
        layoutViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //These add a trailing padding x2 just before the center navigation left edge.
        vStackCollection.addTrailingPadding(in: view, padding: expandDistance)
        vStackProductCategory.addTrailingPadding(in: view, padding: expandDistance)
        vStackDivision.addTrailingPadding(in: view, padding: expandDistance)
        vStackProductDepartment.addTrailingPadding(in: view, padding: expandDistance)
        vStackLaunchSeason.addTrailingPadding(in: view, padding: expandDistance)
        vStackProductType.addTrailingPadding(in: view, padding: expandDistance)
        vStackProductSubtype.addTrailingPadding(in: view, padding: expandDistance)
    }
    
    
    // MARK: - Helper Functions
    
    /**
     Initializes and sets up the various UIViews.
     */
    private func setupViews() {
        titleLabel.text = "Filters"
        titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
                
        vStackCollection = VStackContent(frame: .zero,
                                         titleText: "Collection",
                                         selectionItems: K.ProductFilterSelection.selectionCollection,
                                         selectedItem: K.ProductFilterSelection.selectedCollection)
        vStackCollection.hStack.dropdownButton.addTarget(self, action: #selector(onClickSelectCollection(_:)), for: .touchUpInside)
        vStackCollection.translatesAutoresizingMaskIntoConstraints = false
        
        vStackProductCategory = VStackContent(frame: .zero,
                                              titleText: "Product Category",
                                              selectionItems: K.ProductFilterSelection.selectionProductCategory,
                                              selectedItem: K.ProductFilterSelection.selectedProductCategory)
        vStackProductCategory.hStack.dropdownButton.addTarget(self, action: #selector(onClickSelectProductCategory(_:)), for: .touchUpInside)
        vStackProductCategory.translatesAutoresizingMaskIntoConstraints = false
        
        vStackDivision = VStackContent(frame: .zero,
                                       titleText: "Division",
                                       selectionItems: K.ProductFilterSelection.selectionDivision,
                                       selectedItem: K.ProductFilterSelection.selectedDivision)
        vStackDivision.hStack.dropdownButton.addTarget(self, action: #selector(onClickSelectDivision(_:)), for: .touchUpInside)
        vStackDivision.translatesAutoresizingMaskIntoConstraints = false
        
        vStackProductDepartment = VStackContent(frame: .zero,
                                                titleText: "Product Department",
                                                selectionItems: K.ProductFilterSelection.selectionProductDepartment,
                                                selectedItem: K.ProductFilterSelection.selectedProductDepartment)
        vStackProductDepartment.hStack.dropdownButton.addTarget(self, action: #selector(onClickSelectProductDepartment(_:)), for: .touchUpInside)
        vStackProductDepartment.translatesAutoresizingMaskIntoConstraints = false
        
        vStackLaunchSeason = VStackContent(frame: .zero,
                                           titleText: "Launch Season",
                                           selectionItems: K.ProductFilterSelection.selectionLaunchSeason,
                                           selectedItem: K.ProductFilterSelection.selectedLaunchSeason)
        vStackLaunchSeason.hStack.dropdownButton.addTarget(self, action: #selector(onClickSelectLaunchSeason(_:)), for: .touchUpInside)
        vStackLaunchSeason.translatesAutoresizingMaskIntoConstraints = false
        
        vStackProductType = VStackContent(frame: .zero,
                                          titleText: "Product Type",
                                          selectionItems: K.ProductFilterSelection.selectionProductType,
                                          selectedItem: K.ProductFilterSelection.selectedProductType)
        vStackProductType.hStack.dropdownButton.addTarget(self, action: #selector(onClickSelectProductType(_:)), for: .touchUpInside)
        vStackProductType.translatesAutoresizingMaskIntoConstraints = false
        
        vStackProductSubtype = VStackContent(frame: .zero,
                                             titleText: "Product Subtype",
                                             selectionItems: K.ProductFilterSelection.selectionProductSubtype,
                                             selectedItem: K.ProductFilterSelection.selectedProductSubtype)
        vStackProductSubtype.hStack.dropdownButton.addTarget(self, action: #selector(onClickSelectProductSubtype(_:)), for: .touchUpInside)
        vStackProductSubtype.translatesAutoresizingMaskIntoConstraints = false
        
        vStackMain.axis = .vertical
        vStackMain.distribution = .fillEqually
        vStackMain.translatesAutoresizingMaskIntoConstraints = false


        clearButton = UIButton(type: .system)
        clearButton.setTitle("Clear Filters", for: .normal)
        clearButton.setTitleColor(.white, for: .normal)
        clearButton.backgroundColor = .black
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.addTarget(self, action: #selector(didTapClear(_:)), for: .touchUpInside)
        
        doneButton = UIButton(type: .system)
        doneButton.setTitle("Apply", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.backgroundColor = .black
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(didTapDone(_:)), for: .touchUpInside)
    }
    
    /**
     Lays out the views, subviews, and constraints.
     */
    private func layoutViews() {
//        let heightConstant: CGFloat = 80
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
                                     titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
                                     titleLabel.widthAnchor.constraint(equalToConstant: 100)])
        
        view.addSubview(vStackMain)
        NSLayoutConstraint.activate([vStackMain.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
                                     vStackMain.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     view.bottomAnchor.constraint(equalTo: vStackMain.bottomAnchor, constant: 100)])
        
//        view.addSubview(vStackCollection)
//        NSLayoutConstraint.activate([vStackCollection.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
//                                     vStackCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//                                     vStackCollection.heightAnchor.constraint(equalToConstant: heightConstant)])
//
//        view.addSubview(vStackProductCategory)
//        NSLayoutConstraint.activate([vStackProductCategory.topAnchor.constraint(equalTo: vStackCollection.bottomAnchor, constant: 0),
//                                     vStackProductCategory.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//                                     vStackProductCategory.heightAnchor.constraint(equalToConstant: heightConstant)])
//
//        view.addSubview(vStackDivision)
//        NSLayoutConstraint.activate([vStackDivision.topAnchor.constraint(equalTo: vStackProductCategory.bottomAnchor, constant: 0),
//                                     vStackDivision.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//                                     vStackDivision.heightAnchor.constraint(equalToConstant: heightConstant)])
//
//        view.addSubview(vStackProductDepartment)
//        NSLayoutConstraint.activate([vStackProductDepartment.topAnchor.constraint(equalTo: vStackDivision.bottomAnchor, constant: 0),
//                                     vStackProductDepartment.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//                                     vStackProductDepartment.heightAnchor.constraint(equalToConstant: heightConstant)])
//
//        view.addSubview(vStackLaunchSeason)
//        NSLayoutConstraint.activate([vStackLaunchSeason.topAnchor.constraint(equalTo: vStackProductDepartment.bottomAnchor, constant: 0),
//                                     vStackLaunchSeason.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//                                     vStackLaunchSeason.heightAnchor.constraint(equalToConstant: heightConstant)])
//
//        view.addSubview(vStackProductType)
//        NSLayoutConstraint.activate([vStackProductType.topAnchor.constraint(equalTo: vStackLaunchSeason.bottomAnchor, constant: 0),
//                                     vStackProductType.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//                                     vStackProductType.heightAnchor.constraint(equalToConstant: heightConstant)])
//
//        view.addSubview(vStackProductSubtype)
//        NSLayoutConstraint.activate([vStackProductSubtype.topAnchor.constraint(equalTo: vStackProductType.bottomAnchor, constant: 0),
//                                     vStackProductSubtype.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//                                     vStackProductSubtype.heightAnchor.constraint(equalToConstant: heightConstant)])
//
        view.addSubview(doneButton)
        NSLayoutConstraint.activate([doneButton.topAnchor.constraint(equalTo: vStackMain.bottomAnchor, constant: 10),
                                     doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
                                     doneButton.widthAnchor.constraint(equalToConstant: 80),
                                     doneButton.heightAnchor.constraint(equalToConstant: 50)])

        view.addSubview(clearButton)
        NSLayoutConstraint.activate([clearButton.topAnchor.constraint(equalTo: vStackMain.bottomAnchor, constant: 10),
                                     clearButton.leadingAnchor.constraint(equalTo: doneButton.trailingAnchor, constant: 8),
                                     clearButton.widthAnchor.constraint(equalToConstant: 100),
                                     clearButton.heightAnchor.constraint(equalToConstant: 50)])
    }
}


// MARK: - Menu Selection

extension ProductFilterController {
    func addTransparentView(frame: CGRect, yOffset: CGFloat) {
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
                
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frame.origin.x + padding, y: frame.origin.y - padding + yOffset, width: frame.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 0
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        tableView.reloadData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frame.origin.x + self.padding, y: frame.origin.y - self.padding + yOffset,
                                          width: frame.width, height: CGFloat(self.dataSource.count) * self.tableViewCellHeight)
        }, completion: nil)
    }
    
    @objc func removeTransparentView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.alpha = 0
        }, completion: { _ in
            self.transparentView.removeFromSuperview()
            self.tableView.removeFromSuperview()
            self.tableView.alpha = 1
        })
    }
    
    @objc func onClickSelectCollection(_ sender: Any) {
        dataSource = vStackCollection.selectionItems
        selectedItemLabel = vStackCollection.hStack.selectedItemLabel
        addTransparentView(frame: vStackCollection.hStack.selectedItemView.frame, yOffset: 160)
    }

    @objc func onClickSelectProductCategory(_ sender: Any) {
        dataSource = vStackProductCategory.selectionItems
        selectedItemLabel = vStackProductCategory.hStack.selectedItemLabel
        addTransparentView(frame: vStackProductCategory.hStack.selectedItemView.frame, yOffset: 260)
    }

    @objc func onClickSelectDivision(_ sender: Any) {
        dataSource = vStackDivision.selectionItems
        selectedItemLabel = vStackDivision.hStack.selectedItemLabel
        addTransparentView(frame: vStackDivision.hStack.selectedItemView.frame, yOffset: 360)
    }

    @objc func onClickSelectProductDepartment(_ sender: Any) {
        dataSource = vStackProductDepartment.selectionItems
        selectedItemLabel = vStackProductDepartment.hStack.selectedItemLabel
        addTransparentView(frame: vStackProductDepartment.hStack.selectedItemView.frame, yOffset: 460)
    }

    @objc func onClickSelectLaunchSeason(_ sender: Any) {
        dataSource = vStackLaunchSeason.selectionItems
        selectedItemLabel = vStackLaunchSeason.hStack.selectedItemLabel
        addTransparentView(frame: vStackLaunchSeason.hStack.selectedItemView.frame, yOffset: 560)
    }

    @objc func onClickSelectProductType(_ sender: Any) {
        dataSource = vStackProductType.selectionItems
        selectedItemLabel = vStackProductType.hStack.selectedItemLabel
        addTransparentView(frame: vStackProductType.hStack.selectedItemView.frame, yOffset: 660)
    }

    @objc func onClickSelectProductSubtype(_ sender: Any) {
        dataSource = vStackProductSubtype.selectionItems
        selectedItemLabel = vStackProductSubtype.hStack.selectedItemLabel
        addTransparentView(frame: vStackProductSubtype.hStack.selectedItemView.frame, yOffset: 760)
    }
}


// MARK: - Table View Delegate and DataSource for Menu Selection

extension ProductFilterController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.textLabel?.font = .workbookMenuSelection
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Sets the label on the last selectedItem because of pass by reference (UILabel)
        selectedItemLabel.text = dataSource[indexPath.row]
        removeTransparentView()
    }
}

