//
//  AccountService.swift
//  RecyclingStarter
//
//  Created by  Matvey on 14.08.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation

class AccountService: AccoutnProtocol {
    
    let networkService = NetworkService()
    let localStorageCervice = CoreDataManager()
    
    func autharisation(email: String, password: String, callback: @escaping (User?) -> Void) {
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
    
    func logout(callback: @escaping () -> Void) {
        localStorageCervice.clearUserData { (resault) in
            switch resault{
            case .success:
                print("success delete user data")
            case .error:
                print("error delete user data")
            }
            callback()
        }
    }
    
    func saveUserData(email: String, password: String) {
        localStorageCervice.saveData(email: email, password: password) { (result) in
            if result == .success {
                print("Success save user info \(email) \(password)")
            } else {
                print("Error while saving user info")
            }
        }
    }
    
    func loadUserData(callback: @escaping (UserInfo?) -> Void) {
        var userInfo: UserInfo? = nil
        localStorageCervice.loadData { (result, loadInfo) in
            if result == .success {
                userInfo = loadInfo
            }
            callback(userInfo)
        }
    }
    
    
}
