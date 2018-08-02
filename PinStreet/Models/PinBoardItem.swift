//
//  PinBoardItem.swift
//  PinStreet
//
//  Created by Saoirse on 7/31/18.
//  Copyright © 2018 Gaia Inc. All rights reserved.
//

import Foundation
import UIKit

// MARK:- User
struct User {
    let id: String
    let name: String
    let userName: String
}

extension User: Decodable {
    private enum UserCodingKeys: String, CodingKey {
        case id
        case name
        case userName = "username"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserCodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        userName = try container.decode(String.self, forKey: .userName)
    }
}


// MARK: - URL
struct Url {
    let small: URL
    let regular: URL
    let thumb: URL
}
extension Url: Decodable {
    private enum UrlCodingKeys: String, CodingKey {
        case small
        case regular
        case thumb
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UrlCodingKeys.self)
        small = try container.decode(URL.self, forKey: .small)
        regular = try container.decode(URL.self, forKey: .regular)
        thumb = try container.decode(URL.self, forKey: .thumb)
    }
}


// MARK: - Category
struct Category {
    let id: Int
    let title: String
}
extension Category: Decodable {
    private enum CategoryCodingKeys: String, CodingKey {
        case id
        case title
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CategoryCodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
    }
}


// MARK:- Pin Board Item -
struct PinBoardItem {
    let user: User
    let urls: Url
    let categories: [Category]
}
extension PinBoardItem: Decodable {
    private enum PinBoardItemCodingKeys: String, CodingKey {
        case user
        case urls
        case categories
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PinBoardItemCodingKeys.self)
        user = try container.decode(User.self, forKey: .user)
        urls = try container.decode(Url.self, forKey: .urls)
        categories = try container.decode([Category].self, forKey: .categories)
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
