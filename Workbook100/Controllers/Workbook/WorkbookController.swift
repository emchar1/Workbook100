//
//  WorkbookController.swift
//  Workbook100
//
//  Created by Eddie Char on 4/25/22.
//

import MessageUI
import UIKit

class WorkbookController: UIViewController,
                          UICollectionViewDragDelegate,
                          UICollectionViewDropDelegate,
                          UIPopoverPresentationControllerDelegate,
                          MFMailComposeViewControllerDelegate {
    
    // MARK: - Properties
    
    var collectionView: UICollectionView!
//    var refreshControl = UIRefreshControl()
    
    var allSections: [Section]!
    
    //can't delete this for now because it's used in drag/drop
    var dataColors: [[UIColor]] = [[.red, .orange, .systemPink, .yellow, .green, .cyan, .systemIndigo, .purple, .magenta],
                                   [.yellow, .green, .cyan],
                                   [.cyan, .blue, .purple],
                                   [.purple, .magenta, .systemPink]]

    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
                
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeLayout())
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.reuseID)
        collectionView.register(CollectionCellPage.self, forCellWithReuseIdentifier: CollectionCellPage.reuseID)
        collectionView.register(CollectionCellBlank.self, forCellWithReuseIdentifier: CollectionCellBlank.reuseID)
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionHeaderView.reuseID)
        collectionView.collectionViewLayout.register(BackgroundSupplementaryView.self, forDecorationViewOfKind: BackgroundSupplementaryView.reuseID)
        collectionView.backgroundColor = UIColor(white: 0.6, alpha: 1.0)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
        
        //Did this in lieu of viewDidLayoutSubviews() because this seems more elegant...
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(collectionView)
        
        
        
        refreshData()
    }
    
    private func refreshData() {
        let section0 = Section(id: 0, type: .oneByOne, data: Array(repeating: 0, count: 1)) //Array(K.getFilteredItemsIfFiltered[0...0]))
        let section1 = Section(id: 1, type: .twoByOne, data: Array(repeating: 1, count: 2)) //Array(K.getFilteredItemsIfFiltered[1...2]))
        let section2 = Section(id: 2, type: .sixByThree, data: Array(K.getFilteredItemsIfFiltered[3...20]))
        let section3 = Section(id: 3, type: .twoByOne, data: Array(repeating: 0, count: 2)) //Array(K.getFilteredItemsIfFiltered[21...22]))
        allSections = [section0, section1, section2, section3]
        
        print("Controls refreshed!")
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
    
    
    
    // MARK: - UI Bar Button Items
    
    @IBAction func addSection(_ sender: UIBarButtonItem) {

//        var sectionType: SectionType = .sixByThree {
//            didSet {
//                switch sectionType {
//                case .oneByOne: numberOfItems = 1
//                case .twoByOne: numberOfItems = 2
//                case .sixByThree: numberOfItems = 18
//                }
//            }
//        }

        let alertController = UIAlertController(title: "Add Section", message: "Add a section, asshole", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "One by One", style: .default, handler: { _ in
            if let highestSection = (self.allSections.max { first, second in first.id >= second.id }) {
                self.didAddSection(id: highestSection.id, type: .oneByOne, data: Array(repeating: 0, count: 1))
            }
        }))
                                  
        alertController.addAction(UIAlertAction(title: "Two by One", style: .default, handler: { _ in
            if let highestSection = (self.allSections.max { first, second in first.id >= second.id }) {
                self.didAddSection(id: highestSection.id, type: .twoByOne, data: Array(repeating: 0, count: 2))
            }
        }))

        alertController.addAction(UIAlertAction(title: "Six by Three", style: .default, handler: { _ in
            if let highestSection = (self.allSections.max { first, second in first.id >= second.id }) {
                self.didAddSection(id: highestSection.id, type: .sixByThree, data: Array(repeating: 0, count: 18))
            }
        }))
        
//        alertController.popoverPresentationController?.barButtonItem = sender
//        alertController.popoverPresentationController?.sourceView = collectionView
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showProductList", sender: nil)
    }
    
    private func didAddSection(id: Int, type: SectionType, data: Array<Any>) {
        self.allSections.append(Section(id: id, type: type, data: data))
        self.collectionView.reloadData()
        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: self.allSections.count - 1), at: .top, animated: true)
    }
}


// MARK: - Collection View stuff

extension WorkbookController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return allSections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allSections[section].data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailsTVC2", sender: nil)
        
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if allSections[indexPath.section].data[indexPath.row] is CollectionModel {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reuseID, for: indexPath) as? CollectionCell else { return UICollectionViewCell() }
            
            cell.model = allSections[indexPath.section].data[indexPath.row] as? CollectionModel
            cell.setViews()

            return cell
        }
        else if allSections[indexPath.section].data[indexPath.row] is Int {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellBlank.reuseID, for: indexPath) as? CollectionCellBlank else { return UICollectionViewCell() }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        if scrollView.contentOffset.y < -200 {
//            refreshData()
//            collectionView.reloadData()
//        }
//    }
    
    // FIXME: - Footer not working
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderView.reuseID, for: indexPath) as? CollectionHeaderView else {
            fatalError("Could not dequeue SectionHeader")
        }
        
        headerView.label.text = "kj;lkj;l\(indexPath.section)"
        
        return headerView
    }
}
    
    
    // MARK: - Collection View Compositional Layout - NEW STUFF!!
    
