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
                              ProductFilterControllerNEWDelegate {
    
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
        return collectionView
    }()
        
//    lazy var floatingSectionLabel: UILabel = {
//        let label = UILabel(frame: CGRect(x: 8, y: 0, width: view.bounds.width, height: 60))
//        label.textColor = .black
//        label.font = UIFont(name: "Avenir Next Condensed Demi Bold Italic", size: 32)
//        return label
//    }()
//
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
        if segue.identifier == "showDetailsTVC2" {
            let nc = segue.destination as! UINavigationController
            let controller = nc.topViewController as! WorkbookDetailTVC2

            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                controller.model = K.getFilteredItemsIfFiltered[indexPath.row]
            }
        }
    }
}

       
// MARK: - Data Source, Delegate, Flow Layout

extension WorkbookViewController {
    
    //Data Source
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch (K.getFilteredItemsIfFiltered[indexPath.row].productCategory) {
        case K.ProductFilter.wildcard:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellBlank.reuseId, for: indexPath) as! CollectionCellBlank
            return cell
        default:
            if (K.getFilteredItemsIfFiltered[indexPath.row].productCategory.count) > 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reuseId, for: indexPath) as! CollectionCell
                cell.model = K.getFilteredItemsIfFiltered[indexPath.row]
                cell.setViews()
                return cell
            }

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellBlank.reuseId, for: indexPath) as! CollectionCellBlank
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return K.getFilteredItemsIfFiltered.count
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


    // MARK: - Section Headers
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        guard section > 0 else {
//            return .zero
//        }
//
//        return CGSize(width: view.frame.size.width, height: 40)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        guard section > 0 else {
//            return .zero
//        }
//
//        return CGSize(width: view.frame.size.width, height: 40)
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        navigationItem.titleView?.alpha = (scrollView.contentOffset.y - titleSize.height / 2) / (titleSize.height / 2)
//
//        if let indexPath = collectionView.indexPathForItem(at: CGPoint(x: scrollView.frame.size.width / 2,
//                                                                       y: scrollView.contentOffset.y)) {
//            if indexPath.section > 0 {
//                floatingSectionLabel.text = K.getFilteredItemsIfFiltered[indexPath.section - 1].productNameDescription
//                floatingSectionLabel.backgroundColor = .white
//            }
//            else {
//                floatingSectionLabel.text = ""
//                floatingSectionLabel.backgroundColor = .clear
//            }
//        }
//    }
//    
}


// MARK: - Product Filter Controller NEW Delegate

extension WorkbookViewController {
    func applyTapped(selectedSavedLists: String,
                     selectedNew: Int,
                     selectedEssential: Int,
                     selectedCollection: String,
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
        K.ProductFilter.selectedSavedLists = selectedSavedLists
        K.ProductFilter.selectedNew = selectedNew
        K.ProductFilter.selectedEssential = selectedEssential
        K.ProductFilter.selectedCollection = selectedCollection
        K.ProductFilter.selectedProductCategory = selectedProductCategory
        K.ProductFilter.selectedProductType = selectedProductType
        K.ProductFilter.selectedProductSubtype = selectedProductSubtype
        K.ProductFilter.selectedDivision = selectedDivision
        K.ProductFilter.selectedProductClass = selectedProductClass
        K.ProductFilter.selectedProductDetails = selectedProductDetails

        K.filteredItems = K.items.filter {
            (selectedSavedLists == K.ProductFilter.wildcard ? true : ($0.savedLists ?? []).joined(separator: s).wrap(in: s).contains(selectedSavedLists.wrap(in: s))) &&
            
            (selectedNew == K.ProductFilter.segementedBoth ? true : $0.carryOver == (selectedNew == K.ProductFilter.segementedOff)) &&
            
            (selectedEssential == K.ProductFilter.segementedBoth ? true : $0.essential == (selectedEssential == K.ProductFilter.segementedOn)) &&
            
            (selectedCollection == K.ProductFilter.wildcard ? true : $0.collection == selectedCollection) &&
            
            (selectedProductCategory.joined().contains(K.ProductFilter.wildcard) ? true : selectedProductCategory.joined(separator: s).wrap(in: s).contains($0.productCategory.wrap(in: s))) &&
            
            (selectedProductType.joined().contains(K.ProductFilter.wildcard) ? true : selectedProductType.joined(separator: s).wrap(in: s).contains($0.productType.wrap(in: s))) &&
            
            (selectedProductSubtype.joined().contains(K.ProductFilter.wildcard) ? true : selectedProductSubtype.joined(separator: s).wrap(in: s).contains($0.productSubtype.wrap(in: s))) &&
            
            (selectedDivision.joined().contains(K.ProductFilter.wildcard) ? true : selectedDivision.joined(separator: s).wrap(in: s).contains($0.division.wrap(in: s))) &&
            
            (selectedProductClass.joined().contains(K.ProductFilter.wildcard) ? true : selectedProductClass.joined(separator: s).wrap(in: s).contains($0.productClass.wrap(in: s))) &&
            
            (selectedProductDetails.joined().contains(K.ProductFilter.wildcard) ? true : selectedProductDetails.joined(separator: s).wrap(in: s).contains($0.productDetails.wrap(in: s)))
        }
                
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
