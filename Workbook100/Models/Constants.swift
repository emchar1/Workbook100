//
//  Constants.swift
//  Workbook100
//
//  Created by Eddie Char on 12/23/21.
//

import UIKit
import Firebase

struct K {
    static var items: [CollectionModel] = []
    static var filteredItems: [CollectionModel] = []
    static var savedLists: [String] = []
    
    struct CollectionCell {
        static var cellMultiplier: CGFloat = (UIScreen.main.traitCollection.horizontalSizeClass == .compact) ? 3 : 6
        static let padding: CGFloat = 8
        static let cornerRadius: CGFloat = 8
        static let width: CGFloat = 200
        static var height: CGFloat { width * 3 / 2 }

        static func adjustedWidth(in view: UIView) -> CGFloat {
            return view.bounds.width / cellMultiplier - (2 * padding)
            
        }        

        static func adjustedHeight(in view: UIView) -> CGFloat {
            return adjustedWidth(in: view) * 3 / 2
        }
    }
    
    struct ProductFilter {
        static let wildcard = "[All]"
        static let segementedBoth = 0
        static let segementedOn = 1
        static let segementedOff = 2
        static let multiSeparator = "|"
        
        static var selectionLoadList: [String] {
            [wildcard] + K.savedLists
        }
        static let selectionCollection: [String] = [wildcard, "2023 - Spring"]
        static let selectionDivision: [String] = [wildcard, "Bike", "Moto", "Bike, Moto"]
//        static let selectionLaunchSeason: [String] = [wildcard, "Essential", "FA17", "SP18", "FA18", "SP19", "FA19", "SP20", "FA20", "SP21", "FA21", "SP22", "FA22"]
        static let selectionSeasonsCarried: [String] = [wildcard, "FA18", "SP19", "FA19", "SP20", "FA20", "SP21", "FA21", "SP22", "FA22", "SP23"]
        static let selectionProductCategory: [String] = [wildcard, "Accessories", "Apparel", "Brad Binder", "Gear", "Gloves", "Goggle Accessories", "Goggles", "Helmet Parts and Accessories", "Helmets", "Protection", "Snow Goggle Accessories", "Snow Goggles", "Sunglass Parts and Lenses", "Sunglasses"]
        static let selectionProductDepartment: [String] = [wildcard, "Eyewear", "Hard Goods", "Soft Goods"]
        static let selectionProductType: [String] = [wildcard, "Accessories", "Backpack", "Beanie", "Bibs", "Bottoms", "Cap", "Fleece", "Gloves", "Goggle Case", "Goggle System", "Helmet Parts", "Helmet System", "Jackets", "Nose Parts", "Protection", "Replacement Lenses", "Socks", "Sunglass System", "Tear-Offs", "Tees", "Tops", "Umbrella", "Vest"]
        static let selectionProductSubtype: [String] = [wildcard, "Active Performance", "Athletic", "Base Layers", "Camper", "Casual", "Clear", "Dual", "Dual Pane", "Dual Pane Sonic Bumps", "Dual Pane Vented", "Elbow", "Flexfit", "Full Face", "HiPER", "Injected", "Jersey", "Knee", "Laminated", "Liners", "Mirror", "Misc.", "Mud", "Nose Bridges", "Nose Pads", "Open Face", "Pants", "Performance", "Perimeter Seal", "Photochromic", "Premium", "Regular", "Replacement Lenses", "Screws", "Shield", "Short Fingers", "Shorts", "Sleeves", "Snapback", "Sonic Bumps", "Spare Parts", "Sport Performance", "Standard", "Tech", "Trucker", "Unstructured", "Upper", "Varied", "Visors", "Water Resistant", "Waterproof", "Windproof", "Wool"]
        static let selectionProductClass: [String] = [wildcard, "Mens", "Miscellaneous", "Unisex", "Womens", "Youth"]
        static let selectionProductDetails: [String] = [wildcard, "210g/m2", "250g/m2 mini loop French Terry", "280g/2", "280g/m2", "280g/m2 (330g/m2 after wash)", "290g/m2 Interlock", "330g/m2", "Fit ( AJ) Trucker, Flat Visor (230 squared), 5 Panel", "Fit ( J ), Visor 909 Flat (rounded), 6 Panel", "Fit ( LYP), Curved Visor (230 CV-3), 5 Panel", "Fit ( LYP), Flat Visor (230 squared), 5 Panel", "Fit ( LYP), Flat Visor (230 squared), 6 Panel", "Fit ( X ), Visor (Curve 230 CV-3), 5 Panel", "Fit ( X ), Visor (Curve 230 CV-3), 6 Panel", "Fit (AJ) Trucker, Visor (Flat 230 squared), 5 Panel", "Fit (AJ), Flat Visor (230 squared), 6 Panel", "Fit (AJ), Flat Visor 230 (squared), 6 Panel", "Fit (AJ), Visor (Flat), 6 Panel", "Fit (LYP), Flat Visor 230 (squared), 5 Panel", "Fit (LYP), Visor Flat 230 (squared), 5 Panel", "Fit (X) Trucker, Visor (Curve 230 CV-3), 5 Panel", "Fit (X), Visor (Curve 230 CV-3), 5 Panel"]

