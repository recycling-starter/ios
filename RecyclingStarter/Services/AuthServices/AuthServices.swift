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
    
    func autharisation(email: String, password: String, complitionHandler: @escaping(UserData?, String) -> Void) {
        
        let params: [String: Any] = [
            "email" : email.trimmingCharacters(in: .whitespacesAndNewlines),
            "password" : password.trimmingCharacters(in: .whitespacesAndNewlines)
        ]
        
        let authPath = "/v1/users/auth/"
        let url = AppHost.hostURL + authPath
        
        let headers: [String: String] = ["Content-Type": "application/x-www-form-urlencoded"]
        
        networkService.POSTRequest(url: url, params: params, headers: headers, httpMethod: .post) { (data) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let userToken = try decoder.decode(UserToken.self, from: data)
                self.getUserData(userToken: userToken) { (userData) in
                    complitionHandler(userData, userToken.token)
                }
                return
            } catch { }
            
            complitionHandler(nil, "")
        }
    }
    
    private func getUserData(userToken: UserToken, complitionHandler: @escaping(UserData?) -> Void) {
        
        let path = "/v1/users/\(userToken.id)"
        let url = AppHost.hostURL + path
        
        let headers: [String: String] = ["Authorization": "Bearer \(userToken.token)"]
        
        networkService.GETRequest(url: url, headers: headers) { (data) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            let userData = try! decoder.decode(UserData.self, from: data)
            complitionHandler(userData)
            
            complitionHandler(nil)
        }
    }
}
