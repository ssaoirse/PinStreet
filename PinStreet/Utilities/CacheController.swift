//
//  CacheController.swift
//  PinStreet
//
//  Created by Shashi Shaw on 03/08/18.
//  Copyright © 2018 Gaia Inc. All rights reserved.
//

import UIKit

// Class to manage caching of requested resources.
class CacheController: NSObject {
    // Private member
    static private var sharedInstance: CacheController = {
        let cacheController =  CacheController()
        return cacheController
    }()
    
    
    // Returns a shared instance of the CacheController singleton.
    static func shared() -> CacheController {
        return sharedInstance
    }
    
    // Serves as the in memory cache.
    private let documentCache = NSCache<NSString, NSData>()
    
    // Stores the size of Cache.
    private var currentSize: Int = 0
    var maxCacheSize: Int = Constants.kMaxCacheSize
    
    
    // Add the URL and the data to the cache.
    func addEntry(with url: String, data: Data) {
        let strURL = url as NSString
        let nsData = NSData(data: data)
        let nbrOfBytes = nsData.length
        self.documentCache.setObject(nsData, forKey: strURL, cost: nbrOfBytes)
        currentSize += nbrOfBytes
    }

    // Returns the Data for the requested resource if available.
    func getEntry(with url: String) -> Data? {
        let strURL = url as NSString
        if let result = documentCache.object(forKey: strURL) {
            let data = result as Data
            return data
        }
        // else return nil
        return nil
    }
    
    func removeEntry(with url: String) {
        let strURL = url as NSString
        guard let nsData: NSData = documentCache.object(forKey: strURL) else {
            return
        }
        // Decrement cache size and remove entry.
        currentSize -= nsData.length
        documentCache.removeObject(forKey: strURL)
    }
    
    // Clears all cache.
    func clear() {
        self.documentCache.removeAllObjects()
    }
    
}
