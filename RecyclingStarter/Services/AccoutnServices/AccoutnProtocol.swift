//
//  AccoutnProtocol.swift
//  RecyclingStarter
//
//  Created by  Matvey on 14.08.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation

protocol AccoutnProtocol {
    
    func autharisation(email: String, password: String, callback: @escaping(User?) -> Void)
    
    func logout(callback: @escaping()->Void)
    
    func saveUserData(email: String, password: String)
    
    func loadUserData(callback: @escaping(UserInfo?) -> Void)
}
