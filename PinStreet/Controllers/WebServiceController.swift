//
//  WebServiceController.swift
//  PinStreet
//
//  Created by Saoirse on 7/31/18.
//  Copyright © 2018 Gaia Inc. All rights reserved.
//

import Alamofire

// Service Class to perform REST Based HTTP methods.
class WebServiceController: NSObject {
    
    /*!
     * @brief Fetch Pin Board items from specified service path / url.
     * @param url               The complete URL for the resource.
     * @param success           The completion block to be called on success, returns an array of PinBoard Items.
     * @param failure           The completion block to be called on failure, Returns an error message.
     */
    func fetchPinBoardItems(from url: String,
                            success:@escaping (_ items: [PinBoardItem]) ->(),
                            failure:@escaping (String?) ->()) {
        
        // Set content type header.
        // Set request parameters.
        var headers = [String: String]()
        headers["Content-Type"] = "application/json"
        
        Alamofire.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: headers)
        .responseJSON { response in
            // Check for success in response.
            if (response.result.isSuccess) {
                
            }
            else {
                // notify error.
                failure(response.error?.localizedDescription)
            }
        }
        .responseString { (result) in
                print(result)
        }
    }

}
