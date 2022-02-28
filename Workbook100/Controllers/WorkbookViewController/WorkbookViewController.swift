//
//  WorkbookViewController.swift
//  Workbook100
//
//  Created by Eddie Char on 12/14/21.
//

import UIKit
import MessageUI
import Firebase

protocol WorkbookViewControllerDelegate {
    func expandPanel()
    func collapsePanel()
}


// MARK: - Workbook View Controller MAIN CLASS

class WorkbookViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate, UIPopoverPresentationControllerDelegate, MFMailComposeViewControllerDelegate, ProductFilterControllerNEWDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var rightMenu: UIBarButtonItem!
    @IBOutlet weak var cancelMultiButton: UIBarButtonItem!
    
    var ref: DatabaseReference!
    var delegate: WorkbookViewControllerDelegate?
    var spinner = ActivitySpinner(style: .large)
    
    var noResultsLabel: UILabel = {
        let label = UILabel()
        label.font = .workbookTitle
        label.text = "No Results to Display"
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    var multiSelect = false {
        didSet {
            if multiSelect {
                collectionView.allowsMultipleSelection = true
                cancelMultiButton.isEnabled = true
                cancelMultiButton.tintColor = nil
            }
            else {
                collectionView.allowsMultipleSelection = false
                cancelMultiButton.isEnabled = false
                cancelMultiButton.tintColor = .clear
            }
        }
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: K.CollectionCell.padding, left: K.CollectionCell.padding, bottom: K.CollectionCell.padding, right: K.CollectionCell.padding)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CollectionCellBlank.self, forCellWithReuseIdentifier: CollectionCellBlank.reuseId)
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.reuseId)
        collectionView.register(GloveCell.self, forCellWithReuseIdentifier: GloveCell.reuseId)
        return collectionView
    }()

    @IBAction func productFilterTapped(_ sender: Any) {
        delegate?.expandPanel()
    }
    
    @IBAction func cancelMultiTapped(_ sender: Any) {
        multiSelect = false
        
        //If toggling back to single selection, remove all selections. Need to make it loop through ALL cells - visible and not visible
        for i in self.collectionView.indexPathsForVisibleItems {
//            let cell = self.collectionView.cellForItem(at: i)!
//            self.collectionView.deselectItem(at: i, animated: true)
//            if let viewWTag = cell.viewWithTag(200) {
//                viewWTag.removeFromSuperview()
//            }
            
            self.collectionView.deselectItem(at: i, animated: false)
        }
    }
    
    
    // MARK: - Initialization
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRightMenu()

        collectionView.dragInteractionEnabled = true
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                                     collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
                                     view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)])
        
        view.addSubview(noResultsLabel)
        NSLayoutConstraint.activate([noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)])

        spinner.startSpinner(in: view)

        //Firebase DB
        ref = Database.database().reference()
        ref.observe(DataEventType.value) { [self] (snapshot) in
            K.items.removeAll()
            
            for itemSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                if let obj = itemSnapshot.value as? [String: AnyObject] {
                    let imageRef = Storage.storage().reference().child((obj[K.FIR.skuCode] as! String) + ".jpg")
                    
                    let item = CollectionModel(division: obj[K.FIR.division] as! String,
                                               collection: obj[K.FIR.collection] as! String,
                                               productNameDescription: obj[K.FIR.productNameDescription] as! String,
                                               productNameDescriptionSecondary: obj[K.FIR.productNameDescriptionSecondary] as! String,
                                               productCategory: obj[K.FIR.productCategory] as! String,
                                               productDepartment: obj[K.FIR.productDepartment] as! String,
                                               launchSeason: obj[K.FIR.launchSeason] as! String,
                                               productType: obj[K.FIR.productType] as! String,
                                               productSubtype: obj[K.FIR.productSubtype] as! String,
                                               youthWomen: obj[K.FIR.youthWomen] as! String,
                                               colorway: obj[K.FIR.colorway] as! String,
                                               carryOver: (obj[K.FIR.carryOver] as! String) == "TRUE",
                                               essential: (obj[K.FIR.essential] as! String) == "TRUE",
                                               skuCode: obj[K.FIR.skuCode] as! String,
                                               sizes: [
                                                CollectionModel.Size(size: obj[K.FIR.size0] as? String, colorwaySKU: obj[K.FIR.colorwaySKU0] as? String),
                                                CollectionModel.Size(size: obj[K.FIR.size1] as? String, colorwaySKU: obj[K.FIR.colorwaySKU1] as? String),
                                                CollectionModel.Size(size: obj[K.FIR.size2] as? String, colorwaySKU: obj[K.FIR.colorwaySKU2] as? String),
                                                CollectionModel.Size(size: obj[K.FIR.size3] as? String, colorwaySKU: obj[K.FIR.colorwaySKU3] as? String),
                                                CollectionModel.Size(size: obj[K.FIR.size4] as? String, colorwaySKU: obj[K.FIR.colorwaySKU4] as? String),
                                                CollectionModel.Size(size: obj[K.FIR.size5] as? String, colorwaySKU: obj[K.FIR.colorwaySKU5] as? String),
                                                CollectionModel.Size(size: obj[K.FIR.size6] as? String, colorwaySKU: obj[K.FIR.colorwaySKU6] as? String),
                                               ],
                                               usMSRP: (obj[K.FIR.usRetailMSRP] as! NSNumber).doubleValue,
                                               euMSRP: (obj[K.FIR.euRetailMSRP] as! NSNumber).doubleValue,
                                               countryCode: obj[K.FIR.countryCode] as! String,
                                               composition: obj[K.FIR.composition] as! String,
                                               productDescription: obj[K.FIR.productDescription] as! String,
                                               productFeatures: obj[K.FIR.productFeatures] as! String,
                                               imageURL: obj[K.FIR.imageURL] as! String,
                                               thumbURL: obj[K.FIR.thumbURL] as! String,
                                               image: imageRef)
                    
                    K.items.append(item)
                }
            }
            self.collectionView.reloadData()
            spinner.stopSpinner()
        }
    }
    
    func setupRightMenu() {
        let menuItems: [UIAction] = [
            UIAction(title: "Insert Blank", image: nil, handler: { action in
                guard let cell = self.collectionView.visibleCells.first, let indexPath = self.collectionView.indexPath(for: cell) else { return }

                self.collectionView.performBatchUpdates({
                    K.ProductFilterSelection.isFiltered ? K.filteredItems.insert(CollectionModel.getBlankModel(), at: indexPath.row) : K.items.insert(CollectionModel.getBlankModel(), at: indexPath.row)
                    
                    self.collectionView.insertItems(at: [IndexPath(item: indexPath.row, section: 0)])
                }, completion: nil)
            }),
            
//            UIAction(title: "Multi Select", image: nil, handler: { action in
//                self.multiSelect = true
//            }),
            
            UIAction(title: "Export", image: nil, handler: { action in
                var csv: [[String]] = [["SKUCode",
                                        "productNameDescription",
                                        "productCategory",
                                        "productDepartment",
                                        "launchSeason",
                                        "productType",
                                        "productSubtype",
                                        "Colorway",
                                        "CarryOver",
                                        "Essential",
                                        "USRetailMSRP",
                                        "EURetailMSRP",
                                        "CountryCode"]]
                
                for item in (K.ProductFilterSelection.isFiltered ? K.filteredItems : K.items) {
                    csv.append([item.skuCode,
                                item.productNameDescription,
                                item.productCategory,
                                item.productDepartment,
                                item.launchSeason,
                                item.productType,
                                item.productSubtype,
                                item.colorway,
                                item.carryOver ? "TRUE" : "FALSE",
                                item.essential ? "TRUE" : "FALSE",
                                "\(item.usMSRP)",
                                "\(item.euMSRP)",
                                item.countryCode])
                }
                
                self.mailOrder(for: CSVMake.commaSeparatedValueDataForLines(csv))
            }),
            
            UIAction(title: "PDF", image: UIImage(named: "printer"), handler: { action in
                let pdfFilePath = self.collectionView.exportAsPDFFromCollectionView()
                print("PDF saved to: \(pdfFilePath.pdfFilePath)")
                
                if let pdfData = pdfFilePath.pdfData {
                    self.present(UIActivityViewController(activityItems: [pdfData], applicationActivities: []), animated: true, completion: nil)
                }
            })
            
        ]
        
        rightMenu.menu = UIMenu(title: "Settings", image: nil, options: .displayInline, children: menuItems)
    }
    
    
    // MARK: - Orientation Transition
        
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsNEW" {
            let nc = segue.destination as! UINavigationController
            let controller = nc.topViewController as! WorkbookDetailControllerNEW

            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                controller.model = K.ProductFilterSelection.isFiltered ? K.filteredItems[indexPath.row] : K.items[indexPath.row]
            }
        }
    }
}

       
// MARK: - Data Source, Delegate, Flow Layout

