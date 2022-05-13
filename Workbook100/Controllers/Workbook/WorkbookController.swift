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
    var selectedIndexPath: IndexPath?
    
    //can't delete this for now because it's used in drag/drop
    var dataColors: [[UIColor]] = [[.red, .orange, .systemPink, .yellow, .green, .cyan, .systemIndigo, .purple, .magenta],
                                   [.yellow, .green, .cyan],
                                   [.cyan, .blue, .purple],
                                   [.purple, .magenta, .systemPink]]

    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeLayout())
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.reuseID)
        collectionView.register(CollectionCellPage.self, forCellWithReuseIdentifier: CollectionCellPage.reuseID)
        collectionView.register(CollectionCellBlank.self, forCellWithReuseIdentifier: CollectionCellBlank.reuseID)
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionHeaderView.reuseID)
        collectionView.collectionViewLayout.register(BackgroundSupplementaryView.self, forDecorationViewOfKind: BackgroundSupplementaryView.reuseID)
        collectionView.backgroundColor = UIColor(white: 0.1, alpha: 1.0)

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
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        
//        if let collectionView = collectionView {
//            collectionView.reloadData()
//            print("reloaded")
//        }
//        
//        print("resize")
//    }
    
    private func refreshData() {
        let section0 = Section(id: 0, type: .size_1x1, data: [0]) //Array(K.getFilteredItemsIfFiltered[0...0]))
        let section1 = Section(id: 1, type: .size_2x1, data: [0, 1]) //Array(K.getFilteredItemsIfFiltered[1...2]))
        let section2 = Section(id: 2, type: .size_6x3, data: Array(repeating: 2, count: 18)) //Array(K.getFilteredItemsIfFiltered[3...20]))
        let section3 = Section(id: 3, type: .size_2x1, data: [1, 0]) //Array(K.getFilteredItemsIfFiltered[21...22]))
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
        let alertController = UIAlertController(title: "Add Section", message: "Select a Section to Add:", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "One by One", style: .default, handler: { _ in
            if let highestSection = (self.allSections.max { first, second in first.id < second.id }) {
                self.didAddSection(id: highestSection.id, type: .size_1x1, data: [0])
            }
        }))
                                  
        alertController.addAction(UIAlertAction(title: "Two by One", style: .default, handler: { _ in
            if let highestSection = (self.allSections.max { first, second in first.id < second.id }) {
                self.didAddSection(id: highestSection.id, type: .size_2x1, data: [0, 1])
            }
        }))

        alertController.addAction(UIAlertAction(title: "Six by Three", style: .default, handler: { _ in
            if let highestSection = (self.allSections.max { first, second in first.id < second.id }) {
                self.didAddSection(id: highestSection.id, type: .size_6x3, data: Array(repeating: 2, count: 18))
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "(Three by Three) by Two", style: .default, handler: { _ in
            if let highestSection = (self.allSections.max { first, second in first.id < second.id }) {
                self.didAddSection(id: highestSection.id, type: .size_3x3x2, data: Array(K.items[0...9]))
            }
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showProductList", sender: nil)
    }
    
    private func didAddSection(id: Int, type: SectionType, data: Array<Any>) {
        self.allSections.append(Section(id: id + 1, type: type, data: data))
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
        selectedIndexPath = indexPath
        
        if allSections[indexPath.section].data[indexPath.row] is CollectionModel {
            performSegue(withIdentifier: "showDetailsTVC2", sender: nil)
        }
        else if allSections[indexPath.section].data[indexPath.row] is Int {
            let vc = ProductListController()
            vc.delegate = self
            present(vc, animated: true)
        }

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
            
            switch allSections[indexPath.section].data[indexPath.row] as! Int {
            case 0: cell.contentView.backgroundColor = .magenta
            case 1: cell.contentView.backgroundColor = .cyan
            case 2: cell.contentView.backgroundColor = .orange
            case 3: cell.contentView.backgroundColor = .systemPink
            default: cell.contentView.backgroundColor = .gray
            }
            
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
        let layout = UICollectionViewCompositionalLayout { (section: Int,
                                                            environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            switch self.allSections[section].type {
            case .size_1x1: return self.layoutSection(widthCount: 1, heightCount: 1, padding: 0)
            case .size_2x1: return self.layoutSection(widthCount: 2, heightCount: 1, padding: 0)
            case .size_6x3: return self.layoutSection(widthCount: 6, heightCount: 3)
            case .size_3x3x2: return self.layoutSectionWithSub()
            }
        }
        
        return layout
    }
    
    private func layoutSection(widthCount: Int, heightCount: Int, padding: CGFloat = 8) -> NSCollectionLayoutSection {
        
        let layoutItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutItemSize)
        layoutItem.contentInsets = setContentInsets(padding: padding)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .fractionalWidth(Section.resolution / CGFloat(heightCount)))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitem: layoutItem, count: widthCount)
        
        let section = NSCollectionLayoutSection(group: layoutGroup)
        section.contentInsets = setContentInsets(padding: Section.backgroundPadding + padding)
        section.decorationItems = setBackgroundItem(padding: Section.backgroundPadding)
        
//        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
//        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: CollectionHeaderView.reuseID, alignment: .bottom)
//        section.boundarySupplementaryItems = [headerItem]

        return section
    }
    
    private func layoutSectionWithSub(padding: CGFloat = 8) -> NSCollectionLayoutSection {
        
        let layoutMainItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 2), heightDimension: .fractionalHeight(1))
        let layoutMainItem = NSCollectionLayoutItem(layoutSize: layoutMainItemSize)
        layoutMainItem.contentInsets = setContentInsets(padding: padding)

        let layoutSubItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 3), heightDimension: .fractionalHeight(1))
        let layoutSubItem = NSCollectionLayoutItem(layoutSize: layoutSubItemSize)
        layoutSubItem.contentInsets = setContentInsets(padding: padding)

        let layoutSubGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1 / 3))
        let layoutSubGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSubGroupSize, subitem: layoutSubItem, count: 3)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 2), heightDimension: .fractionalHeight(1))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitem: layoutSubGroup, count: 3)
        
        let layoutMainGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(Section.resolution))
        let layoutMainGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutMainGroupSize, subitems: [layoutGroup, layoutMainItem])

        let section = NSCollectionLayoutSection(group: layoutMainGroup)
        section.contentInsets = setContentInsets(padding: Section.backgroundPadding + padding)
        section.decorationItems = setBackgroundItem(padding: Section.backgroundPadding)
        
        return section
    }
    
    private func setContentInsets(padding: CGFloat) -> NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
    }
    
    private func setBackgroundItem(padding: CGFloat) -> [NSCollectionLayoutDecorationItem] {
        let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundSupplementaryView.reuseID)
        backgroundItem.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        
        return [backgroundItem]
    }
    
