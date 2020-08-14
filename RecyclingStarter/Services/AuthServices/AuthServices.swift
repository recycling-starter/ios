//
//  AuthServices.swift
//  RecyclingStarter
//
//  Created by  Matvey on 26.07.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation

class AuthServices {
    
    let networkService = NetworkService()
    
    func autharisation(email: String, password: String, callback: @escaping(User?) -> Void) {
        
        let params: [String: Any] = [
            "email" : email.trimmingCharacters(in: .whitespacesAndNewlines),
            "password" : password.trimmingCharacters(in: .whitespacesAndNewlines)
        ]
        
        let mainUrl = "https://oreldaniil.pythonanywhere.com"
        let authPath = "/users/login"
        let url = mainUrl + authPath
        
        let headers: [String: String] = ["Content-Type": "application/json"]
        
        networkService.POSTrequest(url: url, params: params, headers: headers) { (stringData) in
            if let data = stringData?.data(using: .utf8){
                let decoder = JSONDecoder()
                do {
                    let user = try decoder.decode(User.self, from: data)
                    callback(user)
                    return
                } catch { }
            }
            callback(nil)
        }
    }
}
