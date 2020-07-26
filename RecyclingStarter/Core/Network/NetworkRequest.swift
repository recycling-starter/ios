//
//  NetworkRequest.swift
//  RecyclingStarter
//
//  Created by  Matvey on 26.07.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation
import Alamofire

class NetworkRequest {
    func POSTrequest(url: String, params: [String: Any], callback: @escaping(AFDataResponse<String>) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseString { (response) in
            callback(response)
        }
    }
}
