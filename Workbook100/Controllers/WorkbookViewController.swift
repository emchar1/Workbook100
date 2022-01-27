//
//  WorkbookViewController.swift
//  Workbook100
//
//  Created by Eddie Char on 12/14/21.
//

import UIKit
import Firebase

protocol WorkbookViewControllerDelegate {
    func expandPanel()
    func collapsePanel()
}

class WorkbookViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate, UIPopoverPresentationControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var rightMenu: UIBarButtonItem!
    
    var ref: DatabaseReference!
    var delegate: WorkbookViewControllerDelegate?
    //var items: [CollectionModel] = []
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: K.CollectionCell.padding, left: K.CollectionCell.padding, bottom: K.CollectionCell.padding, right: K.CollectionCell.padding)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: K.CollectionCell.identifier + "0")
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: K.CollectionCell.identifier)
        collectionView.register(CollectionCell2.self, forCellWithReuseIdentifier: K.CollectionCell.identifier + "2")
        return collectionView
    }()

    @IBAction func productFilterTapped(_ sender: Any) {
        delegate?.expandPanel()
    }
    
    
    // MARK: - Initialization
        
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)        
    }
    
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
        
        
        
        //Firebase DB
        ref = Database.database().reference()
        ref.observe(DataEventType.value) { [self] (snapshot) in
            K.items.removeAll()
            
            for itemSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                if let obj = itemSnapshot.value as? [String: AnyObject] {
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
                                               //This needs to be Storage.storage().reference.child(K.items[row].productCategory + ".png"))
                                               image: Storage.storage().reference().child((obj[K.FIR.skuCode] as! String) + ".jpg"))
                    /*
                    let item = CollectionModel(showNew: (obj["showNew"] as! String) == "TRUE",
                                               showEssential: (obj["showEssential"] as! String) == "TRUE",
                                               labelTitle: obj["labelTitle"] as! String,
                                               labelSubtitle: obj["labelSubtitle"] as! String,
                                               imageName: obj["imageName"] as! String,
                                               sizes: [
                                                CollectionModel.Size(size: CollectionModel.Size.sm, sku: obj[CollectionModel.Size.sm] as? String),
                                                CollectionModel.Size(size: CollectionModel.Size.md, sku: obj[CollectionModel.Size.md] as? String),
                                                CollectionModel.Size(size: CollectionModel.Size.lg, sku: obj[CollectionModel.Size.lg] as? String),
                                                CollectionModel.Size(size: CollectionModel.Size.xl, sku: obj[CollectionModel.Size.xl] as? String),
                                                CollectionModel.Size(size: CollectionModel.Size.xxl, sku: obj[CollectionModel.Size.xxl] as? String),
                                               ],
                                               image: Storage.storage().reference().child((obj["imageName"] as! String) + ".jpg"))
                     */

                    K.items.append(item)
                }
            }
            self.collectionView.reloadData()
        }
    }
    
    func setupRightMenu() {
        let menuItems: [UIAction] = [
            UIAction(title: "Add Blank", image: nil, handler: { action in
                print("Blank")
                
                guard let cell = self.collectionView.visibleCells.first, let indexPath = self.collectionView.indexPath(for: cell) else { return }

                self.collectionView.performBatchUpdates ({
                    K.items.insert(CollectionModel.getBlankModel(), at: indexPath.row)
                    self.collectionView.insertItems(at: [IndexPath(item: indexPath.row, section: 0)])
                }, completion: nil)
            }),
            UIAction(title: "Multi-Select", image: nil, handler: { action in
                self.collectionView.allowsMultipleSelection = true

                print("Multi")
            }),
            UIAction(title: "Cancel", image: nil, handler: { action in
                self.collectionView.allowsMultipleSelection = false
                
                
                for i in self.collectionView.indexPathsForVisibleItems {
                    self.collectionView.deselectItem(at: i, animated: true)
                }
                print("Cancel")

            }),
            UIAction(title: "Export", image: nil, handler: { action in
                
            })
        ]
        
        rightMenu.menu = UIMenu(title: "Settings", image: nil, options: .displayInline, children: menuItems)
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

       
// MARK: - Collection View Extensions

extension WorkbookViewController {
    
    
    // MARK: - Data Source
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch K.items[indexPath.row].productCategory {
        case "Apparel", "Gloves", "Accessories", "Gear":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionCell.identifier, for: indexPath) as! CollectionCell
            cell.model = K.items[indexPath.row]
            cell.setViews()
            return cell
        case "Geart":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionCell.identifier + "2", for: indexPath) as! CollectionCell2
            cell.label.text = K.items[indexPath.row].productDescription
            return cell
        default:
            break
        }

        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionCell.identifier + "0", for: indexPath)
        cell.backgroundColor = .clear
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return K.items.count
    }
    
    
    // MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "showDetailsNEW", sender: nil)
    }
    

    // MARK: - Delegate Flow Layout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let multiplier: CGFloat = 1
        
        // FIXME: - adaptable cell size doesn't work!!
