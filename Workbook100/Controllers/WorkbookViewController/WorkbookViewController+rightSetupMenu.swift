//
//  WorkbookViewController+rightSetupMenu.swift
//  Workbook100
//
//  Created by Eddie Char on 3/26/22.
//

import UIKit
import Firebase

extension  WorkbookViewController {
    func setupRightMenu() {
        let menuItems: [UIAction] = [
            
            
            // MARK: - Insert Blank
            UIAction(title: "Insert Blank", image: nil, handler: { action in
                guard let cell = self.collectionView.visibleCells.first, let indexPath = self.collectionView.indexPath(for: cell) else { return }

                self.collectionView.performBatchUpdates({
                    K.ProductFilter.isFiltered ? K.filteredItems.insert(CollectionModel.getBlankModel(), at: indexPath.row) : K.items.insert(CollectionModel.getBlankModel(), at: indexPath.row)
                    
                    self.collectionView.insertItems(at: [IndexPath(item: indexPath.row, section: 0)])
                }, completion: nil)
            }),
            
                    
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
                                        "CountryCode"]]
                
                for item in (K.ProductFilter.isFiltered ? K.filteredItems : K.items) {
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
                                item.countryCode])
                }
                
                self.mailOrder(for: CSVMake.commaSeparatedValueDataForLines(csv))
            }),
            
            
            // MARK: - PDF
            UIAction(title: "PDF", image: UIImage(named: "printer"), handler: { action in
                let pdfFilePath = self.collectionView.exportAsPDFFromCollectionView()
                print("PDF saved to: \(pdfFilePath.pdfFilePath)")
                
                if let pdfData = pdfFilePath.pdfData {
                    self.present(UIActivityViewController(activityItems: [pdfData], applicationActivities: []), animated: true, completion: nil)
                }
            }),
            
            
            // MARK: - Save List
            UIAction(title: "Save List", image: nil, handler: { action in
                guard K.ProductFilter.selectedProductCategory != [K.ProductFilter.wildcard] else {
                    let alert = UIAlertController(title: "Error", message: "Please select a Product Category in the filters before proceeding", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    
                    return
                }
                
                let alert = UIAlertController(title: "Save", message: "Enter a name for your list", preferredStyle: .alert)
                alert.addTextField()
                alert.textFields![0].autocapitalizationType = .words
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
                    let textString = alert!.textFields![0].text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    guard textString.count > 0 else { return }
                    
                    
                    let savingLabel = UILabel()
                    savingLabel.text = "Saving List...\n\nThis may take a while"
                    savingLabel.textAlignment = .center
                    savingLabel.textColor = .white
                    savingLabel.numberOfLines = 0
                    savingLabel.font = UIFont.workbookNoimg
                    savingLabel.backgroundColor = .black
                    savingLabel.alpha = 1.0
                    savingLabel.layer.cornerRadius = 8
                    savingLabel.clipsToBounds = true
                    savingLabel.translatesAutoresizingMaskIntoConstraints = false
                    self.view.addSubview(savingLabel)
                    NSLayoutConstraint.activate([savingLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                                 savingLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                                                 savingLabel.widthAnchor.constraint(equalToConstant: 200),
                                                 savingLabel.heightAnchor.constraint(equalToConstant: 100)])
                    let spinner = ActivitySpinner()
                    spinner.startSpinner(in: self.view)

                    //The bulk of the code needs to happen here!
                    for (index, item) in (K.ProductFilter.isFiltered ? K.filteredItems : K.items).enumerated() {
                        if item.savedLists != nil {
                            item.savedLists!.append(textString)
                        }
                        else {
                            item.savedLists = [textString]
                        }
                        
                        K.updateFirebaseRecord(item: [K.FIR.savedLists: item.savedLists],
                                               databaseReference: Database.database().reference().child(item.hashNeedThis)) {
                            if index >= (K.ProductFilter.isFiltered ? K.filteredItems : K.items).count - 1 {
                                UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseInOut, animations: {
                                    savingLabel.text = "List Saved!"
                                    savingLabel.alpha = 0
                                    spinner.stopSpinner()
                                }, completion: { _ in
                                    savingLabel.removeFromSuperview()
                                })
                            }
                        }//end K.updateFirebaseRecord()
                        
                    }//end for(index, item)
                }))//end alert.addAction...[OK]
                
                self.present(alert, animated: true)
            }),
            
            
            // MARK: - Load List
            UIAction(title: "Load List", image: nil, handler: { action in
                let alert = UIAlertController(title: "Load", message: nil, preferredStyle: .alert)
                
                for list in K.savedLists {
                    alert.addAction(UIAlertAction(title: list, style: .default, handler: nil))
                }
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            })
            
        ]
        
        rightMenu.menu = UIMenu(title: "Settings", image: nil, options: .displayInline, children: menuItems)
    }
}