extension WorkbookViewController {
    
    //Data Source
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch (K.ProductFilterSelection.isFiltered ? K.filteredItems[indexPath.row].productCategory : K.items[indexPath.row].productCategory) {
        case "Gloves":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GloveCell.reuseId, for: indexPath) as! GloveCell
            cell.model = K.ProductFilterSelection.isFiltered ? K.filteredItems[indexPath.row] : K.items[indexPath.row]
            cell.setViews()
            return cell
        case K.ProductFilterSelection.wildcard:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellBlank.reuseId, for: indexPath) as! CollectionCellBlank
            return cell
        default:
            if (K.ProductFilterSelection.isFiltered ? K.filteredItems[indexPath.row].productCategory.count : K.items[indexPath.row].productCategory.count) > 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reuseId, for: indexPath) as! CollectionCell
                cell.model = K.ProductFilterSelection.isFiltered ? K.filteredItems[indexPath.row] : K.items[indexPath.row]
                cell.setViews()
                return cell
            }

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellBlank.reuseId, for: indexPath) as! CollectionCellBlank
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return K.ProductFilterSelection.isFiltered ? K.filteredItems.count : K.items.count
    }
    
    
    //Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !multiSelect {
            performSegue(withIdentifier: "showDetailsNEW", sender: nil)
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    

    //Delegate Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let multiplier: CGFloat = 1
        
        // FIXME: - adaptable cell size doesn't work!!
