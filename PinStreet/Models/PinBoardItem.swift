//
//  PinBoardItem.swift
//  PinStreet
//
//  Created by Saoirse on 7/31/18.
//  Copyright © 2018 Gaia Inc. All rights reserved.
//

import Foundation

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
