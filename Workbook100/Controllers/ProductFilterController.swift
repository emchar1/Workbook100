//
//  ProductFilterController.swift
//  Workbook100
//
//  Created by Eddie Char on 1/15/22.
//

import UIKit


// MARK: - HStackSelection

class HStackSelection: UIStackView {
    static let cellPadding: CGFloat = 8.0
    
    var selectedItemView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var dropdownButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        button.backgroundColor = .black
        button.layer.borderColor = UIColor.black.cgColor
        button.tintColor = .white
        button.layer.borderWidth = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var selectedItemLabel: UILabel = {
        let label = UILabel()
        label.font = .workbookMenuSelection
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var selectedItem: String

    
    init(frame: CGRect, selectedItem: String) {
        self.selectedItem = selectedItem
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("Error loading HStackSelection in ProductFilterController")
    }
    
    private func setupViews() {
        axis = .horizontal
        distribution = .fillProportionally
        translatesAutoresizingMaskIntoConstraints = false
        
        selectedItemLabel.text = selectedItem
        
        addArrangedSubview(selectedItemView)
        addArrangedSubview(dropdownButton)
        selectedItemView.addSubview(selectedItemLabel)

        NSLayoutConstraint.activate([selectedItemLabel.centerYAnchor.constraint(equalTo: selectedItemView.centerYAnchor),
                                     selectedItemLabel.leadingAnchor.constraint(equalTo: selectedItemView.leadingAnchor,
                                                                                constant: HStackSelection.cellPadding),
                                     selectedItemView.trailingAnchor.constraint(equalTo: selectedItemLabel.trailingAnchor,
                                                                                constant: HStackSelection.cellPadding)])
        
        NSLayoutConstraint.activate([dropdownButton.widthAnchor.constraint(equalToConstant: 34)])
    }
}


// MARK: - VStackContent

class VStackContent: UIStackView {
    static let cellPadding: CGFloat = 8.0
    
    var titleView: UIView!
    var selectionView: UIView!
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .workbookMenuTitle
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var titleText: String
    var selectionItems: [String]
    var selectedItem: String
    var hStack: HStackSelection!
    
    init(frame: CGRect, titleText: String, selectionItems: [String], selectedItem: String) {
        self.titleText = titleText
        self.selectionItems = selectionItems
        self.selectedItem = selectedItem

        super.init(frame: frame)
        
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("Error loading VStackContent in ProductFilterController")
    }
    
    private func setupViews() {
        distribution = .fillEqually
        axis = .vertical

        titleView = UIView()
        selectionView = UIView()
        addArrangedSubview(titleView)
        addArrangedSubview(selectionView)
        
        titleLabel.text = titleText + ":"
        titleView.addSubview(titleLabel)
        NSLayoutConstraint.activate([titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: VStackContent.cellPadding),
                                     titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor)])
        
        hStack = HStackSelection(frame: .zero, selectedItem: selectedItem)
        selectionView.addSubview(hStack)
        NSLayoutConstraint.activate([hStack.topAnchor.constraint(equalTo: selectionView.topAnchor, constant: VStackContent.cellPadding),
                                     hStack.leadingAnchor.constraint(equalTo: selectionView.leadingAnchor, constant: VStackContent.cellPadding),
                                     selectionView.trailingAnchor.constraint(equalTo: hStack.trailingAnchor, constant: VStackContent.cellPadding),
                                     selectionView.bottomAnchor.constraint(equalTo: hStack.bottomAnchor, constant: VStackContent.cellPadding)])
    }
    
    
    func addTrailingPadding(in superView: UIView, padding: CGFloat) {
        NSLayoutConstraint.activate([superView.trailingAnchor.constraint(equalTo: selectionView.trailingAnchor,
                                                                         constant: padding + VStackContent.cellPadding)])
    }
}


// MARK: - TableViewCell

class TableViewCell: UITableViewCell { }


// MARK: - ProductFilterController

protocol ProductFilterControllerDelegate {
    func donePressed(selectedCollection: String, selectedProductCategory: String, selectedDivision: String)
}