//        print(K.CollectionCell.adjustedWidth(in: collectionView))
        let productCategory = K.ProductFilterSelection.isFiltered ? K.filteredItems[indexPath.row].productCategory : K.items[indexPath.row].productCategory
        var multiplier: CGFloat = 1
        
        if productCategory == "Gloves" {
            multiplier = 1.5
        }
        
        return CGSize(width: K.CollectionCell.adjustedWidth(in: collectionView) * multiplier,
                      height: K.CollectionCell.adjustedHeight(in: collectionView))
        //but this one does...
//        return CGSize(width: K.CollectionCell.width * multiplier, height: K.CollectionCell.height * multiplier)
    }
}


// MARK: - Product Filter Controller NEW Delegate

extension WorkbookViewController {
//    func donePressed(selectedCollection: String, selectedProductCategory: String, selectedDivision: String, selectedProductDepartment: String, selectedLaunchSeason: String, selectedProductType: String, selectedProductSubtype: String) {
//        guard K.items.count > 0 else {
//            print("Items still loading. Exiting early")
//            delegate?.collapsePanel()
//            return
//        }
//
//        K.ProductFilterSelection.selectedCollection = selectedCollection
//        K.ProductFilterSelection.selectedProductCategory = selectedProductCategory
//        K.ProductFilterSelection.selectedDivision = selectedDivision
//        K.ProductFilterSelection.selectedProductDepartment = selectedProductDepartment
//        K.ProductFilterSelection.selectedLaunchSeason = selectedLaunchSeason
//        K.ProductFilterSelection.selectedProductType = selectedProductType
//        K.ProductFilterSelection.selectedProductSubtype = selectedProductSubtype
//
//        K.filteredItems = K.items.filter {
//            (selectedCollection == K.ProductFilterSelection.wildcard ? true : $0.collection == selectedCollection) &&
//            (selectedProductCategory == K.ProductFilterSelection.wildcard ? true : $0.productCategory == selectedProductCategory) &&
//            (selectedDivision == K.ProductFilterSelection.wildcard ? true : $0.division == selectedDivision) &&
//            (selectedProductDepartment == K.ProductFilterSelection.wildcard ? true : $0.productDepartment == selectedProductDepartment) &&
//            (selectedLaunchSeason == K.ProductFilterSelection.wildcard ? true : $0.launchSeason == selectedLaunchSeason) &&
//            (selectedProductType == K.ProductFilterSelection.wildcard ? true : $0.productType == selectedProductType) &&
//            (selectedProductSubtype == K.ProductFilterSelection.wildcard ? true : $0.productSubtype == selectedProductSubtype)
//        }
//
//        if K.ProductFilterSelection.isFiltered {
//            noResultsLabel.isHidden = !K.filteredItems.isEmpty
//        }
//        else {
//            noResultsLabel.isHidden = true
//        }
//
//        collectionView.reloadData()
//        delegate?.collapsePanel()
//    }
    
    func applyTapped(selectedDivision: String,
                     selectedLaunchSeason: String,
                     selectedProductCategory: String,
                     selectedProductType: String,
                     selectedProductSubtype: String) {
        
        guard K.items.count > 0 else {
            print("Items still loading. Exiting early")
            delegate?.collapsePanel()
            return
        }
        
        K.ProductFilterSelection.selectedDivision = selectedDivision
        K.ProductFilterSelection.selectedLaunchSeason = selectedLaunchSeason
        K.ProductFilterSelection.selectedProductCategory = selectedProductCategory
        K.ProductFilterSelection.selectedProductType = selectedProductType
        K.ProductFilterSelection.selectedProductSubtype = selectedProductSubtype
        
        K.filteredItems = K.items.filter {
            (selectedDivision == K.ProductFilterSelection.wildcard ? true : $0.division == selectedDivision) &&
            (selectedLaunchSeason == K.ProductFilterSelection.wildcard ? true : $0.launchSeason == selectedLaunchSeason) &&
            (selectedProductCategory == K.ProductFilterSelection.wildcard ? true : $0.productCategory == selectedProductCategory) &&
            (selectedProductType == K.ProductFilterSelection.wildcard ? true : $0.productType == selectedProductType) &&
            (selectedProductSubtype == K.ProductFilterSelection.wildcard ? true : $0.productSubtype == selectedProductSubtype)
        }
                
        noResultsLabel.isHidden = K.ProductFilterSelection.isFiltered ? !K.filteredItems.isEmpty : true
        
        collectionView.reloadData()
        delegate?.collapsePanel()
    }
}