//        print(K.CollectionCell.adjustedWidth(in: collectionView))
        let productCategory = K.items[indexPath.row].productCategory
        let multiplix: CGFloat = (productCategory == "Apparel" || productCategory == "Gloves" || productCategory == "Accessories") ? 1 : 1
        return CGSize(width: K.CollectionCell.adjustedWidth(in: collectionView) * multiplix,
                      height: K.CollectionCell.adjustedHeight(in: collectionView) * multiplix)
        //but this one does...
//        return CGSize(width: K.CollectionCell.width * multiplier, height: K.CollectionCell.height * multiplier)
    }
    
    
    // MARK: - Drag Delegate
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = K.items[indexPath.row]
        let itemProvider = NSItemProvider(object: item)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        
        dragItem.localObject = item

        return [dragItem]
    }
    
    
    // MARK: - Drop Delegate
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        }
        else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }
        
        if coordinator.proposal.operation == .move {
            self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
    }
    
    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath {
            collectionView.performBatchUpdates({
                K.items.remove(at: sourceIndexPath.item)
                K.items.insert(item.dragItem.localObject as! CollectionModel, at: destinationIndexPath.item)
                
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }, completion: nil)

            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }
}


// MARK: - Right Menu Controls
extension WorkbookViewController {
    func menuItemTapped(_ item: RightMenuController.MenuItem) {
        switch item {
        case .addBlank:
            print("Blank")
            
            guard let cell = collectionView.visibleCells.first, let indexPath = collectionView.indexPath(for: cell) else { return }

            collectionView.performBatchUpdates ({
                K.items.insert(CollectionModel.getBlankModel(), at: indexPath.row)
                collectionView.insertItems(at: [IndexPath(item: indexPath.row, section: 0)])
            }, completion: nil)
        case .multiSelect:
            collectionView.allowsMultipleSelection = true

            print("Multi")
        case .cancel:
            collectionView.allowsMultipleSelection = false
            
            
            for i in collectionView.indexPathsForVisibleItems {
                collectionView.deselectItem(at: i, animated: true)
            }
            print("Cancel")
        case .export:
            

            print("Export")
        }
    }
}


// FIXME: - Test for delegation from side panel
extension WorkbookViewController: ProductFilterControllerDelegate {
    func youDonePressedDone() {
        guard K.items.count > 0 else {
            print("Items still loading. Exiting early")
            delegate?.collapsePanel()
            return
        }
        
        
        let mohdel = K.items[0]

        //SO HOKEY
        K.items[0] = CollectionModel(division: mohdel.division,
                                     collection: mohdel.collection,
                                     productNameDescription: mohdel.productNameDescription,
                                     productNameDescriptionSecondary: mohdel.productNameDescriptionSecondary,
                                     productCategory: mohdel.productCategory,
                                     colorway: mohdel.colorway,
                                     carryOver: mohdel.carryOver,
                                     essential: mohdel.essential,
                                     skuCode: mohdel.skuCode,
                                     sizes: [
                                        CollectionModel.Size(size: mohdel.sizes[0].size, colorwaySKU: "9999"),
                                        CollectionModel.Size(size: mohdel.sizes[1].size, colorwaySKU: mohdel.sizes[1].colorwaySKU),
                                        CollectionModel.Size(size: mohdel.sizes[2].size, colorwaySKU: mohdel.sizes[2].colorwaySKU),
                                        CollectionModel.Size(size: mohdel.sizes[3].size, colorwaySKU: mohdel.sizes[3].colorwaySKU),
                                        CollectionModel.Size(size: mohdel.sizes[4].size, colorwaySKU: mohdel.sizes[4].colorwaySKU),
                                        CollectionModel.Size(size: mohdel.sizes[5].size, colorwaySKU: mohdel.sizes[5].colorwaySKU),
                                        CollectionModel.Size(size: mohdel.sizes[6].size, colorwaySKU: mohdel.sizes[6].colorwaySKU)
                                     ],
                                     usMSRP: mohdel.usMSRP,
                                     euMSRP: mohdel.euMSRP,
                                     countryCode: mohdel.countryCode,
                                     composition: mohdel.composition,
                                     productDescription: mohdel.productDescription,
                                     productFeatures: mohdel.productFeatures,
                                     image: mohdel.image)
        
        delegate?.collapsePanel()
    }
}
