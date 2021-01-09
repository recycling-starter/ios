//
//  User.swift
//  RecyclingStarter
//
//  Created by  Matvey on 31.07.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation

struct UserToken: Codable {
    var token: String
    var id: Int
    
    enum CodingKeys: String, CodingKey {
        case token
        case id
    }
}

struct UserData: Codable {
    var id: Int
    var firstName: String
    var building: Int
    var email: String
    var phone: Int
    var room: String
    var organization: Int?
    var boxes: [BoxData]
    var isActive: Bool
    lazy var isAdmin: Bool = {
        guard let organization = organization else { return false }
        return true
    }()
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case building
        case email
        case phone
        case room
        case organization
        case boxes
        case isActive = "is_active"
    }
}
