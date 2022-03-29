//
//  Constants+ProductFilter.swift
//  Workbook100
//
//  Created by Eddie Char on 3/28/22.
//

import Foundation

extension K {
    struct ProductFilter {
        static let wildcard = "[All]"
        static let segementedBoth = 0
        static let segementedOn = 1
        static let segementedOff = 2
        static let multiSeparator = "|"
        
        static var selectionSavedLists: [String] = []
        static var selectionCollection: [String] = []
        static var selectionDivision: [String] = []
        static var selectionProductCategory: [String] = []
        static var selectionProductType: [String] = []
        static var selectionProductSubtype: [String] = []
        static var selectionProductClass: [String] = []
        static var selectionProductDetails: [String] = []

        static var selectedSavedLists: String = wildcard
        static var selectedNew: Int = segementedBoth
        static var selectedEssential: Int = segementedBoth
        static var selectedCollection: String = wildcard
        static var selectedProductCategory: [String] = [wildcard]
        static var selectedProductType: [String] = [wildcard]
        static var selectedProductSubtype: [String] = [wildcard]
        static var selectedDivision: [String] = [wildcard]
        static var selectedProductClass: [String] = [wildcard]
        static var selectedProductDetails: [String] = [wildcard]
        
        static var isFiltered: Bool {
            return !(selectedSavedLists == wildcard &&
                     selectedNew == segementedBoth &&
                     selectedEssential == segementedBoth &&
                     selectedCollection == wildcard &&
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
        }//end static var categories
    }//end struct ProductFilter
}//end extension K
