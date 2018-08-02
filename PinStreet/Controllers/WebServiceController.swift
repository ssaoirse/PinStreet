//
//  WebServiceController.swift
//  PinStreet
//
//  Created by Saoirse on 7/31/18.
//  Copyright © 2018 Gaia Inc. All rights reserved.
//

import Foundation

// Service Utility to perform REST Based HTTP methods.
struct WebServiceController {
    
    /*!
     * @brief Performs the GET HTTP service
     * @param url               The complete URL for the resource.
     * @param mimeType          The mime type for the GET request.
     * @param success           The completion block to be called on success, returns an array of PinBoard Items.
     * @param failure           The completion block to be called on failure, Returns an error message.
     */
    func performGETService(withURL url: String,
                           mimeType: String,
                           completion: @escaping(Data?, Error?) ->()) {
        let request = createGETRequest(from: url, mimeType: mimeType)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                print("Client Error: \(error)")
                completion(nil, error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Server Error: ")
                let err = NSError(domain: "", code: 400, userInfo: nil)
                completion(nil, err)
                return
            }
            print("success")
            guard let _ = data else {
                print("Invalid response data")
                return
            }
            completion(data, nil)
        })
        task.resume()
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
