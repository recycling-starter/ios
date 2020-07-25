//
//  UIUnderlinedTextField.swift
//  RecyclingStarter
//
//  Created by  Matvey on 23.07.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit

class UIUnderlinedTextField: UITextField {
    
    override var tintColor: UIColor! {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        let startPoint = CGPoint(x: rect.minX, y: rect.maxY)
        let endPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        path.lineWidth = 1
        
        tintColor.setStroke()
        
        path.stroke()
    }
}
