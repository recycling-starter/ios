//
//  UITextFeild.swift
//  RecyclingStarter
//
//  Created by  Matvey on 30.07.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit

extension UITextField {
    func shake() {
        let shake = CASpringAnimation(keyPath: "position")
        shake.duration = 0.2
        shake.repeatCount = 2
        shake.autoreverses = true
        shake.initialVelocity = 1
        shake.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeOut)
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}
