//
//  AuthServices.swift
//  RecyclingStarter
//
//  Created by  Matvey on 26.07.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation
import Alamofire

class AuthServices {
    let networkService = NetworkRequest()
    
    
    func autharisation(email: String, password: String, callback: @escaping(AFDataResponse<String>) -> Void) {
        let params: [String: Any] = [
            "email" : "timofei228@gmail.com",
            "password" : "greenlife20"
        ]
        let mainUrl = "https://oreldaniil.pythonanywhere.com"
        let authPath = "/users/login"
        let url = mainUrl + authPath
        
        networkService.POSTrequest(url: url, params: params) { (response) in
            callback(response)
        }
    }
}
