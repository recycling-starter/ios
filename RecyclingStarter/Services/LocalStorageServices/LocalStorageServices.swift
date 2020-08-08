//
//  LocalStorageServices.swift
//  RecyclingStarter
//
//  Created by  Matvey on 31.07.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation

class LocalStorageServices {
    private var coreDataService = CoreDataManager()
    
    func saveUserInfo(email: String, password: String) {
        coreDataService.saveData(email: email, password: password) { (result) in
            if result == .success {
                print("Success save user info \(email) \(password)")
            } else {
                print("Error while saving user info")
            }
        }
    }
    
    func loadUserData(callback: @escaping(UserInfo?) -> Void) {
        var userInfo: UserInfo? = nil
        coreDataService.loadData { (result, loadInfo) in
            if result == .success {
                print("succes load user info \(loadInfo?.email) \(loadInfo?.password)")
                userInfo = loadInfo
            }
            callback(userInfo)
            
        }
        
    }
}
