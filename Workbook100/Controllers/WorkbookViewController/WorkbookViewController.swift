//
//  WorkbookViewController.swift
//  Workbook100
//
//  Created by Eddie Char on 12/14/21.
//

import UIKit
import MessageUI

protocol WorkbookViewControllerDelegate {
    func expandPanel()
    func collapsePanel()
}


// MARK: - Workbook View Controller MAIN CLASS

class WorkbookViewController: UIViewController,
                              UICollectionViewDelegate,
                              UICollectionViewDataSource,
                              UICollectionViewDelegateFlowLayout,
                              UICollectionViewDragDelegate,
                              UICollectionViewDropDelegate,
                              UIPopoverPresentationControllerDelegate,
                              MFMailComposeViewControllerDelegate,
                              ProductFilterControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var rightMenu: UIBarButtonItem!
    @IBOutlet weak var cancelMultiButton: UIBarButtonItem!
    
    var delegate: WorkbookViewControllerDelegate?
    var spinner = ActivitySpinner(style: .large)
    
    var noResultsLabel: UILabel = {
        let label = UILabel()
        label.font = .workbookTitle
        label.text = "No Results to Display"
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    var multiSelect = false {
        didSet {
            if multiSelect {
                collectionView.allowsMultipleSelection = true
                cancelMultiButton.isEnabled = true
                cancelMultiButton.tintColor = nil
            }
            else {
                collectionView.allowsMultipleSelection = false
                cancelMultiButton.isEnabled = false
                cancelMultiButton.tintColor = .clear
            }
        }
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: K.CollectionCell.padding, left: K.CollectionCell.padding, bottom: K.CollectionCell.padding, right: K.CollectionCell.padding)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CollectionCellBlank.self, forCellWithReuseIdentifier: CollectionCellBlank.reuseId)
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.reuseId)
        collectionView.register(GloveCell.self, forCellWithReuseIdentifier: GloveCell.reuseId)
        collectionView.register(CollectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CollectionHeaderView.reuseIdentifier)
        return collectionView
    }()
        
//    lazy var floatingSectionLabel: UILabel = {
//        let label = UILabel(frame: CGRect(x: 8, y: 0, width: view.bounds.width, height: 60))
//        label.font = UIFont(name: "AvenirNextCondensed-DemiBoldItalic", size: 32)
//        return label
//    }()

//    lazy var titleSize: (width: CGFloat, height: CGFloat) = {
//        let insetPadding: CGFloat = 8
//        let width = view.frame.width - 2 * insetPadding
//        let heightRatio: CGFloat = 0.85246
//        return (width, width * heightRatio)
//    }()

    @IBAction func productFilterTapped(_ sender: Any) {
        delegate?.expandPanel()
    }
    
    @IBAction func cancelMultiTapped(_ sender: Any) {
        multiSelect = false
        
        //If toggling back to single selection, remove all selections. Need to make it loop through ALL cells - visible and not visible
        for i in self.collectionView.indexPathsForVisibleItems {
            self.collectionView.deselectItem(at: i, animated: false)
        }
    }
    
    
    // MARK: - Initialization
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dragInteractionEnabled = true
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                                     collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
                                     view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)])
        
        view.addSubview(noResultsLabel)
        NSLayoutConstraint.activate([noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)])

        spinner.startSpinner(in: view)

        //Firebase DB
        K.initializeRecords {
            self.collectionView.reloadData()
            self.setupRightMenu()
            self.spinner.stopSpinner()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning called!")
    }
    
    
    // MARK: - Orientation Transition
        
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard !K.ProductFilter.selectionProductCategory.isEmpty else { return }
        
        if segue.identifier == "showDetailsTVC2" {
            let nc = segue.destination as! UINavigationController
            let controller = nc.topViewController as! WorkbookDetailTVC2

            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                let itemForProductCategory = K.getFilteredItemsIfFiltered.filter {
                    $0.productCategory == K.ProductFilter.selectionProductCategory[indexPath.section]
                }

                controller.model = itemForProductCategory[indexPath.row]
                
                //Uncomment this for flat CollectionView (no product category headers)
//                controller.model = K.getFilteredItemsIfFiltered[indexPath.row]
            }
        }
    }
}

       
// MARK: - Data Source, Delegate, Flow Layout

