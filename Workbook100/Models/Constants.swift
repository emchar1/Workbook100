//
//  Constants.swift
//  Workbook100
//
//  Created by Eddie Char on 12/23/21.
//

import Foundation
import UIKit

struct K {
    static var items: [CollectionModel] = []
    
    struct Fonts {
        static let bubbleTitle = UIFont(name: "AvenirNext-Bold", size: 12)
        static let title = UIFont(name: "AvenirNext-Bold", size: 14)
        static let subtitle = UIFont(name: "TimesNewRomanPS-ItalicMT", size: 9)
        static let footerTitle = UIFont(name: "TimesNewRomanPS-ItalicMT", size: 10)
    }
    
    struct CollectionCell {
        static let identifier = "CVCell"
        static let padding: CGFloat = 8
        static let width: CGFloat = 200
        static let height: CGFloat = CollectionCell.width * 3 / 2
    }
}
