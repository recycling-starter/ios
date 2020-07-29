//
//  AuthServices.swift
//  RecyclingStarter
//
//  Created by  Matvey on 26.07.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation

class AuthServices {
    let networkService = NetworkRequest()
    
    
    func autharisation(email: String, password: String, callback: @escaping(UserLogin) -> Void) {
        let params: [String: Any] = [
            "email" : email.trimmingCharacters(in: .whitespacesAndNewlines),
            "password" : password.trimmingCharacters(in: .whitespacesAndNewlines)
//            "email" : "timofei228@gmail.com",
//            "password" : "greenlife20"
        ]
        let mainUrl = "https://oreldaniil.pythonanywhere.com"
        let authPath = "/users/login"
        let url = mainUrl + authPath
        
        networkService.POSTrequest(url: url, params: params) { (stringData) in
            if let data = stringData?.data(using: .utf8){
                let decoder = JSONDecoder()
                do {
                    let user = try decoder.decode(UserLogin.self, from: data)
                    callback(user)
                    return
                } catch { }
            }
            let user = UserLogin(result: "error")
            callback(user)
        }
    }
}


struct UserLogin: Codable {
    var result: String
    var token: String?
    var type: String?
}
