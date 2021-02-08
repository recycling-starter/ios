//
//  AccoutnProtocol.swift
//  RecyclingStarter
//
//  Created by  Matvey on 14.08.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation

protocol AccountDataManagerProtocol {
    
    func logout(callback: @escaping()->Void)
    
    func saveUserData(email: String, password: String)
    
    func loadUserData(callback: @escaping(UserInfo?) -> Void)
}
