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
    
    private var textPadding: UIEdgeInsets {
        let padding: CGFloat = 10 + (leftView?.frame.width ?? 0)
        return UIEdgeInsets(top: 0, left: padding, bottom: 10, right: 0)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
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
