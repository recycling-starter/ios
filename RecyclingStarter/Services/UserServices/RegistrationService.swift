//
//  RegistrationService.swift
//  RecyclingStarter
//
//  Created by  Matvey on 22.02.2021.
//  Copyright © 2021 Borisov Matvei. All rights reserved.
//

import Foundation

class RegistrationService {
    
    let networkService = NetworkService()
    
    func isVerifidePass(pass: String?, confirmPass: String?) -> Bool {
        guard let pass = pass,
              pass != "",
              let confirmPass = confirmPass,
              confirmPass != "" else { return false }
        if pass == confirmPass {
            return true
        }
        return false
    }
    
    func isVerifideInfo(name: String?, email: String?, phone: String?, pass: String?, building: Int?, buildingName: String?, room: String?) -> Bool {
        guard let name = name,
              name != "",
              let email = email,
              email != "",
              let phone = phone,
              phone != "",
              let pass = pass,
              pass != "",
              let _ = building,
              let buildingName = buildingName,
              buildingName != "",
              let room = room,
              room != "" else { return false }
        return true
    }
    
    func registerNewUser(name: String?, email: String?, phone: String?, pass: String?, building: Int?, room: String?, complition: @escaping(Bool) -> Void) {
        
        let params: [String: Any] = [
            "first_name": name ?? "",
            "email": email ?? "",
            "phone": phone ?? "",
            "password": pass ?? "",
            "building": building ?? 0,
            "room": room ?? ""
        ]
        
        let url = AppHost.hostURL + "/v1/users/"
        
        let headers: [String: String] = [ "Content-Type": "application/x-www-form-urlencoded"]
        
        networkService.paramsRequest(url: url, params: params, headers: headers, httpMethod: .post) { (_, code) in
            if let _ = code {
                complition(false)
            } else {
                complition(true)
            }
        }
    }
    
    func getBuildingsList(complition: @escaping([String]) -> Void) {
        var buildings: [String] = []
        let url = AppHost.hostURL + "/v1/buildings"
        
        let headers: [String: String] = [:]
        
        networkService.GETRequest(url: url, headers: headers) { (data) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            let buildingsArray = try? decoder.decode([Building].self, from: data)
            buildings = buildingsArray?.map { build in
                build.address
            } ?? []
            complition(buildings)
        }
    }
}

private struct Building: Codable {
    var id: Int
    var address: String
}
