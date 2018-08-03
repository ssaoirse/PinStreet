//
//  ActiveRequest.swift
//  PinStreet
//
//  Created by Saoirse on 8/2/18.
//  Copyright © 2018 Gaia Inc. All rights reserved.
//

import Foundation

// MARK: - Request completion closure.
typealias RequestCompletion =  (Data?, Error?) -> Void


// MARK - Active Request used for caching and efficient management.
struct ActiveRequest {
    // The URL/service path of the resource.
    let servicePath: String
    // Array of request Ids which have requested the resource.
    var reqIds: [Int]
    // The reference to the service controller performing the request.
    var serviceController: WebServiceController?
    // The array of completion blocks which will be used to notify completion/failure.
    var completions: [RequestCompletion]
    
    init(reqServicePath: String,
         reqIds: [Int]? = nil,
         serviceController: WebServiceController? = nil,
         completions: [RequestCompletion]? = nil) {
        self.servicePath = reqServicePath
        self.reqIds = [Int]()
        self.serviceController = serviceController
        self.completions = [RequestCompletion]()
    }
}
