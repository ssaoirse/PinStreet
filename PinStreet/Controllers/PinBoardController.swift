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
        webserviceController.performGET(withURL: Constants.kRemoteURL,
                                        mimeType: Constants.kMimeTypeJSON,
        success: { (items) in
            success(items)
        },
        failure: { (errorMessage) in
            failure(errorMessage)
        })
    }
}
