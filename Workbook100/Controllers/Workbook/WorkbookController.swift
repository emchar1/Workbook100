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
    var imagePicker: ImagePicker!
    
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
        
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        
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
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showProductList", sender: nil)
    }
    
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
    
    private func didAddSection(id: Int, type: SectionType, data: Array<Any>) {
        self.allSections.append(Section(id: id + 1, type: type, data: data))
        self.collectionView.reloadData()
        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: self.allSections.count - 1), at: .top, animated: true)
    }
}


// MARK: - Collection View

extension WorkbookController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return allSections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allSections[section].data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        
        let comparisonValue = allSections[indexPath.section].data[indexPath.row]
        
        if comparisonValue is CollectionModel {
            performSegue(withIdentifier: "showDetailsTVC2", sender: nil)
        }
        else if let comparisonValue = comparisonValue as? Int {
            if comparisonValue == 0 {
                imagePicker.present(from: collectionView)
            }
            else {
                let vc = ProductListController()
                vc.delegate = self
                present(vc, animated: true)
            }
        }

        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let comparisonValue = allSections[indexPath.section].data[indexPath.row]
        
        if let comparisonValue = comparisonValue as? CollectionModel {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reuseID, for: indexPath) as? CollectionCell else { return UICollectionViewCell() }

            cell.model = comparisonValue
            cell.setViews()

            return cell
        }
        else if let comparisonValue = comparisonValue as? Int {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellBlank.reuseID, for: indexPath) as? CollectionCellBlank else { return UICollectionViewCell() }
            
            switch comparisonValue {
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
}


// MARK: - Product List Controller Delegate

extension WorkbookController: ProductListControllerDelegate {
    func didSelectItem(item: CollectionModel) {
        guard let selectedIndexPath = selectedIndexPath else { return }
        
        allSections[selectedIndexPath.section].data[selectedIndexPath.row] = item
        
        collectionView.reloadData()
    }
}


// MARK: - Image Picker Delegate

extension WorkbookController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        print("Did select an image!")
        
        
    }
}
