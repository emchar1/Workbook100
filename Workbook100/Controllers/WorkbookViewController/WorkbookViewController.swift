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
//        collectionView.backgroundColor = .white
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
                                               seasonsCarried: obj[K.FIR.seasonsCarried] as! String,
                                               productType: obj[K.FIR.productType] as! String,
                                               productSubtype: obj[K.FIR.productSubtype] as! String,
                                               productDetails: obj[K.FIR.productDetails] as! String,
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
                                               primaryImageURL: obj[K.FIR.primaryImageURL] as! String,
                                               thumbURL: obj[K.FIR.thumbURL] as! String,
                                               imageURLs: [obj[K.FIR.imageURL0] as! String,
                                                           obj[K.FIR.imageURL1] as! String,
                                                           obj[K.FIR.imageURL2] as! String,
                                                           obj[K.FIR.imageURL3] as! String,
                                                           obj[K.FIR.imageURL4] as! String,
                                                           obj[K.FIR.imageURL5] as! String,
                                                           obj[K.FIR.imageURL6] as! String,
                                                           obj[K.FIR.imageURL7] as! String,
                                                           obj[K.FIR.imageURL8] as! String,
                                                           obj[K.FIR.imageURL9] as! String,
                                                           obj[K.FIR.imageURL10] as! String],
                                               image: imageRef)
                    
                    K.items.append(item)
                }
            }

            //Re-order everything according to Ludo 3/16/22
            K.items = K.items
                .sorted(by: { $0.productNameDescription < $1.productNameDescription })
                .sorted(by: { $0.productType < $1.productType })
            //add more sorted(by:) the last sorted(by:) has the highest sort priority
            
            self.collectionView.reloadData()
            spinner.stopSpinner()
        }
    }
    
    func setupRightMenu() {
        let menuItems: [UIAction] = [
            UIAction(title: "Insert Blank", image: nil, handler: { action in
                guard let cell = self.collectionView.visibleCells.first, let indexPath = self.collectionView.indexPath(for: cell) else { return }

                self.collectionView.performBatchUpdates({
                    K.ProductFilter.isFiltered ? K.filteredItems.insert(CollectionModel.getBlankModel(), at: indexPath.row) : K.items.insert(CollectionModel.getBlankModel(), at: indexPath.row)
                    
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
                
                for item in (K.ProductFilter.isFiltered ? K.filteredItems : K.items) {
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
                controller.model = K.ProductFilter.isFiltered ? K.filteredItems[indexPath.row] : K.items[indexPath.row]
            }
        }
        else if segue.identifier == "showDetails" {
            let nc = segue.destination as! UINavigationController
            let controller = nc.topViewController as! WorkbookDetailController

            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                controller.model = K.ProductFilter.isFiltered ? K.filteredItems[indexPath.row] : K.items[indexPath.row]
            }
        }
        else if segue.identifier == "showDetailsTVC2" {
            let nc = segue.destination as! UINavigationController
            let controller = nc.topViewController as! WorkbookDetailTVC2

            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                controller.model = K.ProductFilter.isFiltered ? K.filteredItems[indexPath.row] : K.items[indexPath.row]
            }
        }
    }
}

       
// MARK: - Data Source, Delegate, Flow Layout

extension WorkbookViewController {
    
    //Data Source
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch (K.ProductFilter.isFiltered ? K.filteredItems[indexPath.row].productCategory : K.items[indexPath.row].productCategory) {
//        case "Gloves":
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GloveCell.reuseId, for: indexPath) as! GloveCell
//            cell.model = K.ProductFilter.isFiltered ? K.filteredItems[indexPath.row] : K.items[indexPath.row]
//            cell.setViews()
//            return cell
        case K.ProductFilter.wildcard:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellBlank.reuseId, for: indexPath) as! CollectionCellBlank
            return cell
        default:
            if (K.ProductFilter.isFiltered ? K.filteredItems[indexPath.row].productCategory.count : K.items[indexPath.row].productCategory.count) > 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reuseId, for: indexPath) as! CollectionCell
                cell.model = K.ProductFilter.isFiltered ? K.filteredItems[indexPath.row] : K.items[indexPath.row]
                cell.setViews()
                return cell
            }

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellBlank.reuseId, for: indexPath) as! CollectionCellBlank
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return K.ProductFilter.isFiltered ? K.filteredItems.count : K.items.count
    }
    
    
    //Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !multiSelect {
            performSegue(withIdentifier: "showDetailsTVC2", sender: nil)
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    

    //Delegate Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let productCategory = K.ProductFilter.isFiltered ? K.filteredItems[indexPath.row].productCategory : K.items[indexPath.row].productCategory
        var multiplier: CGFloat = 1
        