        static var selectedLoadList: String = wildcard
        static var selectedNew: Int = segementedBoth
        static var selectedEssential: Int = segementedBoth
        static var selectedCollection: String = wildcard
        static var selectedSeasonsCarried: [String] = [wildcard]
        static var selectedProductDepartment: [String] = [wildcard]
        static var selectedProductCategory: [String] = [wildcard]
        static var selectedProductType: [String] = [wildcard]
        static var selectedProductSubtype: [String] = [wildcard]
        static var selectedDivision: [String] = [wildcard]
        static var selectedProductClass: [String] = [wildcard]
        static var selectedProductDetails: [String] = [wildcard]
        
        static var isFiltered: Bool {
            return !(selectedLoadList == wildcard &&
                     selectedNew == segementedBoth &&
                     selectedEssential == segementedBoth &&
                     selectedCollection == wildcard &&
                     selectedSeasonsCarried == [wildcard] &&
                     selectedProductDepartment == [wildcard] &&
                     selectedProductCategory == [wildcard] &&
                     selectedProductType == [wildcard] &&
                     selectedProductSubtype == [wildcard] &&
                     selectedDivision == [wildcard] &&
                     selectedProductClass == [wildcard] &&
                     selectedProductDetails == [wildcard])
        }
        
        
        // MARK: - Binary Tree Filter List
        
