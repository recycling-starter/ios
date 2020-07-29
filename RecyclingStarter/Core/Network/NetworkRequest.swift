//
//  NetworkRequest.swift
//  RecyclingStarter
//
//  Created by  Matvey on 26.07.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkRequest {
    func POSTrequest(url: String, params: [String: Any], callback: @escaping(String?) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseString(completionHandler: { (respose) in
            switch respose.result {
            case .success(let  value):
                callback(value)
                return
            case .failure:
                break
            }
            callback(nil)
        })
    }
}
