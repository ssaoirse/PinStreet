//
//  CommunicationController.swift
//  PinStreet
//
//  Created by Shashi Shaw on 02/08/18.
//  Copyright © 2018 Gaia Inc. All rights reserved.
//

import Foundation

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
    
    /*!
     * @brief Performs the GET HTTP service
     * @param servicePath       The complete Path for the resource.
     * @param mimeType          The mime type for the GET request.
     * @param completion        Completion block, on success, passes the Data received and Error on failure.
     */
    func performGET(with url: String,
                    mimeType: String,
                    completion: @escaping(Data?, Error?) ->()) {
        
        // Check if already available in Cache
        let cacheController = CacheController.shared()
        if let data = cacheController.getEntry(with: url) {
            completion(data, nil)
            return
        }
        let request = createGETRequest(from: url, mimeType: mimeType)
        var serviceController = WebServiceController()
        serviceController.performURLRequest(with: request) { (data, error) in
            // Check if any error occured.
            if let error = error {
                print("Service Error: \(error)")
                completion(nil, error)
                return
            }
            // Validate data.
            if let data = data {
                // Cache Data and notify listener.
                cacheController.addEntry(with: url, data: data)
                completion(data, nil)
                return
            }
            
            // else notify error.
            let err = NSError(domain: "Invalid Data: 1001", code: 1001, userInfo: nil)
            completion(nil, err)
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
