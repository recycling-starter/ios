//
//  EmployeeServices.swift
//  RecyclingStarter
//
//  Created by  Matvey on 09.08.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation

class EmployeeServices {
    
    let hostUrl = "https://oreldaniil.pythonanywhere.com"
    let networkService = NetworkService()
    
    func getBox(user: User, callback: @escaping(Box?) -> Void) {
        
        
        let url = hostUrl + "/boxes/get"
        
        let headers: [String: String] = ["Content-Type": "application/json"]
        
        let params = ["token": user.token]
        
        networkService.POSTrequest(url: url, params: params, headers: headers) { (stringData) in
            if let data = stringData?.data(using: .utf8) {
                let decoder = JSONDecoder()
                do {
                    let box = try decoder.decode(Box.self, from: data)
                    callback(box)
                    return
                } catch { }
            }
            callback(nil)
        }
    }
    
    func fillBox(user: User, box: Box, filling: Int, callback: @escaping(Box?) -> Void) {
        
        let url = hostUrl + "/boxes/fill"
        
        let headers: [String: String] = ["Content-Type": "application/json"]
        
        let params: [String: Any] = [
            "token": user.token,
            "id": box.id,
            "filling": filling
        ]
        
        networkService.POSTrequest(url: url, params: params, headers: headers) { (stringData) in
            if let data = stringData?.data(using: .utf8) {
                let decoder = JSONDecoder()
                do {
                    let box = try decoder.decode(Box.self, from: data)
                    callback(box)
                    return
                } catch { }
            }
            callback(nil)
        }
    }
}
