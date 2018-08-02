//
//  CommunicationController.swift
//  PinStreet
//
//  Created by Shashi Shaw on 02/08/18.
//  Copyright © 2018 Gaia Inc. All rights reserved.
//

import UIKit

// Class to manage communications and cache control.
class CommunicationController: NSObject {
    
    // Private member
    static private var sharedInstance: CommunicationController = {
        let commsController =  CommunicationController()
        return commsController
    }()
    
    
    // Returns a shared instance of the CommunicationController singleton.
    static func shared() -> CommunicationController {
        return sharedInstance
    }
    
    // Serves as the in memory cache.
    private let documentCache = NSCache<NSString, NSData>()

    /*!
     * @brief Performs the GET HTTP service
     * @param servicePath       The complete Path for the resource.
     * @param mimeType          The mime type for the GET request.
     * @param completion        Completion block, on success, passes the Data received and Error on failure.
     */
    func performGET(with url: String,
                    mimeType: String,
                    completion: @escaping(Data?, Error?) ->()) {
        
        // Check if already available.
        let strURL = url as NSString
        if let result = documentCache.object(forKey: strURL) {
            let data = result as Data
            completion(data, nil)
            return
        }
        let request = createGETRequest(from: url, mimeType: mimeType)
        var serviceController = WebServiceController()
        serviceController.performURLRequest(with: request) { [unowned self](data, error) in
            // Check if any error occured.
            if let error = error {
                print("Service Error: \(error)")
                completion(nil, error)
                return
            }
            if let data = data {
                let nsData = NSData(data: data)
                let nbrOfBytes = data.count
                self.documentCache.setObject(nsData, forKey: strURL, cost: nbrOfBytes)
            }
            completion(data, nil)
        }
    }
    
    // Returns a URL request for the specified Path and mime type.
    fileprivate func createGETRequest(from servicePath: String, mimeType: String) -> URLRequest {
        var request = URLRequest(url: URL(string: servicePath)!,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.setValue(mimeType, forHTTPHeaderField: "Content-Type")
        return request
    }
}
