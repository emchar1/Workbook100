//
//  FIRManager.swift
//  Workbook100
//
//  Created by Eddie Char on 3/28/22.
//

import Firebase

struct FIRManager {
//    static var initializationRequested = false
//    static var initializationComplete = false {
//        didSet {
//            print("Initialization Complete")
//        }
//    }
    
    struct FIRWorkbooks {
        static let collection = "Workbooks"
        
    }

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
        static let qoh0 = "QOH0"
        static let qoh1 = "QOH1"
        static let qoh2 = "QOH2"
        static let qoh3 = "QOH3"
        static let qoh4 = "QOH4"
        static let qoh5 = "QOH5"
        static let qoh6 = "QOH6"
        static let qoh7 = "QOH7"
        static let status0 = "Status0"
        static let status1 = "Status1"
        static let status2 = "Status2"
        static let status3 = "Status3"
        static let status4 = "Status4"
        static let status5 = "Status5"
        static let status6 = "Status6"
        static let status7 = "Status7"
        static let usRetailMSRP = "USRetailMSRP"
        static let euRetailMSRP = "EURetailMSRP"
        static let countryCode = "CountryCode"
        static let composition = "Composition"
        static let productDescription = "ProductDescription"
        static let productFeatures = "ProductFeatures"
        static let lineListOrder = "LineListOrder"
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
        static let isRemoved = "isRemoved"
    }
    
    //Update lists in tandem!!!
    static func updateFirebaseRecord(item: Any?, databaseReference: DatabaseReference!, completion: (() -> ())?) {
        if let model = item as? CollectionModel {
            let itemRef: [String: Any?] = [FIRManager.FIR.hashNeedThis: model.hashNeedThis,
                                           FIRManager.FIR.division: model.division,
                                           FIRManager.FIR.collection: model.collection,
                                           FIRManager.FIR.productNameDescription: model.productNameDescription,
                                           FIRManager.FIR.productNameDescriptionSecondary: model.productNameDescriptionSecondary,
                                           FIRManager.FIR.productCategory: model.productCategory,
                                           FIRManager.FIR.productDepartment: model.productDepartment,
                                           FIRManager.FIR.launchSeason: model.launchSeason,
                                           FIRManager.FIR.seasonsCarried: model.seasonsCarried,
                                           FIRManager.FIR.productType: model.productType,
                                           FIRManager.FIR.productSubtype: model.productSubtype,
                                           FIRManager.FIR.productDetails: model.productDetails,
                                           FIRManager.FIR.productClass: model.productClass,
                                           FIRManager.FIR.colorway: model.colorway,
                                           FIRManager.FIR.carryOver: model.carryOver ? "TRUE" : "FALSE",
                                           FIRManager.FIR.essential: model.essential ? "TRUE" : "FALSE",
                                           FIRManager.FIR.skuCode: model.skuCode,
                                           FIRManager.FIR.colorwaySKU0: model.sizes[0].colorwaySKU ?? "",
                                           FIRManager.FIR.colorwaySKU1: model.sizes[1].colorwaySKU ?? "",
                                           FIRManager.FIR.colorwaySKU2: model.sizes[2].colorwaySKU ?? "",
                                           FIRManager.FIR.colorwaySKU3: model.sizes[3].colorwaySKU ?? "",
                                           FIRManager.FIR.colorwaySKU4: model.sizes[4].colorwaySKU ?? "",
                                           FIRManager.FIR.colorwaySKU5: model.sizes[5].colorwaySKU ?? "",
                                           FIRManager.FIR.colorwaySKU6: model.sizes[6].colorwaySKU ?? "",
                                           FIRManager.FIR.colorwaySKU6: model.sizes[7].colorwaySKU ?? "",
                                           FIRManager.FIR.size0: model.sizes[0].size ?? "",
                                           FIRManager.FIR.size1: model.sizes[1].size ?? "",
                                           FIRManager.FIR.size2: model.sizes[2].size ?? "",
                                           FIRManager.FIR.size3: model.sizes[3].size ?? "",
                                           FIRManager.FIR.size4: model.sizes[4].size ?? "",
                                           FIRManager.FIR.size5: model.sizes[5].size ?? "",
                                           FIRManager.FIR.size6: model.sizes[6].size ?? "",
                                           FIRManager.FIR.size7: model.sizes[7].size ?? "",
                                           FIRManager.FIR.qoh0: model.sizes[0].qoh ?? "",
                                           FIRManager.FIR.qoh1: model.sizes[1].qoh ?? "",
                                           FIRManager.FIR.qoh2: model.sizes[2].qoh ?? "",
                                           FIRManager.FIR.qoh3: model.sizes[3].qoh ?? "",
                                           FIRManager.FIR.qoh4: model.sizes[4].qoh ?? "",
                                           FIRManager.FIR.qoh5: model.sizes[5].qoh ?? "",
                                           FIRManager.FIR.qoh6: model.sizes[6].qoh ?? "",
                                           FIRManager.FIR.qoh7: model.sizes[7].qoh ?? "",
                                           FIRManager.FIR.status0: model.sizes[0].status ?? "",
                                           FIRManager.FIR.status1: model.sizes[1].status ?? "",
                                           FIRManager.FIR.status2: model.sizes[2].status ?? "",
                                           FIRManager.FIR.status3: model.sizes[3].status ?? "",
                                           FIRManager.FIR.status4: model.sizes[4].status ?? "",
                                           FIRManager.FIR.status5: model.sizes[5].status ?? "",
                                           FIRManager.FIR.status6: model.sizes[6].status ?? "",
                                           FIRManager.FIR.status7: model.sizes[7].status ?? "",
                                           FIRManager.FIR.usRetailMSRP: model.usMSRP,
                                           FIRManager.FIR.euRetailMSRP: model.euMSRP,
                                           FIRManager.FIR.countryCode: model.countryCode,
                                           FIRManager.FIR.composition: model.composition,
                                           FIRManager.FIR.productDescription: model.productDescription,
                                           FIRManager.FIR.productFeatures: model.productFeatures,
                                           FIRManager.FIR.lineListOrder: model.lineListOrder,
                                           FIRManager.FIR.lineList: model.lineList,
                                           FIRManager.FIR.primaryImageURL: model.primaryImageURL,
                                           FIRManager.FIR.thumbURL: model.thumbURL,
                                           FIRManager.FIR.imageURL0: model.imageURLs[0],
                                           FIRManager.FIR.imageURL1: model.imageURLs[1],
                                           FIRManager.FIR.imageURL2: model.imageURLs[2],
                                           FIRManager.FIR.imageURL3: model.imageURLs[3],
                                           FIRManager.FIR.imageURL4: model.imageURLs[4],
                                           FIRManager.FIR.imageURL5: model.imageURLs[5],
                                           FIRManager.FIR.imageURL6: model.imageURLs[6],
                                           FIRManager.FIR.imageURL7: model.imageURLs[7],
                                           FIRManager.FIR.imageURL8: model.imageURLs[8],
                                           FIRManager.FIR.imageURL9: model.imageURLs[9],
                                           FIRManager.FIR.imageURL10: model.imageURLs[10],
                                           FIRManager.FIR.savedLists: model.savedLists,
                                           FIRManager.FIR.isRemoved: model.isRemoved ? "TRUE" : "FALSE"]

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
    
    
    
    // FIXME: - Should K.items be populated in a completion handler, and not in the ref.observe()???
    static func initializeRecords(completion: (([CollectionModel]) -> ())?) {
//        guard !initializationRequested else {
//            completion?([])
//            print("Item Array initialization has already been requested!")
//            return
//        }
        
        var filteredItemsFirstInitialized = K.filteredItems.isEmpty
        var allItems: [CollectionModel] = []
        
        //Firebase DB
        let ref = Database.database().reference()
        ref.observe(DataEventType.value) { snapshot in
//            initializationRequested = true
            print("👀👀👀...FIRManager.initializeRecords...Observing...👀👀👀")
            K.items.removeAll()
            
            for itemSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                if let obj = itemSnapshot.value as? [String: AnyObject] {
                    let item = CollectionModel(hashNeedThis: obj[FIRManager.FIR.hashNeedThis] as! String,
                                               division: obj[FIRManager.FIR.division] as! String,
                                               collection: obj[FIRManager.FIR.collection] as! String,
                                               productNameDescription: obj[FIRManager.FIR.productNameDescription] as! String,
                                               productNameDescriptionSecondary: obj[FIRManager.FIR.productNameDescriptionSecondary] as! String,
                                               productCategory: obj[FIRManager.FIR.productCategory] as! String,
                                               productDepartment: obj[FIRManager.FIR.productDepartment] as! String,
                                               launchSeason: obj[FIRManager.FIR.launchSeason] as! String,
                                               seasonsCarried: obj[FIRManager.FIR.seasonsCarried] as! String,
                                               productType: obj[FIRManager.FIR.productType] as! String,
                                               productSubtype: obj[FIRManager.FIR.productSubtype] as! String,
                                               productDetails: obj[FIRManager.FIR.productDetails] as! String,
                                               productClass: obj[FIRManager.FIR.productClass] as! String,
                                               colorway: obj[FIRManager.FIR.colorway] as! String,
                                               carryOver: (obj[FIRManager.FIR.carryOver] as! String) == "TRUE",
                                               essential: (obj[FIRManager.FIR.essential] as! String) == "TRUE",
                                               skuCode: obj[FIRManager.FIR.skuCode] as! String,
                                               sizes: [
                                                CollectionModel.Size(size: obj[FIRManager.FIR.size0] as? String,
                                                                     colorwaySKU: obj[FIRManager.FIR.colorwaySKU0] as? String,
                                                                     qoh: obj[FIRManager.FIR.qoh0] as? Int,
                                                                     status: obj[FIRManager.FIR.status0] as? Int),
                                                CollectionModel.Size(size: obj[FIRManager.FIR.size1] as? String,
                                                                     colorwaySKU: obj[FIRManager.FIR.colorwaySKU1] as? String,
                                                                     qoh: obj[FIRManager.FIR.qoh1] as? Int,
                                                                     status: obj[FIRManager.FIR.status1] as? Int),
                                                CollectionModel.Size(size: obj[FIRManager.FIR.size2] as? String,
                                                                     colorwaySKU: obj[FIRManager.FIR.colorwaySKU2] as? String,
                                                                     qoh: obj[FIRManager.FIR.qoh2] as? Int,
                                                                     status: obj[FIRManager.FIR.status2] as? Int),
                                                CollectionModel.Size(size: obj[FIRManager.FIR.size3] as? String,
                                                                     colorwaySKU: obj[FIRManager.FIR.colorwaySKU3] as? String,
                                                                     qoh: obj[FIRManager.FIR.qoh3] as? Int,
                                                                     status: obj[FIRManager.FIR.status3] as? Int),
                                                CollectionModel.Size(size: obj[FIRManager.FIR.size4] as? String,
                                                                     colorwaySKU: obj[FIRManager.FIR.colorwaySKU4] as? String,
                                                                     qoh: obj[FIRManager.FIR.qoh4] as? Int,
                                                                     status: obj[FIRManager.FIR.status4] as? Int),
                                                CollectionModel.Size(size: obj[FIRManager.FIR.size5] as? String,
                                                                     colorwaySKU: obj[FIRManager.FIR.colorwaySKU5] as? String,
                                                                     qoh: obj[FIRManager.FIR.qoh5] as? Int,
                                                                     status: obj[FIRManager.FIR.status5] as? Int),
                                                CollectionModel.Size(size: obj[FIRManager.FIR.size6] as? String,
                                                                     colorwaySKU: obj[FIRManager.FIR.colorwaySKU6] as? String,
                                                                     qoh: obj[FIRManager.FIR.qoh6] as? Int,
                                                                     status: obj[FIRManager.FIR.status6] as? Int),
                                                CollectionModel.Size(size: obj[FIRManager.FIR.size7] as? String,
                                                                     colorwaySKU: obj[FIRManager.FIR.colorwaySKU7] as? String,
                                                                     qoh: obj[FIRManager.FIR.qoh7] as? Int,
                                                                     status: obj[FIRManager.FIR.status7] as? Int)
                                               ],
                                               usMSRP: (obj[FIRManager.FIR.usRetailMSRP] as! NSNumber).doubleValue,
                                               euMSRP: (obj[FIRManager.FIR.euRetailMSRP] as! NSNumber).doubleValue,
                                               countryCode: obj[FIRManager.FIR.countryCode] as! String,
                                               composition: obj[FIRManager.FIR.composition] as! String,
                                               productDescription: obj[FIRManager.FIR.productDescription] as! String,
                                               productFeatures: obj[FIRManager.FIR.productFeatures] as! String,
                                               lineListOrder: (obj[FIRManager.FIR.lineListOrder] as! NSNumber).intValue,
                                               lineList: obj[FIRManager.FIR.lineList] as! String,
                                               primaryImageURL: obj[FIRManager.FIR.primaryImageURL] as! String,
                                               thumbURL: obj[FIRManager.FIR.thumbURL] as! String,
                                               imageURLs: [obj[FIRManager.FIR.imageURL0] as! String,
                                                           obj[FIRManager.FIR.imageURL1] as! String,
                                                           obj[FIRManager.FIR.imageURL2] as! String,
                                                           obj[FIRManager.FIR.imageURL3] as! String,
                                                           obj[FIRManager.FIR.imageURL4] as! String,
                                                           obj[FIRManager.FIR.imageURL5] as! String,
                                                           obj[FIRManager.FIR.imageURL6] as! String,
                                                           obj[FIRManager.FIR.imageURL7] as! String,
                                                           obj[FIRManager.FIR.imageURL8] as! String,
                                                           obj[FIRManager.FIR.imageURL9] as! String,
                                                           obj[FIRManager.FIR.imageURL10] as! String],
                                               image: nil,
                                               savedLists: obj[FIRManager.FIR.savedLists] as? [String],
                                               isRemoved: (obj[FIRManager.FIR.isRemoved] as? String ?? "FALSE") == "TRUE")
                    
                    //Populate items
                    K.items.append(item)
                    allItems.append(item)
                    
                    //Also populate the filtered list, which it will be for the initial load, using lineListDefault.
                    if filteredItemsFirstInitialized && item.lineList == K.ProductFilter.lineListDefault {
                        K.filteredItems.append(item)
                    }

                    FIRManager.populateProductFilterSelections(item: item)
                }//end if let obj = itemSnapshot.value
            }//end for itemSnapshot in snapshot.children
            
            filteredItemsFirstInitialized = false
//            initializationRequested = true
            
            //Re-order everything according to Ludo 3/16/22
//            K.items = K.items
//                .sorted(by: { $0.productCategory < $1.productCategory })
//                .sorted(by: { $0.productType < $1.productType })
                //add more sorted(by:) the last sorted(by:) has the highest sort priority

            FIRManager.sortProductFilterSelections()

//            initializationComplete = true
            
            //This returns the allItems in the completion. Do what you want with it, or don't use it, it's up to you.
            completion?(allItems)
        }//end ref.observe
    }//end func initializeRecords()
    
    
    /**
     Initializes the selections options for each filter item.
     */
    private static func populateProductFilterSelections(item: CollectionModel) {
        //Line List
        if !K.ProductFilter.selectionLineList.contains(item.lineList) && item.lineList != "" {
            K.ProductFilter.selectionLineList.append(item.lineList)
        }
        
        //Collection
        if !K.ProductFilter.selectionCollection.contains(item.collection) && item.collection != "" {
            K.ProductFilter.selectionCollection.append(item.collection)
        }
        
        //Division
        for singleDivision in item.division.components(separatedBy: ", ") {
            if !K.ProductFilter.selectionDivision.contains(singleDivision) && singleDivision != "" {
                K.ProductFilter.selectionDivision.append(singleDivision)
            }
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
//        if !K.ProductFilter.selectionProductDetails.contains(item.productDetails) && item.productDetails != "" {
//            K.ProductFilter.selectionProductDetails.append(item.productDetails)
//        }
        
        //Seasons Carried
        for singleSeasonsCarried in item.seasonsCarried.components(separatedBy: ", ") {
            if !K.ProductFilter.selectionSeasonsCarried.contains(singleSeasonsCarried) && singleSeasonsCarried != "" {
                K.ProductFilter.selectionSeasonsCarried.append(singleSeasonsCarried)
            }
        }
    }
    
    
    private static func sortProductFilterSelections() {
        //Saved Lists
        K.ProductFilter.selectionLineList.sort()
        K.ProductFilter.selectionLineList = K.ProductFilter.selectionLineList.filter{ $0 != K.ProductFilter.wildcard }

        //Collection
        K.ProductFilter.selectionCollection.sort()
        
        //Division
        K.ProductFilter.selectionDivision.sort()
        
        //Product Category
        K.ProductFilter.selectionProductCategory.sort()
        
        //Product Type
        K.ProductFilter.selectionProductType.sort()
        
        //Product Subtype
        K.ProductFilter.selectionProductSubtype.sort()
        
        //Product Class
        K.ProductFilter.selectionProductClass.sort()
        
//        //Product Details
//        K.ProductFilter.selectionProductDetails.sort()
        
        //Seasons Carried... does the same thing as .sort() but I'm just being extra
        K.ProductFilter.selectionSeasonsCarried.sort()
    }
    
}