class ProductFilterController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    
    let padding: CGFloat = 8.0
    let tableViewCellHeight: CGFloat = 34
    let transparentView = UIView()
    let tableView = UITableView()
    var dataSource = [String]()
    var selectedItemLabel = UILabel()
    var expandDistance: CGFloat = 0
    var delegate: ProductFilterControllerDelegate?
    
    var vStack1: VStackContent = {
        let vStack = VStackContent(frame: .zero,
                                   titleText: "Collection",
                                   selectionItems: K.ProductFilterSelection.selectionCollections,
                                   selectedItem: K.ProductFilterSelection.selectedCollection)
        vStack.hStack.dropdownButton.addTarget(self, action: #selector(onClickSelectCollection(_:)), for: .touchUpInside)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
    }()
    var vStack2: VStackContent = {
        let vStack = VStackContent(frame: .zero,
                                   titleText: "Product Category",
                                   selectionItems: K.ProductFilterSelection.selectionProductCategories,
                                   selectedItem: K.ProductFilterSelection.selectedProductCategory)
        vStack.hStack.dropdownButton.addTarget(self, action: #selector(onClickSelectProductCategory(_:)), for: .touchUpInside)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
    }()
    var vStack3: VStackContent = {
        let vStack = VStackContent(frame: .zero,
                                   titleText: "Division",
                                   selectionItems: K.ProductFilterSelection.selectionDivisions,
                                   selectedItem: K.ProductFilterSelection.selectedDivision)
        vStack.hStack.dropdownButton.addTarget(self, action: #selector(onClickSelectDivision(_:)), for: .touchUpInside)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
    }()
    
    var clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear Filters", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapClear(_:)), for: .touchUpInside)
        return button
    }()
    
    var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapDone(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func didTapDone(_ sender: UIButton) {
        delegate?.donePressed(selectedCollection: vStack1.hStack.selectedItemLabel.text!,
                              selectedProductCategory: vStack2.hStack.selectedItemLabel.text!,
                              selectedDivision: vStack3.hStack.selectedItemLabel.text!)
    }
    
    @objc func didTapClear(_ sender: UIButton) {
        vStack1.hStack.selectedItemLabel.text = K.ProductFilterSelection.wildcard
        vStack2.hStack.selectedItemLabel.text = K.ProductFilterSelection.wildcard
        vStack3.hStack.selectedItemLabel.text = K.ProductFilterSelection.wildcard
    }

    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        view.backgroundColor = .workbookSuperLightGray
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let titleLabel = UILabel()
        titleLabel.text = "Filters"
        titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
                                     titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
                                     titleLabel.widthAnchor.constraint(equalToConstant: 100)])
        
        view.addSubview(vStack1)
        NSLayoutConstraint.activate([vStack1.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
                                     vStack1.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     vStack1.heightAnchor.constraint(equalToConstant: 100)])
        
        view.addSubview(vStack2)
        NSLayoutConstraint.activate([vStack2.topAnchor.constraint(equalTo: vStack1.bottomAnchor, constant: 0),
                                     vStack2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     vStack2.heightAnchor.constraint(equalToConstant: 100)])

        view.addSubview(vStack3)
        NSLayoutConstraint.activate([vStack3.topAnchor.constraint(equalTo: vStack2.bottomAnchor, constant: 0),
                                     vStack3.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     vStack3.heightAnchor.constraint(equalToConstant: 100)])
        
        view.addSubview(doneButton)
        NSLayoutConstraint.activate([doneButton.topAnchor.constraint(equalTo: vStack3.bottomAnchor, constant: 100),
                                     doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
                                     doneButton.widthAnchor.constraint(equalToConstant: 80),
                                     doneButton.heightAnchor.constraint(equalToConstant: 50)])

        view.addSubview(clearButton)
        NSLayoutConstraint.activate([clearButton.topAnchor.constraint(equalTo: vStack3.bottomAnchor, constant: 100),
                                     clearButton.leadingAnchor.constraint(equalTo: doneButton.trailingAnchor, constant: 8),
                                     clearButton.widthAnchor.constraint(equalToConstant: 100),
                                     clearButton.heightAnchor.constraint(equalToConstant: 50)])

    }
    
    override func viewDidAppear(_ animated: Bool) {
        //These add a trailing padding x2 just before the center navigation left edge.
        vStack1.addTrailingPadding(in: view, padding: expandDistance)
        vStack2.addTrailingPadding(in: view, padding: expandDistance)
        vStack3.addTrailingPadding(in: view, padding: expandDistance)
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
        dataSource = vStack1.selectionItems
        selectedItemLabel = vStack1.hStack.selectedItemLabel
        addTransparentView(frame: vStack1.hStack.selectedItemView.frame, yOffset: 160)
    }

    @objc func onClickSelectProductCategory(_ sender: Any) {
        dataSource = vStack2.selectionItems
        selectedItemLabel = vStack2.hStack.selectedItemLabel
        addTransparentView(frame: vStack2.hStack.selectedItemView.frame, yOffset: 260)
    }

    @objc func onClickSelectDivision(_ sender: Any) {
        dataSource = vStack3.selectionItems
        selectedItemLabel = vStack3.hStack.selectedItemLabel
        addTransparentView(frame: vStack3.hStack.selectedItemView.frame, yOffset: 360)
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
