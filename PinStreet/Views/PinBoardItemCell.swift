//
//  PinBoardItemCell.swift
//  PinStreet
//
//  Created by Shashi Shaw on 01/08/18.
//  Copyright © 2018 Gaia Inc. All rights reserved.
//

import UIKit

class PinBoardItemCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }
    
    var photo: Photo? {
        didSet {
            if let photo = photo {
                imageView.image = photo.image
                nameLabel.text = photo.caption
                dateLabel.text = "2016-05-29 15:42:02"
                categoriesLabel.text = photo.comment
            }
        }
    }
}
