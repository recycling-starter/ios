//
//  Debounce.swift
//  RecyclingStarter
//
//  Created by  Matvey on 08.08.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import Foundation

func debounce(interval: Int, queue: DispatchQueue, action: @escaping (() -> Void) ) -> () -> Void {
    var lastFireTime = DispatchTime.now()
    let delay = DispatchTimeInterval.milliseconds(interval)
    
    return {
        lastFireTime = DispatchTime.now()
        let dispatchTime: DispatchTime = DispatchTime.now() + delay
        
        queue.asyncAfter(deadline: dispatchTime) {
            let when: DispatchTime = lastFireTime + delay
            let now = DispatchTime.now()
            if now.rawValue >= when.rawValue {
                action()
            }
        }
    }
    
}
