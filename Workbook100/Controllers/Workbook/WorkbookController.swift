//
//  WorkbookController.swift
//  Workbook100
//
//  Created by Eddie Char on 4/25/22.
//

import MessageUI
import UIKit

class WorkbookController: UIViewController,
                          UICollectionViewDelegate,
                          UICollectionViewDataSource,
                          UICollectionViewDelegateFlowLayout,
                          UICollectionViewDragDelegate,
                          UICollectionViewDropDelegate,
                          UIPopoverPresentationControllerDelegate,
                          MFMailComposeViewControllerDelegate,
                          ProductFilterControllerDelegate {
    
    var collectionView: UICollectionView!
    var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .magenta
        
        let inset: CGFloat = 80

        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 20
        flowLayout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
        collectionView.isPagingEnabled = true
        collectionView.register(CollectionCellBlank.self, forCellWithReuseIdentifier: CollectionCellBlank.reuseId)
        collectionView.backgroundColor = .gray
        
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.dragDelegate = self
//        collectionView.dropDelegate = self
//        collectionView.dragInteractionEnabled = true
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("WorkbookController.viewDidLayoutSubviews()")
        
        collectionView.frame = view.frame
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
//    private func configureCollectionViewLayoutItemSize() {
//        let inset: CGFloat = 50
//
//        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
//        flowLayout.itemSize = CGSize(width: 200, height: 200)
//    }
}


// MARK: - Collection View stuff
extension WorkbookController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellBlank.reuseId, for: indexPath) as! CollectionCellBlank
        
        switch indexPath.section {
        case 0:
            cell.backgroundColor = .red
        case 1:
            cell.backgroundColor = .orange
            
            let cb = UITableViewCell()
            cb.backgroundColor = .purple
            cb.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(cb)
            
            NSLayoutConstraint.activate([cb.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 0.75),
                                         cb.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 0.75),
                                         cb.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
                                         cb.centerYAnchor.constraint(equalTo: cell.centerYAnchor)])
        case 2:
            cell.backgroundColor = .green
        default:
            cell.backgroundColor = .blue
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150,//collectionView.frame.width,
                      height: 150)//collectionView.frame.height * 2 / 3)
    }
}


// MARK: - Product Filter Delegate
extension WorkbookController {
    func applyTapped(selectedLineList: String, selectedNew: Int, selectedEssential: Int, selectedCollection: String, selectedSeasonsCarried: [String], selectedProductCategory: [String], selectedProductType: [String], selectedProductSubtype: [String], selectedDivision: [String], selectedProductClass: [String], selectedProductDetails: [String]) {
        
        print("applyTapped")
    }
}
