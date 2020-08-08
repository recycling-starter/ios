//
//  User.swift
//  RecyclingStarter
//
//  Created by  Matvey on 31.07.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation

struct User: Codable {
    var token: String
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
    }
}
