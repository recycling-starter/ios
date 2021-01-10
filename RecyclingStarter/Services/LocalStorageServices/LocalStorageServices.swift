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
            } else {
            }
        }
    }
    
    func loadUserData(callback: @escaping(UserInfo?) -> Void) {
        var userInfo: UserInfo? = nil
        coreDataService.loadData { (result, loadInfo) in
            if result == .success {
                userInfo = loadInfo
            }
            callback(userInfo)
        }
    }
    
    func logoutUser(callback: @escaping()->Void) {
        coreDataService.clearUserData { (resault) in
            switch resault{
            case .success:
                print("success delete user data")
            case .error:
                print("error delete user data")
            }
            callback()
        }
    }
}