extension WorkbookViewController {
    
    //Data Source
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard !K.ProductFilter.selectionProductCategory.isEmpty else { return UICollectionViewCell() }

        let itemForCategory = K.getFilteredItemsIfFiltered.filter {
            $0.productCategory == K.ProductFilter.selectionProductCategory[indexPath.section]
        }

        switch (itemForCategory[indexPath.row].productCategory) {
        //Uncomment this for flat CollectionView (no product category headers)
//        switch (K.getFilteredItemsIfFiltered[indexPath.row].productCategory) {
        case K.ProductFilter.wildcard:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellBlank.reuseId, for: indexPath) as! CollectionCellBlank
            return cell
        default:
            if (itemForCategory[indexPath.row].productCategory.count) > 0 {
            //Uncomment this for flat CollectionView (no product category headers)
//            if (K.getFilteredItemsIfFiltered[indexPath.row].productCategory.count) > 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reuseId, for: indexPath) as! CollectionCell
                cell.model = itemForCategory[indexPath.row]

                //Uncomment this for flat CollectionView (no product category headers)
//                cell.model = K.getFilteredItemsIfFiltered[indexPath.row]

                cell.setViews()
                
                // FIXME: - Test alpha for isRemoved
                if cell.model.isRemoved {
                    cell.alpha = 0.2
                }
                else {
                    cell.alpha = 1.0
                }
                
                return cell
            }

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellBlank.reuseId, for: indexPath) as! CollectionCellBlank
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard !K.ProductFilter.selectionProductCategory.isEmpty else { return 0 }
        
        let itemForCategory = K.getFilteredItemsIfFiltered.filter {
            $0.productCategory == K.ProductFilter.selectionProductCategory[section]
        }

        return itemForCategory.count
        
        //Uncomment this for flat CollectionView (no product category headers)
//        return K.getFilteredItemsIfFiltered.count
    }
    
    
    //Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !multiSelect {
            performSegue(withIdentifier: "showDetailsTVC2", sender: nil)
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    

    //Delegate Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let multiplier: CGFloat = 1
        
        return CGSize(width: K.CollectionCell.adjustedWidth(in: collectionView) * multiplier,
                      height: K.CollectionCell.adjustedHeight(in: collectionView))
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard !K.ProductFilter.selectionProductCategory.isEmpty else { return UICollectionReusableView() }

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                         withReuseIdentifier: CollectionHeaderView.reuseIdentifier,
                                                                         for: indexPath) as! CollectionHeaderView
            header.label.text = K.ProductFilter.selectionProductCategory[indexPath.section]
            header.configure()
            return header
        default:
            return UICollectionReusableView()
        }
    }


    // MARK: - Section Headers

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return K.ProductFilter.selectionProductCategory.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let itemForCategory = K.getFilteredItemsIfFiltered.filter {
            $0.productCategory == K.ProductFilter.selectionProductCategory[section]
        }

        if itemForCategory.isEmpty {
            return .zero
        }
        else {
            return CGSize(width: view.frame.size.width, height: 80)
        }

        //Uncomment this for flat CollectionView (no product category headers)
//        guard section > 0 else {
//            return .zero
//        }
//
//        return CGSize(width: view.frame.size.width, height: 40)
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        navigationItem.titleView?.alpha = (scrollView.contentOffset.y - titleSize.height / 2) / (titleSize.height / 2)
//
//        if let indexPath = collectionView.indexPathForItem(at: CGPoint(x: scrollView.frame.size.width / 2,
//                                                                       y: scrollView.contentOffset.y)) {
//            if indexPath.section > 0 {
//                let itemForCategory = K.getFilteredItemsIfFiltered.filter {
//                    $0.productCategory == K.ProductFilter.selectionProductCategory[indexPath.section]
//                }
//                floatingSectionLabel.text = itemForCategory[indexPath.section].productCategory
////                floatingSectionLabel.text = K.getFilteredItemsIfFiltered[indexPath.section].productNameDescription
//                floatingSectionLabel.backgroundColor = .white
//            }
//            else {
//                floatingSectionLabel.text = ""
//                floatingSectionLabel.backgroundColor = .clear
//            }
//        }
//    }
    
}


