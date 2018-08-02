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
    // reference to task.
    var task: URLSessionDataTask?
    /*!
     * @brief Performs the GET HTTP service
     * @param url               The complete URL for the resource.
     * @param mimeType          The mime type for the GET request.
     * @param success           The completion block to be called on success, returns an array of PinBoard Items.
     * @param failure           The completion block to be called on failure, Returns an error message.
     */
    mutating func performURLRequest(with request: URLRequest,
                                    completion: @escaping(Data?, Error?) ->()) {
        let session = URLSession.shared
        task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                print("Client Error: \(error)")
                completion(nil, error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let code = (response as? HTTPURLResponse)!.statusCode
                if let str  = request.url?.absoluteString {
                    print("Server Error: - \(str))")
                }
                let err = NSError(domain: "HTTP Status Code: \(code)", code: code, userInfo: nil)
                completion(nil, err)
                return
            }
            guard let _ = data else {
                print("Invalid response data")
                return
            }
            completion(data, nil)
        })
        task?.resume()
    }
    
    
    // Cancel a task.
    func cancel() {
        if task?.state == .running {
            task?.cancel()
        }
    }

}