        static var categories: Category<String> {
            let collection = Category("2023 - Spring")
            
            //Accessories
            let accessories = Category("Accessories")
            let accessories_accessories = Category("Accessories")
            let accessories_backpack = Category("Backpack")
            let accessories_gogglecase = Category("Goggle Case")
            let accessories_umbrella = Category("Umbrella")
            collection.add(accessories)
            accessories.add(accessories_accessories)
            accessories_accessories.add(Category("Regular"))
            accessories_accessories.search("Regular")!.add(Category("Unisex"))
            accessories.add(accessories_backpack)
            accessories_backpack.add(Category("Regular"))
            accessories_backpack.search("Regular")!.add(Category("Miscellaneous"))
            accessories.add(accessories_gogglecase)
            accessories_gogglecase.add(Category("Regular"))
            accessories_gogglecase.search("Regular")!.add(Category("Miscellaneous"))
            accessories.add(accessories_umbrella)
            accessories_umbrella.add(Category("Premium"))
            accessories_umbrella.search("Premium")!.add(Category("Miscellaneous"))
            accessories_umbrella.add(Category("Regular"))
            accessories_umbrella.search("Regular")!.add(Category("Miscellaneous"))

            //Apparel
            let apparel = Category("Apparel")
            let apparel_beanie = Category("Beanie")
            let apparel_cap = Category("Cap")
            let apparel_fleece = Category("Fleece")
            let apparel_jackets = Category("Jackets")
            let apparel_socks = Category("Socks")
            let apparel_tees = Category("Tees")
            collection.add(apparel)
            apparel.add(apparel_beanie)
            apparel.add(apparel_cap)
            apparel.add(apparel_fleece)
            apparel.add(apparel_jackets)
            apparel.add(apparel_socks)
            apparel.add(apparel_tees)
            apparel_beanie.add(Category("Regular"))
            apparel_beanie.search("Regular")!.add(Category("Unisex"))
            apparel_cap.add(Category("Flexfit"))
            apparel_cap.search("Flexfit")!.add(Category("Unisex"))
            apparel_cap.add(Category("Snapback"))
            apparel_cap.search("Snapback")!.add(Category("Unisex"))
            apparel_cap.search("Snapback")!.add(Category("Youth"))
            apparel_cap.add(Category("Trucker"))
            apparel_cap.search("Trucker")!.add(Category("Unisex"))
            apparel_cap.add(Category("Unstructured"))
            apparel_cap.search("Unstructured")!.add(Category("Unisex"))
            apparel_fleece.add(Category("Regular"))
            apparel_fleece.search("Regular")!.add(Category("Mens"))
            apparel_fleece.search("Regular")!.add(Category("Womens"))
            apparel_fleece.search("Regular")!.add(Category("Youth"))
            apparel_fleece.add(Category("Tech"))
            apparel_fleece.search("Tech")!.add(Category("Mens"))
            apparel_jackets.add(Category("Regular"))
            apparel_jackets.search("Regular")!.add(Category("Mens"))
            apparel_jackets.add(Category("Water Resistant"))
            apparel_jackets.search("Water Resistant")!.add(Category("Mens"))
            apparel_jackets.add(Category("Waterproof"))
            apparel_jackets.search("Waterproof")!.add(Category("Mens"))
            apparel_jackets.add(Category("Windproof"))
            apparel_jackets.search("Windproof")!.add(Category("Mens"))
            apparel_socks.add(Category("Casual"))
            apparel_socks.search("Casual")!.add(Category("Mens"))
            apparel_socks.add(Category("Performance"))
            apparel_socks.search("Performance")!.add(Category("Mens"))
            apparel_socks.search("Performance")!.add(Category("Youth"))
            apparel_socks.add(Category("Wool"))
            apparel_socks.search("Wool")!.add(Category("Mens"))
            apparel_tees.add(Category("Athletic"))
            apparel_tees.search("Athletic")!.add(Category("Mens"))
            apparel_tees.add(Category("Regular"))
            apparel_tees.search("Regular")!.add(Category("Mens"))
            apparel_tees.search("Regular")!.add(Category("Womens"))
            apparel_tees.search("Regular")!.add(Category("Youth"))
            apparel_tees.add(Category("Tech"))
            apparel_tees.search("Tech")!.add(Category("Mens"))
            
            //Gear
            let gear = Category("Gear")
            let gear_accessories = Category("Accessories")
            let gear_bibs = Category("Bibs")
            let gear_bottoms = Category("Bottoms")
            let gear_cap = Category("Cap")
            let gear_jackets = Category("Jackets")
            let gear_tops = Category("Tops")
            let gear_vest = Category("Vest")
            collection.add(gear)
            gear.add(gear_accessories)
            gear_accessories.add(Category("Sleeves"))
            gear_accessories.search("Sleeves")!.add(Category("Unisex"))
            gear.add(gear_bibs)
            gear_bibs.add(Category("Regular"))
            gear_bibs.search("Regular")!.add(Category("Mens"))
            gear_bibs.search("Regular")!.add(Category("Womens"))
            gear_bibs.add(Category("Tech"))
            gear_bibs.search("Tech")!.add(Category("Mens"))
            gear.add(gear_bottoms)
            gear_bottoms.add(Category("Pants"))
            gear_bottoms.search("Pants")!.add(Category("Mens"))
            gear_bottoms.search("Pants")!.add(Category("Womens"))
            gear_bottoms.search("Pants")!.add(Category("Youth"))
            gear_bottoms.add(Category("Shorts"))
            gear_bottoms.search("Shorts")!.add(Category("Mens"))
            gear_bottoms.search("Shorts")!.add(Category("Womens"))
            gear_bottoms.search("Shorts")!.add(Category("Youth"))
            gear.add(gear_cap)
            gear_cap.add(Category("Unrestricted"))
            gear_cap.search("Unrestricted")!.add(Category("Unisex"))
            gear.add(gear_jackets)
            gear_jackets.add(Category("Waterproof"))
            gear_jackets.search("Waterproof")!.add(Category("Mens"))
            gear_jackets.add(Category("Windproof"))
            gear_jackets.search("Windproof")!.add(Category("Mens"))
            gear.add(gear_tops)
            gear_tops.add(Category("Base Layers"))
            gear_tops.search("Base Layers")!.add(Category("Mens"))
            gear_tops.add(Category("Jersey"))
            gear_tops.search("Jersey")!.add(Category("Mens"))
            gear_tops.search("Jersey")!.add(Category("Womens"))
            gear_tops.search("Jersey")!.add(Category("Youth"))
            gear.add(gear_vest)
            gear_vest.add(Category("Windproof"))
            gear_vest.search("Windproof")!.add(Category("Mens"))
            
            //Gloves
            let gloves = Category("Gloves")
            let gloves_gloves = Category("Gloves")
            collection.add(gloves)
            gloves.add(gloves_gloves)
            gloves_gloves.add(Category("Regular"))
            gloves_gloves.search("Regular")!.add(Category("Mens"))
            gloves_gloves.search("Regular")!.add(Category("Womens"))
            gloves_gloves.search("Regular")!.add(Category("Youth"))
            gloves_gloves.add(Category("Short Fingers"))
            gloves_gloves.search("Short Fingers")!.add(Category("Mens"))
            gloves_gloves.search("Short Fingers")!.add(Category("Womens"))
            gloves_gloves.add(Category("Waterproof"))
            gloves_gloves.search("Waterproof")!.add(Category("Mens"))
            
            //Goggle Accessories
            let goggleAccessories = Category("Goggle Accessories")
            let goggleAccessories_accessories = Category("Accessories")
            let goggleAccessories_replacementLenses = Category("Replacement Lenses")
            let goggleAccessories_tearoffs = Category("Tear-Offs")
            collection.add(goggleAccessories)
            goggleAccessories.add(goggleAccessories_accessories)
            goggleAccessories_accessories.add(Category("Spare Parts"))
            goggleAccessories_accessories.search("Spare Parts")!.add(Category("Unisex"))
            goggleAccessories_accessories.search("Spare Parts")!.add(Category("Youth"))
            goggleAccessories.add(goggleAccessories_replacementLenses)
            goggleAccessories_replacementLenses.add(Category("Clear"))
            goggleAccessories_replacementLenses.search("Clear")!.add(Category("Unisex"))
            goggleAccessories_replacementLenses.search("Clear")!.add(Category("Youth"))
            goggleAccessories_replacementLenses.add(Category("Dual Pane"))
            goggleAccessories_replacementLenses.search("Dual Pane")!.add(Category("Unisex"))
            goggleAccessories_replacementLenses.add(Category("Dual Pane Sonic Bumps"))
            goggleAccessories_replacementLenses.search("Dual Pane Sonic Bumps")!.add(Category("Unisex"))
            goggleAccessories_replacementLenses.add(Category("Dual Pane Vented"))
            goggleAccessories_replacementLenses.search("Dual Pane Vented")!.add(Category("Unisex"))
            goggleAccessories_replacementLenses.add(Category("HiPER"))
            goggleAccessories_replacementLenses.search("HiPER")!.add(Category("Unisex"))
            goggleAccessories_replacementLenses.add(Category("Injected"))
            goggleAccessories_replacementLenses.search("Injected")!.add(Category("Unisex"))
            goggleAccessories_replacementLenses.add(Category("Mirror"))
            goggleAccessories_replacementLenses.search("Mirror")!.add(Category("Unisex"))
            goggleAccessories_replacementLenses.search("Mirror")!.add(Category("Youth"))
            goggleAccessories_replacementLenses.add(Category("Photochromic"))
            goggleAccessories_replacementLenses.search("Photochromic")!.add(Category("Unisex"))
            goggleAccessories_replacementLenses.add(Category("Sonic Bumps"))
            goggleAccessories_replacementLenses.search("Sonic Bumps")!.add(Category("Unisex"))
            goggleAccessories_replacementLenses.search("Sonic Bumps")!.add(Category("Youth"))
            goggleAccessories.add(goggleAccessories_tearoffs)
            goggleAccessories_tearoffs.add(Category("Laminated"))
            goggleAccessories_tearoffs.search("Laminated")!.add(Category("Unisex"))
            goggleAccessories_tearoffs.add(Category("Perimeter Seal"))
            goggleAccessories_tearoffs.search("Perimeter Seal")!.add(Category("Unisex"))
            goggleAccessories_tearoffs.add(Category("Standard"))
            goggleAccessories_tearoffs.search("Standard")!.add(Category("Unisex"))
            goggleAccessories_tearoffs.search("Standard")!.add(Category("Youth"))
            
            //Goggles
            let goggles = Category("Goggles")
            let goggles_goggleSystem = Category("Goggle System")
            collection.add(goggles)
            goggles.add(goggles_goggleSystem)
            goggles_goggleSystem.add(Category("Clear"))
            goggles_goggleSystem.search("Clear")!.add(Category("Unisex"))
            goggles_goggleSystem.search("Clear")!.add(Category("Youth"))
            goggles_goggleSystem.add(Category("Mirror"))
            goggles_goggleSystem.search("Mirror")!.add(Category("Unisex"))
            goggles_goggleSystem.search("Mirror")!.add(Category("Youth"))
            goggles_goggleSystem.add(Category("Mud"))
            goggles_goggleSystem.search("Mud")!.add(Category("Unisex"))
            goggles_goggleSystem.search("Mud")!.add(Category("Youth"))
            goggles_goggleSystem.add(Category("Photochromic"))
            goggles_goggleSystem.search("Photochromic")!.add(Category("Unisex"))
            goggles_goggleSystem.add(Category("Varied"))
            goggles_goggleSystem.search("Varied")!.add(Category("Unisex"))
            
            //Helmet Parts and Accessories
            let helmetPartsAndAccessories = Category("Helmet Parts and Accessories")
            let helmetPartsAndAccessories_helmetParts = Category("Helmet Parts")
            collection.add(helmetPartsAndAccessories)
            helmetPartsAndAccessories.add(helmetPartsAndAccessories_helmetParts)
            helmetPartsAndAccessories_helmetParts.add(Category("Liners"))
            helmetPartsAndAccessories_helmetParts.search("Liners")!.add(Category("Unisex"))
            helmetPartsAndAccessories_helmetParts.search("Liners")!.add(Category("Youth"))
            helmetPartsAndAccessories_helmetParts.add(Category("Misc."))
            helmetPartsAndAccessories_helmetParts.search("Misc.")!.add(Category("Unisex"))
            helmetPartsAndAccessories_helmetParts.add(Category("Screws"))
            helmetPartsAndAccessories_helmetParts.search("Screws")!.add(Category("Unisex"))
            helmetPartsAndAccessories_helmetParts.add(Category("Visors"))
            helmetPartsAndAccessories_helmetParts.search("Visors")!.add(Category("Unisex"))
            helmetPartsAndAccessories_helmetParts.search("Visors")!.add(Category("Youth"))

            //Helmets
            let helmets = Category("Helmets")
            let helmets_helmetSystem = Category("Helmet System")
            collection.add(helmets)
            helmets.add(helmets_helmetSystem)
            helmets_helmetSystem.add(Category("Full Face"))
            helmets_helmetSystem.search("Full Face")!.add(Category("Unisex"))
            helmets_helmetSystem.search("Full Face")!.add(Category("Youth"))
            helmets_helmetSystem.add(Category("Open Face"))
            helmets_helmetSystem.search("Open Face")!.add(Category("Unisex"))

            //Protection
            let protection = Category("Protection")
            let protection_protection = Category("Protection")
            collection.add(protection)
            protection.add(protection_protection)
            protection_protection.add(Category("Elbow"))
            protection_protection.search("Elbow")!.add(Category("Unisex"))
            protection_protection.add(Category("Knee"))
            protection_protection.search("Knee")!.add(Category("Unisex"))
            protection_protection.add(Category("Upper"))
            protection_protection.search("Upper")!.add(Category("Mens"))
            
            //Snow Goggle Accessories
            let snowGoggleAccessories = Category("Snow Goggle Accessories")
            let snowGoggleAccessories_replacementLenses = Category("Replacement Lenses")
            collection.add(snowGoggleAccessories)
            snowGoggleAccessories.add(snowGoggleAccessories_replacementLenses)
            snowGoggleAccessories_replacementLenses.add(Category("Mirror"))
            snowGoggleAccessories_replacementLenses.search("Mirror")!.add(Category("Unisex"))

            //Snow Goggles
            let snowGoggles = Category("Snow Goggles")
            let snowGoggles_goggleSystem = Category("Goggle System")
            collection.add(snowGoggles)
            snowGoggles.add(snowGoggles_goggleSystem)
            snowGoggles_goggleSystem.add(Category("Mirror"))
            snowGoggles_goggleSystem.search("Mirror")!.add(Category("Unisex"))
            
            //Sunglass Parts and Lenses
            let sunglassPartsAndLenses = Category("Sunglass Parts and Lenses")
//            let sunglassPartsAndLenses_ = Category("")
            let sunglassPartsAndLenses_noseParts = Category("Nose Parts")
            let sunglassPartsAndLenses_replacementLenses = Category("Replacement Lenses")
            collection.add(sunglassPartsAndLenses)
//            sunglassPartsAndLenses.add(sunglassPartsAndLenses_)
//            sunglassPartsAndLenses_.add(Category(""))
//            sunglassPartsAndLenses_.search("")!.add(Category(""))
//            sunglassPartsAndLenses_.add(Category("Replacement Lenses"))
//            sunglassPartsAndLenses_.search("Replacement Lenses")!.add(Category(""))
            sunglassPartsAndLenses.add(sunglassPartsAndLenses_noseParts)
            sunglassPartsAndLenses_noseParts.add(Category("Nose Bridges"))
//            sunglassPartsAndLenses_noseParts.search("Nose Bridges")!.add(Category(""))
            sunglassPartsAndLenses_noseParts.add(Category("Nose Pads"))
//            sunglassPartsAndLenses_noseParts.search("Nose Pads")!.add(Category(""))
            sunglassPartsAndLenses.add(snowGoggleAccessories_replacementLenses)
            sunglassPartsAndLenses_replacementLenses.add(Category("Dual"))
//            sunglassPartsAndLenses_replacementLenses.search("Dual")!.add(Category(""))
            sunglassPartsAndLenses_replacementLenses.add(Category("Shield"))
//            sunglassPartsAndLenses_replacementLenses.search("Shield")!.add(Category(""))
            
            //Sunglasses
            let sunglasses = Category("Sunglasses")
//            let sunglasses_ = Category("")
            let sunglasses_accessories = Category("Accessories")
            let sunglasses_noseParts = Category("Nose Parts")
            let sunglasses_sunglassSystem = Category("Sunglass System")
            collection.add(sunglasses)
//            sunglasses.add(sunglasses_)
//            sunglasses_.add(Category(""))
//            sunglasses_.search("")!.add(Category(""))
//            sunglasses_.add(Category("Active Performance"))
//            sunglasses_.search("Active Performance")!.add(Category(""))
//            sunglasses_.add(Category("Sport Performance"))
//            sunglasses_.search("Sport Performance")!.add(Category(""))
            sunglasses.add(sunglasses_accessories)
//            sunglasses_accessories.add(Category(""))
//            sunglasses_accessories.search("")!.add(Category(""))
            sunglasses.add(sunglasses_noseParts)
            sunglasses_noseParts.add(Category("Nose Bridges"))
//            sunglasses_noseParts.search("Nose Bridges")!.add(Category(""))
            sunglasses.add(sunglasses_sunglassSystem)
            sunglasses_sunglassSystem.add(Category("Active Performance"))
//            sunglasses_sunglassSystem.search("Active Performance")!.add(Category(""))
            sunglasses_sunglassSystem.add(Category("Sport Performance"))
//            sunglasses_sunglassSystem.search("Sport Performance")!.add(Category(""))

            return collection
        }
        
    }
}
    


