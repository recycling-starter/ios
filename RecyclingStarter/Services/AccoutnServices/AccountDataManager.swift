//
//  AccountDataManager.swift
//  RecyclingStarter
//
//  Created by  Matvey on 14.08.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation

class AccountDataManager: AccountDataManagerProtocol {
    
    let networkService = NetworkService()
    let localStorageCervice = CoreDataManager()
    
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