//        if productCategory == "Gloves" {
//            multiplier = 1.5
//        }
        
        return CGSize(width: K.CollectionCell.adjustedWidth(in: collectionView) * multiplier,
                      height: K.CollectionCell.adjustedHeight(in: collectionView))
    }
}


// MARK: - Product Filter Controller NEW Delegate

extension WorkbookViewController {
    func applyTapped(selectedCollection: String,
                     selectedNew: Int,
                     selectedEssential: Int,
                     selectedLaunchSeason: [String],
                     selectedProductCategory: [String],
                     selectedProductType: [String],
                     selectedProductSubtype: [String],
                     selectedDivision: [String],
                     selectedProductClass: [String],
                     selectedProductDetails: [String]) {
        
        guard K.items.count > 0 else {
            print("Items still loading. Exiting early.")
            delegate?.collapsePanel()
            return
        }
        
        //Set the global constant variables, i.e. make the changes "permanent."
        K.ProductFilter.selectedCollection = selectedCollection
        K.ProductFilter.selectedNew = selectedNew
        K.ProductFilter.selectedEssential = selectedEssential
        K.ProductFilter.selectedLaunchSeason = selectedLaunchSeason
        K.ProductFilter.selectedProductCategory = selectedProductCategory
        K.ProductFilter.selectedProductType = selectedProductType
        K.ProductFilter.selectedProductSubtype = selectedProductSubtype
        K.ProductFilter.selectedDivision = selectedDivision
        K.ProductFilter.selectedProductClass = selectedProductClass
        K.ProductFilter.selectedProductDetails = selectedProductDetails

        K.filteredItems = K.items.filter {
            (selectedCollection == K.ProductFilter.wildcard ? true : $0.collection == selectedCollection) &&
            (selectedNew == K.ProductFilter.segementedBoth ? true : $0.carryOver == (selectedNew == K.ProductFilter.segementedOff)) &&
            (selectedEssential == K.ProductFilter.segementedBoth ? true : $0.essential == (selectedEssential == K.ProductFilter.segementedOn)) &&
            (selectedLaunchSeason.joined().contains(K.ProductFilter.wildcard) ? true : selectedLaunchSeason.joined().contains($0.launchSeason)) &&
            (selectedProductCategory.joined().contains(K.ProductFilter.wildcard) ? true : selectedProductCategory.joined().contains($0.productCategory)) &&
            (selectedProductType.joined().contains(K.ProductFilter.wildcard) ? true : selectedProductType.joined().contains($0.productType)) &&
            (selectedProductSubtype.joined().contains(K.ProductFilter.wildcard) ? true : selectedProductSubtype.joined().contains($0.productSubtype)) &&
            (selectedDivision.joined().contains(K.ProductFilter.wildcard) ? true : selectedDivision.joined().contains($0.division)) &&
            (selectedProductClass.joined().contains(K.ProductFilter.wildcard) ? true : selectedProductClass.joined().contains($0.youthWomen)) &&
            (selectedProductDetails.joined().contains(K.ProductFilter.wildcard) ? true : selectedProductDetails.joined().contains($0.productDetails))
        }
                
        //Show a "No results found" label if the filtered list is empty
        if K.ProductFilter.isFiltered {
            noResultsLabel.isHidden = !K.filteredItems.isEmpty
        }
        else {
            noResultsLabel.isHidden = true
        }
        
        collectionView.reloadData()
        delegate?.collapsePanel()
    }
}
