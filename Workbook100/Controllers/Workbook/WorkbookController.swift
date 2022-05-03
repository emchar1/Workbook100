//
//  WorkbookController.swift
//  Workbook100
//
//  Created by Eddie Char on 4/25/22.
//

import MessageUI
import UIKit

class WorkbookController: UIViewController,
//                          UICollectionViewDelegateFlowLayout,
                          UICollectionViewDragDelegate,
                          UICollectionViewDropDelegate,
                          UIPopoverPresentationControllerDelegate,
                          MFMailComposeViewControllerDelegate {
    
    var collectionView: UICollectionView!
//    var flowLayout: UICollectionViewFlowLayout!
    var dataColors: [[UIColor]] = [[.red, .orange, .systemPink, .yellow, .green, .cyan, .systemIndigo, .purple, .magenta],
                                   [.yellow, .green, .cyan],
                                   [.cyan, .blue, .purple],
                                   [.purple, .magenta, .systemPink]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        
//        let inset: CGFloat = 80
//
//        flowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = .vertical
//        flowLayout.minimumLineSpacing = 40
//        flowLayout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCustomLayout())
        collectionView.register(CollectionCellPage.self, forCellWithReuseIdentifier: CollectionCellPage.reuseID)
        collectionView.register(CollectionCellBlank.self, forCellWithReuseIdentifier: CollectionCellBlank.reuseID)
        collectionView.backgroundColor = UIColor(white: 0.6, alpha: 1.0)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
        
        //Did this in lieu of viewDidLayoutSubviews() because this seems more elegant...
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(collectionView)
    }
    
//    //Not elegant!
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        print("WorkbookController.viewDidLayoutSubviews()")
//
//        collectionView.frame = view.frame
//        collectionView.collectionViewLayout.invalidateLayout()
//    }
}


// MARK: - Collection View stuff

extension WorkbookController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataColors.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataColors[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellPage.reuseID, for: indexPath) as? CollectionCellPage else { return UICollectionViewCell() }
        
        cell.containerView.backgroundColor = dataColors[indexPath.section][indexPath.row]

        return cell
    }
            
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var width: CGFloat
//        var height: CGFloat
//        let factor: CGFloat = 8.5 / 14.0
//
//        if UIDevice.current.orientation.isLandscape {
//            height = collectionView.frame.height
//            width = height / factor
//        }
//        else {
//            width = collectionView.frame.width
//            height = width * factor
//        }
//
//        return CGSize(width: width, height: height)
//    }
}
    
    
    // MARK: - Collection View Compositional Layout - NEW STUFF!!
    
extension WorkbookController {
    //Allows for nested cells in Section -> Group -> Item hierarchy
    func createCustomLayout() -> UICollectionViewLayout {
        let padding: CGFloat = 5
        
        let layout = UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let layoutItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let layoutItem = NSCollectionLayoutItem(layoutSize: layoutItemSize)
            layoutItem.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
            
            let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1/3))
            let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
            
            let section = NSCollectionLayoutSection(group: layoutGroup)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
//            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
            
            return section
            
//            let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
//
//            let leadingItem = NSCollectionLayoutItem(layoutSize: layoutSize)
//            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
//            let leadingGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: leadingItem, count: 3)
//
//            let trailingItem = NSCollectionLayoutItem(layoutSize: layoutSize)
//            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
//            let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: trailingItem, count: 3)
//
//            let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(self.view.frame.width))
//            let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize, subitems: [leadingGroup, trailingGroup])
//
//            let section = NSCollectionLayoutSection(group: containerGroup)
//            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
//            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
//
//            return section
        }
        
        return layout
    }
}


// MARK: - Product Filter Delegate

extension WorkbookController: ProductFilterControllerDelegate {
    func applyTapped(selectedLineList: String, selectedNew: Int, selectedEssential: Int, selectedCollection: String, selectedSeasonsCarried: [String], selectedProductCategory: [String], selectedProductType: [String], selectedProductSubtype: [String], selectedDivision: [String], selectedProductClass: [String], selectedProductDetails: [String]) {
        
        print("applyTapped")
    }
}
