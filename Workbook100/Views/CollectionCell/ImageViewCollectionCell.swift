//
//  ImageViewCollectionCell.swift
//  Workbook100
//
//  Created by Eddie Char on 3/21/22.
//

import UIKit

class ImageViewCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    var spinner = ActivitySpinner()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
        imageView.cancelImageLoad()
    }
}
