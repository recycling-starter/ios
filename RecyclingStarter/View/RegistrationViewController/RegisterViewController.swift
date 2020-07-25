//
//  RegisterViewController.swift
//  RecyclingStarter
//
//  Created by  Matvey on 23.07.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit
import TinyConstraints
import SwiftRichString

class RegisterViewController: UIViewController {
    
    private let nameField: UIUnderlinedTextField
    private let surnameField: UIUnderlinedTextField
    private let emailField: UIUnderlinedTextField
    private let phoneField: UIUnderlinedTextField
    private let passwordField: UIUnderlinedTextField
    private let adressField: UIUnderlinedTextField
    private let officeField: UIUnderlinedTextField
    private let codeField: UIUnderlinedTextField
    private let regLabel: UILabel
    private let regButton: UIButton
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.nameField = Self.makeField(placeholder: "name")
        self.surnameField = Self.makeField(placeholder: "surname")
        self.emailField = Self.makeField(placeholder: "email")
        self.phoneField = Self.makeField(placeholder: "phone")
        self.passwordField = Self.makeField(placeholder: "password")
        self.adressField = Self.makeField(placeholder: "adress")
        self.officeField = Self.makeField(placeholder: "office")
        self.codeField = Self.makeField(placeholder: "code")
        self.regLabel = Self.makeLabel(text: "Registration")
        self.regButton = Self.makeButton(text: "Do registration")
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    func setUpViews() {
        view.backgroundColor = AppColor.authBackground
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(nameField)
        stackView.addArrangedSubview(surnameField)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(phoneField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(adressField)
        stackView.addArrangedSubview(officeField)
        stackView.addArrangedSubview(codeField)
        stackView.addArrangedSubview(regButton)
        
        stackView.spacing = 15
        
        view.addSubview(stackView)
        stackView.topToSuperview(offset: 40)
        stackView.bottomToSuperview(offset: -20)
        stackView.leadingToSuperview(offset: 20)
        stackView.trailingToSuperview(offset: 20)
    }
    
    private static func makeField(placeholder: String) -> UIUnderlinedTextField {
        let field = UIUnderlinedTextField()
        field.tintColor = AppColor.underline
        field.attributedPlaceholder = placeholder.set(style: Style.placeholderStyle)
        field.textColor = Style.textFieldStyle.color?.color
        field.font = Style.textFieldStyle.font?.font(size: Style.textFieldStyle.size)
        return field
    }
    
    private static func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.textColor = Style.labelStyle.color?.color
        label.font = Style.labelStyle.font?.font(size: Style.labelStyle.size)
        return label
    }
    
    private static func makeButton(text: String) -> UIButton {
        let button = UIButton()
        let styledText = text.set(style: Style.buttonTextStyle)
        button.setAttributedTitle(styledText, for: .normal)
        button.backgroundColor = AppColor.button
        button.layer.cornerRadius = 8
        return button
    }
    
    //MARK: Style
    private enum Style {
        static let placeholderStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.medium16
            $0.color = AppColor.placeholder
        }
        
        static let textFieldStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.medium16
            $0.color = AppColor.label
        }
        
        static let labelStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.semibold22
            $0.color = AppColor.label
        }
        
        static let buttonTextStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.semibold16
            $0.color = AppColor.buttonText
        }
    }
    
}
