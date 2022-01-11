//
//  WorkbookViewController.swift
//  Workbook100
//
//  Created by Eddie Char on 12/14/21.
//

import UIKit
import Firebase

class WorkbookViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    // MARK: - Properties
    
    var ref: DatabaseReference!
    //var items: [CollectionModel] = []
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: K.CollectionCell.padding, left: K.CollectionCell.padding, bottom: K.CollectionCell.padding, right: K.CollectionCell.padding)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: K.CollectionCell.identifier)
        return collectionView
    }()
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dragDelegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                                     collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),//, constant: view.frame.height / 2),
                                     view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
                                     view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)])
        
        
        
        //Firebase DB
        ref = Database.database().reference()
        ref.observe(DataEventType.value) { [self] (snapshot) in
            K.items.removeAll()
            
            for itemSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                if let obj = itemSnapshot.value as? [String: AnyObject] {
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

                    K.items.append(item)
                }
            }
            self.collectionView.reloadData()
        }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CollectionCell.identifier, for: indexPath) as! CollectionCell

        cell.model = K.items[indexPath.row]
        cell.setViews()

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return K.items.count
    }
    

    // MARK: - Delegate Flow Layout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let multiplier: CGFloat = 1
        
        return CGSize(width: K.CollectionCell.width * multiplier, height: K.CollectionCell.height * multiplier)
    }
    
    
    // MARK: - Drag Delegate
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        // FIXME: - item should be the entire model, not just the label title?
        let item = K.items[indexPath.row].labelTitle
        let itemProvider = NSItemProvider(object: item as NSString)
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
    
    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
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
    
    
    // MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailsNEW", sender: nil)
    }
    
}
