//
//  UserInfoTextField.swift
//  RecyclingStarter
//
//  Created by  Matvey on 16.11.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit
import SwiftRichString

class UserInfoTextField: UIUnderlinedTextField {
    
    private enum Style {
        static let placeholderStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.medium16
            $0.color = AppColor.placeholder
        }
        
        static let textStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.medium16
            $0.color = AppColor.label
        }
    }
    
    var styledPlaceholder: String? {
        willSet{
            self.attributedPlaceholder = newValue?.set(style: Style.placeholderStyle)
        }
    }
    
    private func setupStyle() {
        self.style = Style.textStyle
        self.font = Style.textStyle.font?.font(size: Style.textStyle.size)
        self.textColor = Style.textStyle.color?.color
        self.tintColor = Style.placeholderStyle.color?.color
        self.textAlignment = .left
    }
    
    func errorSignalize() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.transform = CGAffineTransform.identity
        }
        
        self.tintColor = AppColor.error
        self.textColor = AppColor.error
    }
    
    func cleanErrorSignalize() {
        self.tintColor = Style.placeholderStyle.color?.color
        self.textColor = Style.textStyle.color?.color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//func shake() {
//    let shake = CASpringAnimation(keyPath: "position")
//    shake.duration = 0.15
//    shake.autoreverses = true
//    shake.initialVelocity = 1.5
//    shake.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeOut)
//    
//    let fromPoint = CGPoint(x: center.x - 5, y: center.y)
//    let fromValue = NSValue(cgPoint: fromPoint)
//    
//    let toPoint = CGPoint(x: center.x + 5, y: center.y)
//    let toValue = NSValue(cgPoint: toPoint)
//    
//    shake.fromValue = fromValue
//    shake.toValue = toValue
//    
//    layer.add(shake, forKey: "position")
//}

