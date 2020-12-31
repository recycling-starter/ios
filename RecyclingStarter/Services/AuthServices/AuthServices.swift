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
    
    func autharisation(email: String, password: String, complitionHandler: @escaping(UserData?) -> Void) {
        
        let params: [String: Any] = [
            "email" : email.trimmingCharacters(in: .whitespacesAndNewlines),
            "password" : password.trimmingCharacters(in: .whitespacesAndNewlines)
        ]
        
        let authPath = "/v1/users/auth/"
        let url = AppHost.hostURL + authPath
        
        let headers: [String: String] = ["Content-Type": "application/x-www-form-urlencoded"]
        
        networkService.POSTrequest(url: url, params: params, headers: headers) { (stringData) in
            if let data = stringData?.data(using: .utf8){
                let decoder = JSONDecoder()
                do {
                    let userToken = try decoder.decode(UserToken.self, from: data)
                    self.getUserData(userToken: userToken) { (userData) in
                        complitionHandler(userData)
                    }
                    return
                } catch { }
            }
            complitionHandler(nil)
        }
    }
    
    private func getUserData(userToken: UserToken, complitionHandler: @escaping(UserData?) -> Void) {
        
        let path = "/v1/users/\(userToken.id)"
        let url = AppHost.hostURL + path
        
        let headers: [String: String] = ["Authorization": "Bearer \(userToken.token)"]
        
        networkService.GETRequest(url: url, headers: headers) { (stringData) in
            if let data = stringData?.data(using: .utf8) {
                let decoder = JSONDecoder()
                do {
                    let userData = try decoder.decode(UserData.self, from: data)
                    complitionHandler(userData)
                } catch  { }
            }
            complitionHandler(nil)
        }
    }
}