extension WorkbookController {
    private func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            switch self.allSections[section].type {
            case .oneByOne: return self.createOneByOne()
            case .twoByOne: return self.createTwoByOne()
            case .sixByThree: return self.createSixByThree()
            }
        }
        
        return layout
    }
    
    private func createOneByOne() ->  NSCollectionLayoutSection {
        let padding: CGFloat = 8
        let sectionMultiplier: CGFloat = 4
        let backgroundMultiplier: CGFloat = 4

        let layoutItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutItemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(3/4))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitem: layoutItem, count: 1)

        let section = NSCollectionLayoutSection(group: layoutGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: padding * sectionMultiplier, leading: padding * sectionMultiplier, bottom: padding * sectionMultiplier, trailing: padding * sectionMultiplier)
        
        let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundSupplementaryView.reuseID)
        backgroundItem.contentInsets = NSDirectionalEdgeInsets(top: padding * backgroundMultiplier, leading: padding * backgroundMultiplier, bottom: padding * backgroundMultiplier, trailing: padding * backgroundMultiplier)
        
        section.decorationItems = [backgroundItem]
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(8)),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom)]
        
        return section
    }
    
    private func createTwoByOne() ->  NSCollectionLayoutSection {
        let padding: CGFloat = 8
        let sectionMultiplier: CGFloat = 4
        let backgroundMultiplier: CGFloat = 4

        let layoutItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutItemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(3/4))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitem: layoutItem, count: 2)

        let section = NSCollectionLayoutSection(group: layoutGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: padding * sectionMultiplier, leading: padding * sectionMultiplier, bottom: padding * sectionMultiplier, trailing: padding * sectionMultiplier)
        
        let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundSupplementaryView.reuseID)
        backgroundItem.contentInsets = NSDirectionalEdgeInsets(top: padding * backgroundMultiplier, leading: padding * backgroundMultiplier, bottom: padding * backgroundMultiplier, trailing: padding * backgroundMultiplier)
        
        section.decorationItems = [backgroundItem]
        
        return section
    }
    
    private func createSixByThree() ->  NSCollectionLayoutSection {
        let padding: CGFloat = 8
        let sectionMultiplier: CGFloat = 8
        let backgroundMultiplier: CGFloat = 4

        let layoutItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutItemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/4))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitem: layoutItem, count: 6)

        let section = NSCollectionLayoutSection(group: layoutGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: padding * sectionMultiplier, leading: padding * sectionMultiplier, bottom: padding * sectionMultiplier, trailing: padding * sectionMultiplier)
        
        let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundSupplementaryView.reuseID)
        backgroundItem.contentInsets = NSDirectionalEdgeInsets(top: padding * backgroundMultiplier, leading: padding * backgroundMultiplier, bottom: padding * backgroundMultiplier, trailing: padding * backgroundMultiplier)
        
        section.decorationItems = [backgroundItem]
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(8)),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom)]

        
        return section
    }
    
    
    //Allows for nested cells in Section -> Group -> Item hierarchy
//    func createCustomLayout() -> UICollectionViewLayout {
//        let layout = UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
//            let padding: CGFloat = 8
//            let sectionMultiplier: CGFloat = 8
//            let backgroundMultiplier: CGFloat = 4
//
//            let layoutItemSize0 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//            let layoutItem0 = NSCollectionLayoutItem(layoutSize: layoutItemSize0)
//            layoutItem0.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
//
//            let layoutGroupSize0 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/4))
//            let layoutGroup0 = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize0, subitem: layoutItem0, count: section % 2 == 0 ? 6 : 3)
//
////            let layoutItemSize1 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
////            let layoutItem1 = NSCollectionLayoutItem(layoutSize: layoutItemSize1)
////            layoutItem1.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
//
////            let layoutGroupSize1 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/4))
////            let layoutGroup1 = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize1, subitem: layoutItem0, count: 4)
//
////            let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize0, subitems: [layoutGroup0, layoutGroup1])
//
//            let section = NSCollectionLayoutSection(group: layoutGroup0)
////            section.orthogonalScrollingBehavior = .continuous
//            section.contentInsets = NSDirectionalEdgeInsets(top: padding * sectionMultiplier, leading: padding * sectionMultiplier, bottom: padding * sectionMultiplier, trailing: padding * sectionMultiplier)
//
//            let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundSupplementaryView.reuseID)
//            backgroundItem.contentInsets = NSDirectionalEdgeInsets(top: padding * backgroundMultiplier, leading: padding * backgroundMultiplier, bottom: padding * backgroundMultiplier, trailing: padding * backgroundMultiplier)
//
//            section.decorationItems = [backgroundItem]
//
//            return section
//
////            let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
////            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
////
////            let leadingItem = NSCollectionLayoutItem(layoutSize: layoutSize)
////            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
////            let leadingGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: leadingItem, count: 3)
////
////            let trailingItem = NSCollectionLayoutItem(layoutSize: layoutSize)
////            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
////            let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: trailingItem, count: 3)
////
////            let containerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(self.view.frame.width))
////            let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: containerGroupSize, subitems: [leadingGroup, trailingGroup])
////
////            let section = NSCollectionLayoutSection(group: containerGroup)
////            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
////            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
////
////            return section
//        }
//
//        return layout
//    }
}


// MARK: - Product Filter Delegate

extension WorkbookController: ProductFilterControllerDelegate {
    func applyTapped(selectedLineList: String, selectedNew: Int, selectedEssential: Int, selectedCollection: String, selectedSeasonsCarried: [String], selectedProductCategory: [String], selectedProductType: [String], selectedProductSubtype: [String], selectedDivision: [String], selectedProductClass: [String], selectedProductDetails: [String]) {
        
        print("applyTapped")
    }
}
