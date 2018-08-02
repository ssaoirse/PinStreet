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
    
    func configureItem(_ item: PinBoardItem?, atIndexpath indexPath: IndexPath) {
        if let pinBoardItem = item {
            // name:
            nameLabel.text = pinBoardItem.user.name
            if let date = pinBoardItem.date {
                let formatter = DateFormatter()
                formatter.dateFormat = Constants.kDisplayDateFormat
                dateLabel.text = formatter.string(from: date)
            }
            
            // Categories:
            let titleArray = pinBoardItem.categories.map({ (catgory: Category) -> String in
                catgory.title
            })
            categoriesLabel.text = titleArray.joined(separator: ", ")
            
            // Image.
            let pinBoardController = PinBoardController()
            pinBoardController.fetchPinBoardImage(fromURL: pinBoardItem.urls.regular,
                                                  mimeType: "image/jpeg",
            success: { [unowned self](data) in
                // Initiate request to load image.
                DispatchQueue.main.async {
                    if let data = data, let image = UIImage(data: data) {
                        self.imageView.image = image
                    }
                }
            },
            failure: { (errorMsg) in
                if let errorMsg = errorMsg {
                    print(errorMsg)
                }
            })
        }
    }
}
