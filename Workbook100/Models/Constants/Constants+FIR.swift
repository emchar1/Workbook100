//
//  Constants+FIR.swift
//  Workbook100
//
//  Created by Eddie Char on 3/28/22.
//

import Firebase

extension K {
    struct FIR {
        
        // IMPORTANT: - When adding to this list, MUST add to the updateFirebaseRecord() function down below!!!
        static let hashNeedThis = "HashNeedThis"
        static let division = "Division"
        static let collection = "Collection"
        static let productNameDescription = "ProductNameDescription"
        static let productNameDescriptionSecondary = "ProductNameDescriptionSecondary"
        static let productCategory = "ProductCategory"
        static let productDepartment = "ProductDepartment"
        static let launchSeason = "LaunchSeason"
        static let seasonsCarried = "SeasonsCarried"
        static let productType = "ProductType"
        static let productSubtype = "ProductSubtype"
        static let productDetails = "ProductDetails"
        static let productClass = "ProductClass"
        static let colorway = "Colorway"
        static let carryOver = "CarryOver"
        static let essential = "Essential"
        static let skuCode = "SKUCode"
        static let colorwaySKU0 = "ColorwaySKU0"
        static let colorwaySKU1 = "ColorwaySKU1"
        static let colorwaySKU2 = "ColorwaySKU2"
        static let colorwaySKU3 = "ColorwaySKU3"
        static let colorwaySKU4 = "ColorwaySKU4"
        static let colorwaySKU5 = "ColorwaySKU5"
        static let colorwaySKU6 = "ColorwaySKU6"
        static let colorwaySKU7 = "ColorwaySKU7"
        static let size0 = "Size0"
        static let size1 = "Size1"
        static let size2 = "Size2"
        static let size3 = "Size3"
        static let size4 = "Size4"
        static let size5 = "Size5"
        static let size6 = "Size6"
        static let size7 = "Size7"
        static let usRetailMSRP = "USRetailMSRP"
        static let euRetailMSRP = "EURetailMSRP"
        static let countryCode = "CountryCode"
        static let composition = "Composition"
        static let productDescription = "ProductDescription"
        static let productFeatures = "ProductFeatures"
        static let lineList = "LineList"
        static let primaryImageURL = "primaryImageURL"
        static let thumbURL = "thumbURL"
        static let imageURL0 = "imageURL0"
        static let imageURL1 = "imageURL1"
        static let imageURL2 = "imageURL2"
        static let imageURL3 = "imageURL3"
        static let imageURL4 = "imageURL4"
        static let imageURL5 = "imageURL5"
        static let imageURL6 = "imageURL6"
        static let imageURL7 = "imageURL7"
        static let imageURL8 = "imageURL8"
        static let imageURL9 = "imageURL9"
        static let imageURL10 = "imageURL10"
        static let savedLists = "savedLists"
    }
    
