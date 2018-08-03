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
    
    // Array to hold active requests.
    let activeRequests = [ActiveRequest]()
    private var reqCounter: Int = 0
    
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
        
        // Check if request already exists. and is active.
        if var req = getActiveRequest(with: url) {
            reqCounter += 1
            req.reqIds.append(reqCounter)
            req.completions.append(completion)
        }
        // Create a new active request.
        else {
            // Update the status.
            var _ = addRequest(with: url, completion: completion)
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
    
    
    // Returns the active request object for the specified path.
    fileprivate func getActiveRequest(with servicePath: String) -> ActiveRequest? {
        let filtered = activeRequests.filter { $0.servicePath == servicePath }
        if filtered.count > 0 {
            return filtered[0]
        }
        return nil
    }
    
    // Creates and adds an active request to the Array.
    fileprivate func addRequest(with servicePath: String,
                                completion: RequestCompletion) -> ActiveRequest {
        var req = ActiveRequest(reqServicePath: servicePath)
        reqCounter += 1
        req.reqIds.append(reqCounter)
        return req
    }
}
