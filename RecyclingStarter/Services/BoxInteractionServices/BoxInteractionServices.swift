//
//  BoxInteractionServices.swift
//  RecyclingStarter
//
//  Created by  Matvey on 14.08.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation

class BoxInteractionServices: BoxInteractionProtocol {
    
    let networkService = NetworkService()
    
    func getBox(box: BoxData, token: String, complitionHandler: @escaping(BoxData?) -> Void) {
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
                complitionHandler(box)
                return
            } catch { }
            
            complitionHandler(nil)
        }
    }
    
    func fillBox(token: String, box: BoxData, isAdmin: Bool, fullness: Int, complitionHandler: @escaping(BoxData?) -> Void) {
        
        let url = AppHost.hostURL + "/v1/boxes/\(box.id)"
        
        let headers: [String: String] = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer \(token)"
        ]
        
        let params: [String: Any] = [
            "fullness": fullness,
            "room": box.room
        ]
        
        networkService.POSTRequest(url: url,
                                   params: params,
                                   headers: headers,
                                   httpMethod: isAdmin ? .put : .patch) { (stringData) in
            self.getBox(box: box, token: token) { (box) in
                complitionHandler(box)
            }
        }
    }
}