    //Update lists in tandem!!!
    static func updateFirebaseRecord(item: Any?, databaseReference: DatabaseReference!, completion: (() -> ())?) {
        if let model = item as? CollectionModel {
            let itemRef: [String: Any?] = [K.FIR.hashNeedThis: model.hashNeedThis,
                                           K.FIR.division: model.division,
                                           K.FIR.collection: model.collection,
                                           K.FIR.productNameDescription: model.productNameDescription,
                                           K.FIR.productNameDescriptionSecondary: model.productNameDescriptionSecondary,
                                           K.FIR.productCategory: model.productCategory,
                                           K.FIR.productDepartment: model.productDepartment,
                                           K.FIR.launchSeason: model.launchSeason,
                                           K.FIR.seasonsCarried: model.seasonsCarried,
                                           K.FIR.productType: model.productType,
                                           K.FIR.productSubtype: model.productSubtype,
                                           K.FIR.productDetails: model.productDetails,
                                           K.FIR.productClass: model.productClass,
                                           K.FIR.colorway: model.colorway,
                                           K.FIR.carryOver: model.carryOver ? "TRUE" : "FALSE",
                                           K.FIR.essential: model.essential ? "TRUE" : "FALSE",
                                           K.FIR.skuCode: model.skuCode,
                                           K.FIR.colorwaySKU0: model.sizes[0].colorwaySKU ?? "",
                                           K.FIR.colorwaySKU1: model.sizes[1].colorwaySKU ?? "",
                                           K.FIR.colorwaySKU2: model.sizes[2].colorwaySKU ?? "",
                                           K.FIR.colorwaySKU3: model.sizes[3].colorwaySKU ?? "",
                                           K.FIR.colorwaySKU4: model.sizes[4].colorwaySKU ?? "",
                                           K.FIR.colorwaySKU5: model.sizes[5].colorwaySKU ?? "",
                                           K.FIR.colorwaySKU6: model.sizes[6].colorwaySKU ?? "",
                                           K.FIR.colorwaySKU6: model.sizes[7].colorwaySKU ?? "",
                                           K.FIR.size0: model.sizes[0].size ?? "",
                                           K.FIR.size1: model.sizes[1].size ?? "",
                                           K.FIR.size2: model.sizes[2].size ?? "",
                                           K.FIR.size3: model.sizes[3].size ?? "",
                                           K.FIR.size4: model.sizes[4].size ?? "",
                                           K.FIR.size5: model.sizes[5].size ?? "",
                                           K.FIR.size6: model.sizes[6].size ?? "",
                                           K.FIR.size6: model.sizes[7].size ?? "",
                                           K.FIR.usRetailMSRP: model.usMSRP,
                                           K.FIR.euRetailMSRP: model.euMSRP,
                                           K.FIR.countryCode: model.countryCode,
                                           K.FIR.composition: model.composition,
                                           K.FIR.productDescription: model.productDescription,
                                           K.FIR.productFeatures: model.productFeatures,
                                           K.FIR.lineList: model.lineList,
                                           K.FIR.primaryImageURL: model.primaryImageURL,
                                           K.FIR.thumbURL: model.thumbURL,
                                           K.FIR.imageURL0: model.imageURLs[0],
                                           K.FIR.imageURL1: model.imageURLs[1],
                                           K.FIR.imageURL2: model.imageURLs[2],
                                           K.FIR.imageURL3: model.imageURLs[3],
                                           K.FIR.imageURL4: model.imageURLs[4],
                                           K.FIR.imageURL5: model.imageURLs[5],
                                           K.FIR.imageURL6: model.imageURLs[6],
                                           K.FIR.imageURL7: model.imageURLs[7],
                                           K.FIR.imageURL8: model.imageURLs[8],
                                           K.FIR.imageURL9: model.imageURLs[9],
                                           K.FIR.imageURL10: model.imageURLs[10],
                                           K.FIR.savedLists: model.savedLists
            ]

            //Save entire model
            databaseReference.setValue(itemRef) { error, dbRef in
                completion?()
            }
        }
        else {
            //Save only select items in the model
            databaseReference.updateChildValues(item as! [AnyHashable : Any]) { error, dbRef in
                completion?()
            }
        }
    }//end func updateFirebaseRecord()
    
    
    
    
    static func initializeRecords(completion: (() -> ())?) {
        //Firebase DB
        let ref = Database.database().reference()
        ref.observe(DataEventType.value) { [self] (snapshot) in
            K.items.removeAll()
            
            for itemSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                if let obj = itemSnapshot.value as? [String: AnyObject] {
                    let item = CollectionModel(hashNeedThis: obj[K.FIR.hashNeedThis] as! String,
                                               division: obj[K.FIR.division] as! String,
                                               collection: obj[K.FIR.collection] as! String,
                                               productNameDescription: obj[K.FIR.productNameDescription] as! String,
                                               productNameDescriptionSecondary: obj[K.FIR.productNameDescriptionSecondary] as! String,
                                               productCategory: obj[K.FIR.productCategory] as! String,
                                               productDepartment: obj[K.FIR.productDepartment] as! String,
                                               launchSeason: obj[K.FIR.launchSeason] as! String,
                                               seasonsCarried: obj[K.FIR.seasonsCarried] as! String,
                                               productType: obj[K.FIR.productType] as! String,
                                               productSubtype: obj[K.FIR.productSubtype] as! String,
                                               productDetails: obj[K.FIR.productDetails] as! String,
                                               productClass: obj[K.FIR.productClass] as! String,
                                               colorway: obj[K.FIR.colorway] as! String,
                                               carryOver: (obj[K.FIR.carryOver] as! String) == "TRUE",
                                               essential: (obj[K.FIR.essential] as! String) == "TRUE",
                                               skuCode: obj[K.FIR.skuCode] as! String,
                                               sizes: [
                                                CollectionModel.Size(size: obj[K.FIR.size0] as? String, colorwaySKU: obj[K.FIR.colorwaySKU0] as? String),
                                                CollectionModel.Size(size: obj[K.FIR.size1] as? String, colorwaySKU: obj[K.FIR.colorwaySKU1] as? String),
                                                CollectionModel.Size(size: obj[K.FIR.size2] as? String, colorwaySKU: obj[K.FIR.colorwaySKU2] as? String),
                                                CollectionModel.Size(size: obj[K.FIR.size3] as? String, colorwaySKU: obj[K.FIR.colorwaySKU3] as? String),
                                                CollectionModel.Size(size: obj[K.FIR.size4] as? String, colorwaySKU: obj[K.FIR.colorwaySKU4] as? String),
                                                CollectionModel.Size(size: obj[K.FIR.size5] as? String, colorwaySKU: obj[K.FIR.colorwaySKU5] as? String),
                                                CollectionModel.Size(size: obj[K.FIR.size6] as? String, colorwaySKU: obj[K.FIR.colorwaySKU6] as? String),
                                                CollectionModel.Size(size: obj[K.FIR.size7] as? String, colorwaySKU: obj[K.FIR.colorwaySKU7] as? String)
                                               ],
                                               usMSRP: (obj[K.FIR.usRetailMSRP] as! NSNumber).doubleValue,
                                               euMSRP: (obj[K.FIR.euRetailMSRP] as! NSNumber).doubleValue,
                                               countryCode: obj[K.FIR.countryCode] as! String,
                                               composition: obj[K.FIR.composition] as! String,
                                               productDescription: obj[K.FIR.productDescription] as! String,
                                               productFeatures: obj[K.FIR.productFeatures] as! String,
                                               lineList: obj[K.FIR.lineList] as! String,
                                               primaryImageURL: obj[K.FIR.primaryImageURL] as! String,
                                               thumbURL: obj[K.FIR.thumbURL] as! String,
                                               imageURLs: [obj[K.FIR.imageURL0] as! String,
                                                           obj[K.FIR.imageURL1] as! String,
                                                           obj[K.FIR.imageURL2] as! String,
                                                           obj[K.FIR.imageURL3] as! String,
                                                           obj[K.FIR.imageURL4] as! String,
                                                           obj[K.FIR.imageURL5] as! String,
                                                           obj[K.FIR.imageURL6] as! String,
                                                           obj[K.FIR.imageURL7] as! String,
                                                           obj[K.FIR.imageURL8] as! String,
                                                           obj[K.FIR.imageURL9] as! String,
                                                           obj[K.FIR.imageURL10] as! String],
                                               image: nil,
                                               savedLists: obj[K.FIR.savedLists] as? [String])
                    
                    //Populate items
                    K.items.append(item)

                    K.populateProductFilterSelections(item: item)
                }//end if let obj = itemSnapshot.value
            }//end for itemSnapshot in snapshot.children
            
            //Re-order everything according to Ludo 3/16/22
            K.items = K.items
//                .sorted(by: { $0.productNameDescription < $1.productNameDescription })
//                .sorted(by: { $0.productType < $1.productType })
                //add more sorted(by:) the last sorted(by:) has the highest sort priority

            K.sortProductFilterSelections()

            completion?()

            //Discardable result, otherwise get Warning that self is unused
            let _ = self
        }//end ref.observe
    }//end func initializeRecords()
    
    
    /**
     Initializes the selections options for each filter item.
     */
    private static func populateProductFilterSelections(item: CollectionModel) {
        //Line List
        for lineListItem in item.lineList.components(separatedBy: ",") {
            let trimmed = lineListItem.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if !K.ProductFilter.selectionLineList.contains(trimmed) && trimmed != "" && trimmed != "removed" {
                K.ProductFilter.selectionLineList.append(trimmed)
            }
        }
        
        //Collection
        if !K.ProductFilter.selectionCollection.contains(item.collection) && item.collection != "" {
            K.ProductFilter.selectionCollection.append(item.collection)
        }
        
        //Division
        if !K.ProductFilter.selectionDivision.contains(item.division) && item.division != "" {
            K.ProductFilter.selectionDivision.append(item.division)
        }
        
        //Product Category
        if !K.ProductFilter.selectionProductCategory.contains(item.productCategory) && item.productCategory != "" {
            K.ProductFilter.selectionProductCategory.append(item.productCategory)
        }
        
        //Product Type
        if !K.ProductFilter.selectionProductType.contains(item.productType) && item.productType != "" {
            K.ProductFilter.selectionProductType.append(item.productType)
        }
        
        //Product Subtype
        if !K.ProductFilter.selectionProductSubtype.contains(item.productSubtype) && item.productSubtype != "" {
            K.ProductFilter.selectionProductSubtype.append(item.productSubtype)
        }
        
        //Product Class
        if !K.ProductFilter.selectionProductClass.contains(item.productClass) && item.productClass != "" {
            K.ProductFilter.selectionProductClass.append(item.productClass)
        }
        
        //Product Details
        if !K.ProductFilter.selectionProductDetails.contains(item.productDetails) && item.productDetails != "" {
            K.ProductFilter.selectionProductDetails.append(item.productDetails)
        }
        
    }
    
    
    private static func sortProductFilterSelections() {
        //Saved Lists
        K.ProductFilter.selectionLineList = K.ProductFilter.selectionLineList.sorted(by: { $0 < $1 })

        //Collection
        K.ProductFilter.selectionCollection = K.ProductFilter.selectionCollection.sorted(by: { $0 < $1 })
        
        //Division
        K.ProductFilter.selectionDivision = K.ProductFilter.selectionDivision.sorted(by: { $0 < $1 })
        
        //Product Category
        K.ProductFilter.selectionProductCategory = K.ProductFilter.selectionProductCategory.sorted(by: { $0 < $1 })
        
        //Product Type
        K.ProductFilter.selectionProductType = K.ProductFilter.selectionProductType.sorted(by: { $0 < $1 })
        
        //Product Subtype
        K.ProductFilter.selectionProductSubtype = K.ProductFilter.selectionProductSubtype.sorted(by: { $0 < $1 })
        
        //Product Class
        K.ProductFilter.selectionProductClass = K.ProductFilter.selectionProductClass.sorted(by: { $0 < $1 })
        
        //Product Details
        K.ProductFilter.selectionProductDetails = K.ProductFilter.selectionProductDetails.sorted(by: { $0 < $1 })
    }
    
}
