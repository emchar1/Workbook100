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

class WorkbookViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate, UIPopoverPresentationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var rightMenu: UIBarButtonItem!
    @IBOutlet weak var cancelMultiButton: UIBarButtonItem!
    
    var ref: DatabaseReference!
    var delegate: WorkbookViewControllerDelegate?
    var spinner = ActivitySpinner(style: .large)
    
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
                    K.items.insert(CollectionModel.getBlankModel(), at: indexPath.row)
                    self.collectionView.insertItems(at: [IndexPath(item: indexPath.row, section: 0)])
                }, completion: nil)
            }),
            
//            UIAction(title: "Multi Select", image: nil, handler: { action in
//                self.multiSelect = true
//            }),
            
            UIAction(title: "Export", image: nil, handler: { action in
                var csv: [[String]] = [["SKUCode", "productNameDescription", "productCategory", "Colorway", "CarryOver", "Essential", "USRetailMSRP", "EURetailMSRP", "CountryCode"]]
                
                for item in K.items {
                    csv.append([item.skuCode, item.productNameDescription, item.productCategory, item.colorway, item.carryOver ? "TRUE" : "FALSE", item.essential ? "TRUE" : "FALSE", "\(item.usMSRP)", "\(item.euMSRP)", item.countryCode])
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
                controller.model = K.items[indexPath.row]
            }
        }
    }
}

       
// MARK: - Data Source, Delegate, Flow Layout

extension WorkbookViewController {
    
    // MARK: - Data Source
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch K.items[indexPath.row].productCategory {
        case "Gloves":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GloveCell.reuseId, for: indexPath) as! GloveCell
            cell.model = K.items[indexPath.row]
            cell.setViews()
            return cell
        default:
            if K.items[indexPath.row].productCategory.count > 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reuseId, for: indexPath) as! CollectionCell
                cell.model = K.items[indexPath.row]
                cell.setViews()
                return cell
            }

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellBlank.reuseId, for: indexPath) as! CollectionCellBlank
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return K.items.count
    }
    
    
    // MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !multiSelect {
            performSegue(withIdentifier: "showDetailsNEW", sender: nil)
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    

    // MARK: - Delegate Flow Layout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let multiplier: CGFloat = 1
        
        // FIXME: - adaptable cell size doesn't work!!
//        print(K.CollectionCell.adjustedWidth(in: collectionView))
        let productCategory = K.items[indexPath.row].productCategory
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






// FIXME: - Test for delegation from side panel
extension WorkbookViewController: ProductFilterControllerDelegate {
    func donePressed(selectedCollection: String, selectedProductCategory: String, selectedDivision: String) {
        guard K.items.count > 0 else {
            print("Items still loading. Exiting early")
            delegate?.collapsePanel()
            return
        }
        
        print(selectedCollection)
        print(selectedProductCategory)
        print(selectedDivision)
//        let mohdel = K.items[0]
//
//        //SO HOKEY
//        K.items[0] = CollectionModel(division: mohdel.division,
//                                     collection: mohdel.collection,
//                                     productNameDescription: mohdel.productNameDescription,
//                                     productNameDescriptionSecondary: mohdel.productNameDescriptionSecondary,
//                                     productCategory: mohdel.productCategory,
//                                     colorway: mohdel.colorway,
//                                     carryOver: mohdel.carryOver,
//                                     essential: mohdel.essential,
//                                     skuCode: mohdel.skuCode,
//                                     sizes: [
//                                        CollectionModel.Size(size: mohdel.sizes[0].size, colorwaySKU: "9999"),
//                                        CollectionModel.Size(size: mohdel.sizes[1].size, colorwaySKU: mohdel.sizes[1].colorwaySKU),
//                                        CollectionModel.Size(size: mohdel.sizes[2].size, colorwaySKU: mohdel.sizes[2].colorwaySKU),
//                                        CollectionModel.Size(size: mohdel.sizes[3].size, colorwaySKU: mohdel.sizes[3].colorwaySKU),
//                                        CollectionModel.Size(size: mohdel.sizes[4].size, colorwaySKU: mohdel.sizes[4].colorwaySKU),
//                                        CollectionModel.Size(size: mohdel.sizes[5].size, colorwaySKU: mohdel.sizes[5].colorwaySKU),
//                                        CollectionModel.Size(size: mohdel.sizes[6].size, colorwaySKU: mohdel.sizes[6].colorwaySKU)
//                                     ],
//                                     usMSRP: mohdel.usMSRP,
//                                     euMSRP: mohdel.euMSRP,
//                                     countryCode: mohdel.countryCode,
//                                     composition: mohdel.composition,
//                                     productDescription: mohdel.productDescription,
//                                     productFeatures: mohdel.productFeatures,
//                                     imageURL: mohdel.imageURL,
//                                     thumbURL: mohdel.thumbURL,
//                                     image: mohdel.image)
        
        delegate?.collapsePanel()
    }
}