// MARK: - Firebase stuff

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
        static let youthWomen = "YouthWomen"
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
        static let size0 = "Size0"
        static let size1 = "Size1"
        static let size2 = "Size2"
        static let size3 = "Size3"
        static let size4 = "Size4"
        static let size5 = "Size5"
        static let size6 = "Size6"
        static let usRetailMSRP = "USRetailMSRP"
        static let euRetailMSRP = "EURetailMSRP"
        static let countryCode = "CountryCode"
        static let composition = "Composition"
        static let productDescription = "ProductDescription"
        static let productFeatures = "ProductFeatures"
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
                                           K.FIR.youthWomen: model.youthWomen,
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
                                           K.FIR.size0: model.sizes[0].size ?? "",
                                           K.FIR.size1: model.sizes[1].size ?? "",
                                           K.FIR.size2: model.sizes[2].size ?? "",
                                           K.FIR.size3: model.sizes[3].size ?? "",
                                           K.FIR.size4: model.sizes[4].size ?? "",
                                           K.FIR.size5: model.sizes[5].size ?? "",
                                           K.FIR.size6: model.sizes[6].size ?? "",
                                           K.FIR.usRetailMSRP: model.usMSRP,
                                           K.FIR.euRetailMSRP: model.euMSRP,
                                           K.FIR.countryCode: model.countryCode,
                                           K.FIR.composition: model.composition,
                                           K.FIR.productDescription: model.productDescription,
                                           K.FIR.productFeatures: model.productFeatures,
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

            //Now, SAVE!!!
            databaseReference.setValue(itemRef) { error, dbRef in
                completion?()
            }
        }
        else {
//            databaseReference.updateChildValues(item as! [AnyHashable : Any])
            databaseReference.updateChildValues(item as! [AnyHashable : Any]) { error, dbRef in
                completion?()
            }
        }
    }
}
