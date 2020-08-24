//
//  BoxInteractionProtocol.swift
//  RecyclingStarter
//
//  Created by  Matvey on 14.08.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

protocol BoxInteractionProtocol {
    
    func getBox(user: User, callback: @escaping(Box?) -> Void)
    
    func fillBox(user: User, box: Box, filling: Int, callback: @escaping(Box?) -> Void)
    
}
