//
//  LineListViewController+RightSetupMenu.swift
//  Workbook100
//
//  Created by Eddie Char on 3/26/22.
//

import UIKit
import Firebase

extension  LineListViewController {
    func setupRightMenu() {
        let menuItems: [UIAction] = [
            
            
            // MARK: - Insert Blank
//            UIAction(title: "Insert Blank", image: nil, handler: { action in
//                guard let cell = self.collectionView.visibleCells.first, let indexPath = self.collectionView.indexPath(for: cell) else { return }
//
//                self.collectionView.performBatchUpdates({
//                    if K.ProductFilter.isFiltered {
//                        K.filteredItems.insert(CollectionModel.getBlankModel(), at: indexPath.row)
//                    }
//                    else {
//                        K.items.insert(CollectionModel.getBlankModel(), at: indexPath.row)
//                    }
//
//                    self.collectionView.insertItems(at: [IndexPath(item: indexPath.row, section: 0)])
//                }, completion: nil)
//            }),
            
                    
            // MARK: - Export
            UIAction(title: "Export", image: nil, handler: { action in
                var csv: [[String]] = [["SKUCode",
                                        "productNameDescription",
                                        "productCategory",
                                        "productDepartment",
                                        "launchSeason",
                                        "productType",
                                        "productSubtype",
                                        "Colorway",
                                        "CarryOver",
                                        "Essential",
                                        "USRetailMSRP",
                                        "EURetailMSRP",
                                        "CountryCode",
                                        "QOH",
                                        "Status",
                                        "ROS"]]
                
                for item in K.getFilteredItemsIfFiltered {
                    guard !item.isRemoved else { continue }
                    
                    var qoh = 0
                    var status = 0
                    var ros = 0
                    
                    for size in item.sizes {
                        qoh += size.qoh ?? 0
                        status += size.status ?? 0
                        ros += 0
                    }
                    
                    csv.append([item.skuCode,
                                item.productNameDescription,
                                item.productCategory,
                                item.productDepartment,
                                item.launchSeason,
                                item.productType,
                                item.productSubtype,
                                item.colorway,
                                item.carryOver ? "TRUE" : "FALSE",
                                item.essential ? "TRUE" : "FALSE",
                                "\(item.usMSRP)",
                                "\(item.euMSRP)",
                                item.countryCode,
                                "\(qoh)",
                                "\(status)",
                                "\(ros)"])
                }
                
                self.mailOrder(for: CSVMake.commaSeparatedValueDataForLines(csv))
            }),
            
            
            // MARK: - PDF
//            UIAction(title: "PDF", image: UIImage(named: "printer"), handler: { action in
//                let pdfFilePath = self.collectionView.exportAsPDFFromCollectionView()
//                print("PDF saved to: \(pdfFilePath.pdfFilePath)")
//                
//                if let pdfData = pdfFilePath.pdfData {
//                    self.present(UIActivityViewController(activityItems: [pdfData], applicationActivities: []), animated: true, completion: nil)
//                }
//            }),
            
            
            // MARK: - Save List
            UIAction(title: "Save List", image: nil, handler: { action in
                var savedItems = [Any]()
                
                let alert = UIAlertController(title: "Save List", message: "Enter a name for your list:", preferredStyle: .alert)
                alert.addTextField()
                alert.textFields![0].autocapitalizationType = .words
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
                    let textString = alert!.textFields![0].text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    guard textString.count > 0 else { return }
                    
                    self.showHUD(label: "Saving List...")

                    for (_, item) in K.getFilteredItemsIfFiltered.enumerated() {
//                        savedItems.append(HashNeedThis(hash: item.hashNeedThis, isExcluded: item.isRemoved))
                        savedItems.append([LineListNaming.hash: item.hashNeedThis, LineListNaming.isExcluded: item.isRemoved])
                    }
                    
                    if let alert = alert, let textFields = alert.textFields, let text = textFields[0].text {
                        self.docRef = Firestore.firestore().collection(FIRManager.FIRLineLists.lineLists).document(text)
                        self.docData["hashNeedThis"] = savedItems
                        self.docRef.setData(self.docData)
                    }
                }))//end alert.addAction...[OK]
                                
                self.present(alert, animated: true)
            }),
            
            
            // MARK: - Load List
            UIAction(title: "Load List", image: nil, handler: { action in
                let alert = UIAlertController(title: "Load List", message: "Select a list to load", preferredStyle: .alert)
                
                for lineList in self.lineLists {
                    alert.addAction(UIAlertAction(title: lineList, style: .default, handler: { action in
                        self.getItems(lineList: lineList)
                        self.showHUD(label: "Loading List...")
                    }))
                }
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                self.present(alert, animated: true)
            }),
            
            
            // MARK: - Check All
            UIAction(title: "Check All", image: UIImage(systemName: "xmark.square"), attributes: .destructive, handler: { action in
                let _ = K.getFilteredItemsIfFiltered.map({ $0.isRemoved = true })
                
                self.collectionView.reloadData()
            }),
            
            
            // MARK: - Uncheck All
            UIAction(title: "Uncheck All", image: UIImage(systemName: "square"), attributes: .destructive, handler: { action in
                let _ = K.getFilteredItemsIfFiltered.map({ $0.isRemoved = false })
                
                self.collectionView.reloadData()
            })

        ]
        
        rightMenu.menu = UIMenu(title: "Settings", image: nil, options: .displayInline, children: menuItems)
    }
    
    
    // MARK: - Helper Functions
    
    private func showHUD(label: String) {
        let hudLabel = UILabel()
        hudLabel.text = label
        hudLabel.textAlignment = .center
        hudLabel.textColor = .white
        hudLabel.numberOfLines = 0
        hudLabel.font = UIFont.workbookNoimg
        hudLabel.backgroundColor = .black
        hudLabel.alpha = 1.0
        hudLabel.layer.cornerRadius = 8
        hudLabel.clipsToBounds = true
        hudLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(hudLabel)
        NSLayoutConstraint.activate([hudLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                     hudLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                                     hudLabel.widthAnchor.constraint(equalToConstant: 200),
                                     hudLabel.heightAnchor.constraint(equalToConstant: 100)])
        
        let spinner = ActivitySpinner()
        spinner.startSpinner(in: self.view)
        
        UIView.animate(withDuration: 0.5, delay: 2.0, options: [], animations: {
            hudLabel.alpha = 0
            
        }, completion: { _ in
            spinner.stopSpinner()
            hudLabel.removeFromSuperview()
        })
    }
    
    private func getItems(lineList: String) {
        docRef = collectionRef.document(lineList)
        
        docRef.getDocument { snapshot, error in
            guard error == nil else { return print("Error getting snapshot: \(error!)") }
            
            do {
                let lineListFIR: LineListFIR = try snapshot!.data(as: LineListFIR.self)
                
                K.filteredItems = []
                                
                for hashNeedThis in lineListFIR.hashNeedThis {
                    let itemCheck = K.items.filter({ $0.hashNeedThis == hashNeedThis.hash })[0]
                    itemCheck.isRemoved = hashNeedThis.isExcluded
                    
                    K.filteredItems.append(itemCheck)
                }
                
                self.collectionView.reloadData()
            }
            catch {
                print(error)
            }
        }
    }
}
