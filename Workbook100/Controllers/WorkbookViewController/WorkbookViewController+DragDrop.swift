//
//  WorkbookViewController+DragDrop.swift
//  Workbook100
//
//  Created by Eddie Char on 1/28/22.
//

import UIKit

// MARK: - Drag n Drop
 
extension WorkbookViewController {
    
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
        
//        for item in coordinator.items {
//            if let sourceIndexPath = item.sourceIndexPath {
//                collectionView.performBatchUpdates({
//
//                    K.items.remove(at: sourceIndexPath.item)
//                    K.items.insert(item.dragItem.localObject as! CollectionModel, at: destinationIndexPath.item)
//
//                    collectionView.deleteItems(at: [sourceIndexPath])
//                    collectionView.insertItems(at: [destinationIndexPath])
//                }, completion: nil)
//
//                coordinator.drop(item.dragItem, to: destinationIndexPath)
//            }
//        }
    }
}
