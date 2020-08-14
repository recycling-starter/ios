//
//  NetworkService.swift
//  RecyclingStarter
//
//  Created by  Matvey on 26.07.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation
import Alamofire

class NetworkService {
    func POSTrequest(url: String, params: [String: Any], headers: [String: String], callback: @escaping(String?) -> Void) {
        
        let httpHeaders: HTTPHeaders = HTTPHeaders(headers)
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: httpHeaders).responseString(completionHandler: { (respose) in
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
