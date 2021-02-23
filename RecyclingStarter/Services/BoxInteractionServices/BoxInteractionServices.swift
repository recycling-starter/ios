//
//  BoxInteractionServices.swift
//  RecyclingStarter
//
//  Created by  Matvey on 14.08.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation

class BoxInteractionServices {
    
    let networkService = NetworkService()
    let keychainService = KeychainService()
    
    func getBox(box: BoxData, complition: @escaping(BoxData?) -> Void) {
        guard let token = keychainService.token else {
            complition(nil)
            return
        }
        let url = AppHost.hostURL + "/v1/boxes/\(box.id)"
        
        let headers: [String: String] = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer \(token)"
        ]
        
        networkService.GETRequest(url: url, headers: headers) { (data) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let box = try decoder.decode(BoxData.self, from: data)
                complition(box)
                return
            } catch { }
            
            complition(nil)
        }
    }
    
    func fillBox(box: BoxData, isAdmin: Bool, fullness: Int, complition: @escaping(BoxData?) -> Void) {
        guard let token = keychainService.token else {
            complition(nil)
            return
        }
        let url = AppHost.hostURL + "/v1/boxes/\(box.id)"
        
        let headers: [String: String] = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer \(token)"
        ]
        
        let params: [String: Any] = [
            "fullness": fullness,
            "room": box.room
        ]
        
        networkService.paramsRequest(url: url,
                                   params: params,
                                   headers: headers,
                                   httpMethod: isAdmin ? .put : .patch) { (stringData) in
            self.getBox(box: box) { (box) in
                complition(box)
            }
        }
    }
}
