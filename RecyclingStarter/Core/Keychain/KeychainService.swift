//
//  KeychainService.swift
//  RecyclingStarter
//
//  Created by  Matvey on 22.02.2021.
//  Copyright © 2021 Borisov Matvei. All rights reserved.
//

import Foundation
import KeychainAccess

class KeychainService {
    
    private let keychain = Keychain(service: "borisov.Matvey.RecyclingStarter")
    
    var token: String? {
        get {
            let token = try? keychain.getString("token")
            return token
        }
        set {
            keychain["token"] = newValue
        }
    }
    
    var id: Int? {
        get {
            let idStr = try? keychain.getString("id")
            guard let id = Int(idStr ?? "") else { return nil }
            return id
        }
        set {
            guard let id = newValue else { return }
            keychain["id"] = String(describing: id)
        }
    }
    
    func clearKeychain() {
        token = nil
        id = nil
    }
}
