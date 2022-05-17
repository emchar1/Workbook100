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
                          UIPopoverPresentationControllerDelegate {
    
    // MARK: - Properties
    
    var collectionView: UICollectionView!
    var imagePicker: ImagePicker!
    var workbookSections: [Section]!
    var selectedIndexPath: IndexPath?
    
//    var refreshControl = UIRefreshControl()
    //can't delete this for now because it's used in drag/drop
    var dataColors: [[UIColor]] = [[.red, .orange, .systemPink, .yellow, .green, .cyan, .systemIndigo, .purple, .magenta],
                                   [.yellow, .green, .cyan],
                                   [.cyan, .blue, .purple],
                                   [.purple, .magenta, .systemPink]]

    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        imagePicker = ImagePicker(presentationController: self, delegate: self)

        initializeCollectionView()
        initializeSections()
    }
    
    private func initializeCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeLayout())

        collectionView.backgroundColor = UIColor(white: 0.1, alpha: 1.0)

        //Did this in lieu of viewDidLayoutSubviews() because this seems more elegant...
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = false

        //Register the various Collection View cells
        collectionView.collectionViewLayout.register(BackgroundSupplementaryView.self, forDecorationViewOfKind: BackgroundSupplementaryView.reuseID)
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.reuseID)
        collectionView.register(CollectionCellPage.self, forCellWithReuseIdentifier: CollectionCellPage.reuseID)
        collectionView.register(CollectionCellBlank.self, forCellWithReuseIdentifier: CollectionCellBlank.reuseID)
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: CollectionHeaderView.reuseID)
        
        //Finally, add the collectionView to the subview
        view.addSubview(collectionView)
    }
        
    private func initializeSections() {
        let section0 = Section(id: 0, type: .size_1x1)
        let section1 = Section(id: 1, type: .size_2x1)
        let section2 = Section(id: 2, type: .size_6x3)
        let section3 = Section(id: 3, type: .size_2x1)
        
        workbookSections = [section0, section1, section2, section3]
    }
    
//    //This is replaced by collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
            if let highestSection = (self.workbookSections.max { first, second in first.id < second.id }) {
                self.didAddSection(id: highestSection.id, type: .size_1x1)
            }
        }))
                                  
        alertController.addAction(UIAlertAction(title: "Two by One", style: .default, handler: { _ in
            if let highestSection = (self.workbookSections.max { first, second in first.id < second.id }) {
                self.didAddSection(id: highestSection.id, type: .size_2x1)
            }
        }))

        alertController.addAction(UIAlertAction(title: "Six by Three", style: .default, handler: { _ in
            if let highestSection = (self.workbookSections.max { first, second in first.id < second.id }) {
                self.didAddSection(id: highestSection.id, type: .size_6x3)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "(Three by Three) by Two", style: .default, handler: { _ in
            if let highestSection = (self.workbookSections.max { first, second in first.id < second.id }) {
                self.didAddSection(id: highestSection.id, type: .size_3x3x2)
            }
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func didAddSection(id: Int, type: SectionType) {
        self.workbookSections.append(Section(id: id + 1, type: type))
        self.collectionView.reloadData()
        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: self.workbookSections.count - 1), at: .top, animated: true)
    }
}


// MARK: - Collection View

extension WorkbookController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return workbookSections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workbookSections[section].data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        print("selectedIndexPath: \(selectedIndexPath!)")
        
        let comparisonValue = workbookSections[indexPath.section].data[indexPath.row]
        
        if comparisonValue is CollectionModel {
            performSegue(withIdentifier: "showDetailsTVC2", sender: nil)
        }
        else if let comparisonValue = comparisonValue as? SectionCellType {
            if comparisonValue == .photo {
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
        let comparisonValue = workbookSections[indexPath.section].data[indexPath.row]
        
        if let comparisonValue = comparisonValue as? SectionCellType {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellBlank.reuseID, for: indexPath) as? CollectionCellBlank else { return UICollectionViewCell() }
            
            switch comparisonValue {
            case .photo: cell.contentView.backgroundColor = .magenta
            case .text: cell.contentView.backgroundColor = .systemPink
            case .item: cell.contentView.backgroundColor = .orange
            }
            
            return cell
        }

        if let comparisonValue = comparisonValue as? CollectionModel {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reuseID, for: indexPath) as? CollectionCell else { return UICollectionViewCell() }

            cell.model = comparisonValue
            cell.setViews()

            return cell
        }
                
        if let comparisonValue = comparisonValue as? UIImage {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellBlank.reuseID, for: indexPath) as? CollectionCellBlank else { return UICollectionViewCell() }
            
            let imageView = UIImageView()
            imageView.image = comparisonValue
            imageView.contentMode = .scaleAspectFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(imageView)
            
            NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                                         imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                                         cell.contentView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
                                         cell.contentView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)])
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
    
    
// MARK: - Collection View Compositional Layout
    
extension WorkbookController {
    private func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (section: Int,
                                                            environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            switch self.workbookSections[section].type {
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
                                                     heightDimension: .fractionalWidth(Section.aspectRatio / CGFloat(heightCount)))
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
        
        let layoutMainGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(Section.aspectRatio))
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


extension WorkbookController: ProductListControllerDelegate, ImagePickerDelegate {
    // MARK: - Product List Controller Delegate

    func didSelect(item: CollectionModel) {
        guard let selectedIndexPath = selectedIndexPath else { return }
        
        workbookSections[selectedIndexPath.section].data[selectedIndexPath.row] = item
        collectionView.reloadData()
    }

    
    // MARK: - Image Picker Delegate

    func didSelect(image: UIImage?) {
        guard let image = image, let selectedIndexPath = selectedIndexPath else { return }
        
        workbookSections[selectedIndexPath.section].data[selectedIndexPath.row] = image
        collectionView.reloadData()
    }
}
