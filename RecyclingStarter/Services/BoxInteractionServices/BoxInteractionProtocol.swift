//
//  BoxInteractionProtocol.swift
//  RecyclingStarter
//
//  Created by  Matvey on 14.08.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

protocol BoxInteractionProtocol {
    
    func getBox(box: BoxData, token: String, complitionHandler: @escaping(BoxData?) -> Void)
    
    func fillBox(token: String, box: BoxData, isAdmin: Bool, fullness: Int, complitionHandler: @escaping(BoxData?) -> Void)
    
}
