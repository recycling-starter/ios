//
//  TitledInfoView.swift
//  RecyclingStarter
//
//  Created by  Matvey on 12.01.2021.
//  Copyright © 2021 Borisov Matvei. All rights reserved.
//

import UIKit
import TinyConstraints
import SwiftRichString

class TitledInfoView: UIView {
    
    var textField = UserInfoTextField()
    private var titleLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
    
    private enum Style {
        static let placeholderStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.medium16
            $0.color = AppColor.placeholder
        }
    }
    
    init(title: String, text: String, textPlaceholder: String = "") {
        self.titleLabel.text = title
        self.textField.styledText = text
        self.textField.styledPlaceholder = textPlaceholder
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(textField)
        self.addSubview(titleLabel)
        
        titleLabel.font = AppFont.regular14
        
        titleLabel.topToSuperview()
        titleLabel.leadingToSuperview()
        
        textField.topToBottom(of: titleLabel, offset: 8)
        textField.leadingToSuperview()
        textField.trailingToSuperview()
        textField.bottomToSuperview()
        
        self.height(50)
    }
}
