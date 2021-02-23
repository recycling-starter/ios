//
//  UserServices.swift
//  RecyclingStarter
//
//  Created by  Matvey on 26.07.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation

class UserServices {
    
    let networkService = NetworkService()
    let keychainService = KeychainService()
    
    func autharisation(email: String, password: String, complitionHandler: @escaping(UserData?, String) -> Void) {
        
        let params: [String: Any] = [
            "email" : email.trimmingCharacters(in: .whitespacesAndNewlines),
            "password" : password.trimmingCharacters(in: .whitespacesAndNewlines)
        ]
        
        let authPath = "/v1/users/auth/"
        let url = AppHost.hostURL + authPath
        
        let headers: [String: String] = ["Content-Type": "application/x-www-form-urlencoded"]
        
        networkService.paramsRequest(url: url, params: params, headers: headers, httpMethod: .post) { (data) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let userToken = try decoder.decode(UserToken.self, from: data)
                self.keychainService.token = userToken.token
                self.getUserData(id: userToken.id) { (userData) in
                    complitionHandler(userData, userToken.token)
                }
                return
            } catch {
                complitionHandler(nil, "")
            }
        }
    }
    
    private func getUserData(id: Int, complition: @escaping(UserData?) -> Void) {
        guard let token = keychainService.token else {
            complition(nil)
            return
        }
        let path = "/v1/users/\(id)"
        let url = AppHost.hostURL + path
        
        let headers: [String: String] = ["Authorization": "Bearer \(token)"]
        
        networkService.GETRequest(url: url, headers: headers) { (data) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            let userData = try? decoder.decode(UserData.self, from: data)
            complition(userData)
        }
    }
    
    func updateUserData(firstName: String? = nil, phone: String? = nil, room: String? = nil, complition: @escaping(UserData?) -> Void) {
        guard let token = keychainService.token else {
            complition(nil)
            return
        }
        
        let path = "/v1/users/"
        let url = AppHost.hostURL + path
        
        let headers: [String: String] = ["Content-Type": "application/x-www-form-urlencoded",
                                         "Authorization": "Bearer \(token)"]
        
        var params: [String: Any] = [:]
        
        if firstName == nil && phone == nil && room == nil {
            complition(nil)
        } else if let phone = phone {
            params["phone"] = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        } else if let firstName = firstName {
            params["first_name"] = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        } else if let room = room {
            params["room"] = room.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        networkService.paramsRequest(url: url, params: params, headers: headers, httpMethod: .put) { (data) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            let userData = try? decoder.decode(UserData.self, from: data)
            complition(userData)
        }
    }
    
    func updateUserPassword(oldPassword: String, newPassword: String, complition: @escaping(UpdateUserPasswordData?) -> Void) {
        guard let token = keychainService.token else {
            complition(nil)
            return
        }
        
        let path = "/v1/users/"
        let url = AppHost.hostURL + path
        
        let headers: [String: String] = ["Content-Type": "application/x-www-form-urlencoded",
                                         "Authorization": "Bearer \(token)"]
        
        let params: [String: Any] = ["old_password": oldPassword.trimmingCharacters(in: .whitespacesAndNewlines),
                                     "new_password": newPassword.trimmingCharacters(in: .whitespacesAndNewlines)]
        
        networkService.paramsRequest(url: url, params: params, headers: headers, httpMethod: .patch) { (data) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            let userPasswordData = try? decoder.decode(UpdateUserPasswordData.self, from: data)
            complition(userPasswordData)
        }
    }
}
