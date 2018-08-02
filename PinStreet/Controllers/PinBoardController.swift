//
//  PinBoardController.swift
//  PinStreet
//
//  Created by Shashi Shaw on 01/08/18.
//  Copyright © 2018 Gaia Inc. All rights reserved.
//

import UIKit

// MARK:- Controller class for the PinBoard View.
class PinBoardController: NSObject {
    
    /*!
     * @brief Fetch Pin Board items from specified remote server
     * @param url               The complete URL for the resource.
     * @param success           The completion block to be called on success, returns an array of PinBoard Items.
     * @param failure           The completion block to be called on failure, Returns an error message.
     */
    func fetchPinBoardItems(success:@escaping (_ items: [PinBoardItem]) ->(),
                            failure:@escaping (String?) ->()) {
        let webserviceController = WebServiceController()
        webserviceController.performGETService(withURL: Constants.kRemoteURL,
                                               mimeType: Constants.kMimeTypeJSON)
        { (data, error) in
            
            guard let data = data else {
                failure("Invalid response data")
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                    let pinStreetFormatter = DateFormatter()
                    pinStreetFormatter.dateFormat = Constants.kResponseDateFormat

                    let container = try decoder.singleValueContainer()
                    let dateStr = try container.decode(String.self)

                    let tmpDate = pinStreetFormatter.date(from: dateStr)
                    guard let date = tmpDate else {
                        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
                    }
                    return date
                })
                let apiResponse = try jsonDecoder.decode([PinBoardItem].self, from: data)
                success(apiResponse)
            }
            catch {
                print(error)
                failure(error.localizedDescription)
            }
        }
    }
    
    /*!
     * @brief Fetch Pin Board Image from specified URL.
     * @param url               The complete URL for the Image.
     * @param mimeType          The mime type for the image.
     * @param success           The completion block to be called on success, returns an array of PinBoard Items.
     * @param failure           The completion block to be called on failure, Returns an error message.
     */
    func fetchPinBoardImage(fromURL url: URL,
                            mimeType: String,
                            success: @escaping (_ data: Data?) ->(),
                            failure: @escaping (String?)  ->()) {
        let webserviceController = WebServiceController()
        webserviceController.performGETService(withURL: url.absoluteString,
                                               mimeType: mimeType)
        { (data, error) in
            
            guard let data = data else {
                failure("Invalid response data")
                return
            }
            success(data)
        }
    }
}
