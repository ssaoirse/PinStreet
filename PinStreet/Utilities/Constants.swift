//
//  Constants.swift
//  PinStreet
//
//  Created by Shashi Shaw on 01/08/18.
//  Copyright © 2018 Gaia Inc. All rights reserved.
//

import Foundation


struct Constants {
    // MARK:- URLs
    static let kRemoteURL                   = "http://pastebin.com/raw/wgkJgazE"
    //static let kRemoteURL                   = "https://gist.githubusercontent.com/azat-co/a3b93807d89fd5f98ba7829f0557e266/raw/43adc16c256ec52264c2d0bc0251369faf02a3e2/gistfile1.txt"
    static let kMimeTypeJSON                = "application/json"
    
    // Date Formats:
    static let kResponseDateFormat          = "yyyy-MM-dd'T'HH:mm:ss-SS:SS"
    static let kDisplayDateFormat           = "MMM dd, yyyy hh:mm a"
    static let kMaxCacheSize                = 10 * 1024 * 1024
}
