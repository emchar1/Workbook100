//
//  WorkbookController+DragDrop.swift
//  Workbook100
//
//  Created by Eddie Char on 1/28/22.
//
/*
import UIKit

// MARK: - Drag n Drop
 
extension WorkbookController {
    
    // MARK: - Drag Delegate
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        let item = K.getFilteredItemsIfFiltered[indexPath.row]
        let item = dataColors[indexPath.section][indexPath.row]
        let itemProvider = NSItemProvider(object: item)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        
        dragItem.localObject = item
                
        return [dragItem]
    }
    
    
    // MARK: - Drop Delegate
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            //If dropping multiple items, need to change from .insertAtDestinationIndexPath to .unspecified, though it looks ugly because the cells don't visually shift over to make room
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
        //Reordering of single cell
        if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath {
            collectionView.performBatchUpdates({
//                if K.ProductFilter.isFiltered {
//                    K.filteredItems.remove(at: sourceIndexPath.item)
//                    K.filteredItems.insert(item.dragItem.localObject as! CollectionModel, at: destinationIndexPath.item)
//                }
//                else {
//                    K.items.remove(at: sourceIndexPath.item)
//                    K.items.insert(item.dragItem.localObject as! CollectionModel, at: destinationIndexPath.item)
//                }
                dataColors[sourceIndexPath.section].remove(at: sourceIndexPath.item)
                dataColors[sourceIndexPath.section].insert(item.dragItem.localObject as! UIColor, at: destinationIndexPath.item)

                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }, completion: nil)

            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
        
//        //Reordering of multiple selected cells
//        let items = coordinator.items
//        var dIndexPath = destinationIndexPath
//
//        if dIndexPath.row >= collectionView.numberOfItems(inSection: 0) {
//            dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
//        }
//
//        var sourceIndexPaths = [IndexPath]()
//        var destinationIndexPaths = [IndexPath]()
//
//        for item in items {
//            if let sourceIndexPath = item.sourceIndexPath {
//                sourceIndexPaths.append(sourceIndexPath)
//                destinationIndexPaths.append(dIndexPath)
//                K.items.remove(at: sourceIndexPath.row)
//                K.items.insert(item.dragItem.localObject as! CollectionModel, at: dIndexPath.row)
//                dIndexPath = IndexPath(row: dIndexPath.row + 1, section: 0)
//            }
//        }
//
//        collectionView.performBatchUpdates({
//            collectionView.deleteItems(at: sourceIndexPaths)
//            collectionView.insertItems(at: destinationIndexPaths)
//        })
    }
}
*/
