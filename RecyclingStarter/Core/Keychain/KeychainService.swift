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
            guard let newValue = newValue else { return }
            keychain["token"] = newValue
        }
    }
}