//    private func layout_1x1() ->  NSCollectionLayoutSection {
//        let padding: CGFloat = 8
//        let sectionMultiplier: CGFloat = 4
//        let backgroundMultiplier: CGFloat = 4
//
//        let layoutItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutItemSize)
//        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
//
//        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(3/4))
//        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitem: layoutItem, count: 1)
//
//        let section = NSCollectionLayoutSection(group: layoutGroup)
//        section.contentInsets = NSDirectionalEdgeInsets(top: padding * sectionMultiplier, leading: padding * sectionMultiplier, bottom: padding * sectionMultiplier, trailing: padding * sectionMultiplier)
//
//        let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundSupplementaryView.reuseID)
//        backgroundItem.contentInsets = NSDirectionalEdgeInsets(top: padding * backgroundMultiplier, leading: padding * backgroundMultiplier, bottom: padding * backgroundMultiplier, trailing: padding * backgroundMultiplier)
//
//        section.decorationItems = [backgroundItem]
////        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(
////            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(8)),
////            elementKind: UICollectionView.elementKindSectionFooter,
////            alignment: .bottom)]
//
//        return section
//    }
//
//    private func layout_2x1() ->  NSCollectionLayoutSection {
//        let padding: CGFloat = 8
//        let sectionMultiplier: CGFloat = 4
//        let backgroundMultiplier: CGFloat = 4
//
//        let layoutItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutItemSize)
//        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
//
//        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(3/4))
//        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitem: layoutItem, count: 2)
//
//        let section = NSCollectionLayoutSection(group: layoutGroup)
//        section.contentInsets = NSDirectionalEdgeInsets(top: padding * sectionMultiplier, leading: padding * sectionMultiplier, bottom: padding * sectionMultiplier, trailing: padding * sectionMultiplier)
//
//        let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundSupplementaryView.reuseID)
//        backgroundItem.contentInsets = NSDirectionalEdgeInsets(top: padding * backgroundMultiplier, leading: padding * backgroundMultiplier, bottom: padding * backgroundMultiplier, trailing: padding * backgroundMultiplier)
//
//        section.decorationItems = [backgroundItem]
//
//        return section
//    }
//
//    private func layout_6x3() ->  NSCollectionLayoutSection {
//        let padding: CGFloat = 8
//        let sectionMultiplier: CGFloat = 8
//        let backgroundMultiplier: CGFloat = 4
//
//        let layoutItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutItemSize)
//        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
//
//        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/4))
//        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitem: layoutItem, count: 6)
//
//        let section = NSCollectionLayoutSection(group: layoutGroup)
//        section.contentInsets = NSDirectionalEdgeInsets(top: padding * sectionMultiplier, leading: padding * sectionMultiplier, bottom: padding * sectionMultiplier, trailing: padding * sectionMultiplier)
//
//        let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundSupplementaryView.reuseID)
//        backgroundItem.contentInsets = NSDirectionalEdgeInsets(top: padding * backgroundMultiplier, leading: padding * backgroundMultiplier, bottom: padding * backgroundMultiplier, trailing: padding * backgroundMultiplier)
//
//        section.decorationItems = [backgroundItem]
////        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(
////            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(8)),
////            elementKind: UICollectionView.elementKindSectionFooter,
////            alignment: .bottom)]
//
//
//        return section
//    }
//
//
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


// MARK: - Product List Controller Delegate {

extension WorkbookController: ProductListControllerDelegate {
    func didSelectItem(item: CollectionModel) {
        guard let selectedIndexPath = selectedIndexPath else { return }
        
        allSections[selectedIndexPath.section].data[selectedIndexPath.row] = item
        
        collectionView.reloadData()
    }
}