// MARK: - Product Filter Controller NEW Delegate

extension WorkbookViewController {
    func applyTapped(selectedLineList: String,
                     selectedNew: Int,
                     selectedEssential: Int,
                     selectedCollection: String,
                     selectedSeasonsCarried: [String],
                     selectedProductCategory: [String],
                     selectedProductType: [String],
                     selectedProductSubtype: [String],
                     selectedDivision: [String],
                     selectedProductClass: [String],
                     selectedProductDetails: [String]) {
                
        guard K.items.count > 0 else {
            print("Items still loading. Exiting early.")
            delegate?.collapsePanel()
            return
        }
        

        let s = K.ProductFilter.multiSeparator
        
        //Set the global constant variables, i.e. make the changes "permanent."
        K.ProductFilter.selectedLineList = selectedLineList
        K.ProductFilter.selectedNew = selectedNew
        K.ProductFilter.selectedEssential = selectedEssential
        K.ProductFilter.selectedCollection = selectedCollection
        K.ProductFilter.selectedSeasonsCarried = selectedSeasonsCarried
        K.ProductFilter.selectedProductCategory = selectedProductCategory
        K.ProductFilter.selectedProductType = selectedProductType
        K.ProductFilter.selectedProductSubtype = selectedProductSubtype
        K.ProductFilter.selectedDivision = selectedDivision
        K.ProductFilter.selectedProductClass = selectedProductClass
        K.ProductFilter.selectedProductDetails = selectedProductDetails
        
        //Populate K.filteredItems, using for-in loop, not the elegant array.filter...
        K.filteredItems = []
        
        for item in K.items {
            if item.lineList == selectedLineList &&
                
                (selectedNew == K.ProductFilter.segementedBoth || item.carryOver == (selectedNew == K.ProductFilter.segementedOff)) &&
                
                (selectedEssential == K.ProductFilter.segementedBoth || item.essential == (selectedEssential == K.ProductFilter.segementedOn)) &&
                
                (selectedCollection == K.ProductFilter.wildcard || item.collection == selectedCollection) &&
                
                (selectedProductCategory.jContains(K.ProductFilter.wildcard) || selectedProductCategory.joinAndWrap(in: s).contains(item.productCategory.wrap(in: s))) &&
                
                (selectedProductType.jContains(K.ProductFilter.wildcard) || selectedProductType.joinAndWrap(in: s).contains(item.productType.wrap(in: s))) &&
                
                (selectedProductSubtype.jContains(K.ProductFilter.wildcard) || selectedProductSubtype.joinAndWrap(in: s).contains(item.productSubtype.wrap(in: s))) &&
                
                (selectedProductClass.jContains(K.ProductFilter.wildcard) || selectedProductClass.joinAndWrap(in: s).contains(item.productClass.wrap(in: s))) &&
            
                
                (selectedSeasonsCarried.jContains(K.ProductFilter.wildcard) || selectedSeasonsCarried.joinAndWrap(in: s).containsElementInArray(item.seasonsCarried.components(separatedBy: K.ProductFilter.jsonSeparator))) &&
                
                (selectedDivision.jContains(K.ProductFilter.wildcard) || selectedDivision.joinAndWrap(in: s).containsElementInArray(item.division.components(separatedBy: K.ProductFilter.jsonSeparator))) {
                
                K.filteredItems.append(item)
            } //end if
        } //end for
        
                
        //Show a "No results found" label if the filtered list is empty
        if K.ProductFilter.isFiltered {
            noResultsLabel.isHidden = !K.filteredItems.isEmpty
        }
        else {
            noResultsLabel.isHidden = true
        }
        
        collectionView.reloadData()
        delegate?.collapsePanel()
    }
}
