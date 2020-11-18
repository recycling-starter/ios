//
//  LoginTextField.swift
//  RecyclingStarter
//
//  Created by  Matvey on 19.11.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit
import TinyConstraints

final class LoginTextField: UserInfoTextField {
    
    private var leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        let image = AppImage.emailIconImage?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = AppColor.placeholder
        imageView.image = image
        
        return imageView
    }()
    
    override var tintColor: UIColor! {
        willSet {
            leftImageView.tintColor = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyle() {
        textAlignment = .left
        autocapitalizationType = .none
        styledPlaceholder = "login"
    }
    
    private func setupSubviews() {
        leftViewMode = .always
        let leftView = UIView()
        leftView.addSubview(leftImageView)
        leftView.width(29)
        leftView.height(24)
        self.leftView = leftView
        
        leftImageView.bottomToSuperview(offset: -6)
        leftImageView.leadingToSuperview(offset: 8)
    }
}
