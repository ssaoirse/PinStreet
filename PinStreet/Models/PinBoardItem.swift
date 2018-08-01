//
//  PinBoardItem.swift
//  PinStreet
//
//  Created by Saoirse on 7/31/18.
//  Copyright © 2018 Gaia Inc. All rights reserved.
//

import Foundation
import UIKit

// MARK:- Pin Board Item -
struct PinBoardItem  {
    
    let itemId: String
    let createdAt: Date
    let width: Int
    let height: Int
    let color: String
    let likes: Int
    let likedByUser: Bool
    
    // Intializer.
    init(itemId: String, createdAt: Date, width: Int, height: Int, color: String, likes: Int, likedByUser: Bool) {
        self.itemId = itemId
        self.createdAt = createdAt
        self.width = width
        self.height = height
        self.color = color
        self.likes = likes
        self.likedByUser = likedByUser
    }
}


struct Photo {
    
    var caption: String
    var comment: String
    var image: UIImage
    
    
    init(caption: String, comment: String, image: UIImage) {
        self.caption = caption
        self.comment = comment
        self.image = image
    }
    
    init?(dictionary: [String: String]) {
        guard let caption = dictionary["Caption"], let comment = dictionary["Comment"], let photo = dictionary["Photo"],
            let image = UIImage(named: photo) else {
                return nil
        }
        self.init(caption: caption, comment: comment, image: image)
    }
    
    static func allPhotos() -> [Photo] {
        var photos = [Photo]()
        guard let URL = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
            let photosFromPlist = NSArray(contentsOf: URL) as? [[String:String]] else {
                return photos
        }
        for dictionary in photosFromPlist {
            if let photo = Photo(dictionary: dictionary) {
                photos.append(photo)
            }
        }
        return photos
    }
    
}
