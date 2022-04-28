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
        
        let inset: CGFloat = 40

        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 80
        flowLayout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
        collectionView.register(CollectionCellPage.self, forCellWithReuseIdentifier: CollectionCellPage.reuseId)
        collectionView.register(CollectionCellBlank.self, forCellWithReuseIdentifier: CollectionCellBlank.reuseId)
        collectionView.backgroundColor = UIColor(white: 0.6, alpha: 1.0)

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
}


// MARK: - Collection View stuff
extension WorkbookController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellPage.reuseId, for: indexPath) as? CollectionCellPage else { return UICollectionViewCell() }
        
//        if cell.contentView.subviews.count == 0 {
//            for i in 0..<3 {
//                for j in 0..<3 {
//                    let padding: CGFloat = 5
//                    let subCell = CollectionCellBlank()
//                    subCell.backgroundColor = .systemPink
//                    subCell.translatesAutoresizingMaskIntoConstraints = false
//                    
//                    cell.contentView.addSubview(subCell)
//                    NSLayoutConstraint.activate([subCell.topAnchor.constraint(equalTo: cell.contentView.topAnchor,
//                                                                              constant: CGFloat(i) * cell.contentView.frame.height / 3),
//                                                 subCell.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor,
//                                                                                  constant: CGFloat(j) * cell.contentView.frame.width / 3),
//                                                 subCell.widthAnchor.constraint(equalToConstant: cell.contentView.frame.width / 3 - padding),
//                                                 subCell.heightAnchor.constraint(equalToConstant: cell.contentView.frame.height / 3 - padding)])
//                }
//            }
//        }
        
//        switch indexPath.section {
//        case 0:
//            cell.backgroundColor = .red
//        case 1:
//            cell.backgroundColor = .orange
//
//            let cb = UITableViewCell()
//            cb.backgroundColor = .purple
//            cb.translatesAutoresizingMaskIntoConstraints = false
//            cell.addSubview(cb)
//
//            NSLayoutConstraint.activate([cb.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 0.75),
//                                         cb.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 0.75),
//                                         cb.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
//                                         cb.centerYAnchor.constraint(equalTo: cell.centerYAnchor)])
//        case 2:
//            cell.backgroundColor = .green
//        default:
//            cell.backgroundColor = .blue
//        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat
        var height: CGFloat
        let factor: CGFloat = 8.5 / 14.0
        
        if UIDevice.current.orientation.isLandscape {
            height = collectionView.frame.height - 240
            print("height: \(height)")
            width = height / factor
        }
        else {
            width = collectionView.frame.width
            print("width: \(width)")
            height = width * factor
        }
        
        return CGSize(width: width, height: height)
    }
}


// MARK: - Product Filter Delegate
extension WorkbookController {
    func applyTapped(selectedLineList: String, selectedNew: Int, selectedEssential: Int, selectedCollection: String, selectedSeasonsCarried: [String], selectedProductCategory: [String], selectedProductType: [String], selectedProductSubtype: [String], selectedDivision: [String], selectedProductClass: [String], selectedProductDetails: [String]) {
        
        print("applyTapped")
    }
}
