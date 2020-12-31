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
        
        let headers: [String: String] = ["Content-Type": "application/json"]
        
        let params = ["token": token]
        
        networkService.POSTrequest(url: url, params: params, headers: headers) { (stringData) in
            if let data = stringData?.data(using: .utf8) {
                let decoder = JSONDecoder()
                do {
                    let box = try decoder.decode(BoxData.self, from: data)
                    complitionHandler(box)
                    return
                } catch { }
            }
            complitionHandler(nil)
        }
    }
    
    func fillBox(token: String, box: BoxData, fullness: Int, complitionHandler: @escaping(BoxData?) -> Void) {
        
        let url = AppHost.hostURL + "/v1/boxes/\(box.id)"
        
        let headers: [String: String] = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer \(token)"
        ]
        
        let params: [String: Any] = [
            "filling": fullness
        ]
        
        networkService.POSTrequest(url: url, params: params, headers: headers) { (stringData) in
            self.getBox(box: box, token: token) { (box) in
                complitionHandler(box)
            }
        }
    }
}
