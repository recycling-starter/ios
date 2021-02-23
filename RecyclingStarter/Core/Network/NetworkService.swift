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
    func paramsRequest(url: String, params: [String: Any], headers: [String: String], httpMethod: HTTPMethod, completion: @escaping(Data?, Int?) -> Void) {
        
        let httpHeaders: HTTPHeaders = HTTPHeaders(headers)
        
        AF.request(url, method: httpMethod, parameters: params, encoding: URLEncoding.default, headers: httpHeaders).responseData { (respose) in
            switch respose.result {
            case .success(let  value):
                completion(value, respose.response?.statusCode)
                return
            case .failure:
                break
            }
            completion(nil, nil)
        }
    }
    
    func GETRequest(url: String, headers: [String: String], completionHandler: @escaping(Data?) -> Void) {
        
        let httpHeaders: HTTPHeaders = HTTPHeaders(headers)
        
        AF.request(url, method: .get, encoding: URLEncoding.default, headers: httpHeaders).responseData { (response) in
            switch response.result {
            case .success(let value):
                completionHandler(value)
                return
            case .failure:
                break
            }
            completionHandler(nil)
        }
    }
}
