//
//  AuthViewController.swift
//  RecyclingStarter
//
//  Created by  Matvey on 26.07.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit
import TinyConstraints
import SwiftRichString
import Alamofire
import SwiftSVG

class AuthViewController: UIViewController {
    
    private let emailField: UIUnderlinedTextField
    private let passwordField: UIUnderlinedTextField
    private let enterButton: UIButton
    private let enterLabel: UILabel
    private let fogotPassButton: UIButton
    private let noAccountLabel: UILabel
    private let singInButton: UIButton
    private let logoView: UIImageView
    let authService = AuthServices()
    
    private enum Style {
        static let placeholderStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.medium16
            $0.color = AppColor.placeholder
        }
        
        static let textStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.medium16
            $0.color = AppColor.label
        }
        
        static let labelStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.semibold16
            $0.color = AppColor.label
        }
        static let mainButtonStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.semibold16
            $0.color = AppColor.buttonText
        }
        
        static let additionalButtonStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.semibold12
            $0.color = AppColor.button
        }
        
        static let additionalLabelStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.regular12
            $0.color = AppColor.additionalLabel
        }
    }
    
    init() {
        self.emailField = Self.makeTextField(placeholder: "e-mail")
        self.passwordField = Self.makeTextField(placeholder: "password")
        self.enterButton = Self.makeButton(title: "Войти")
        self.enterLabel = Self.makeLabel(text: "Войти в систему:")
        self.fogotPassButton = Self.makeAdditionalButton(title: "Забыли пароль?")
        self.noAccountLabel = Self.makeAdditionLabel(text: "Нет аккаунта?")
        self.singInButton = Self.makeAdditionalButton(title: "Зарегистрироваться")
        self.logoView = Self.makeLogo()
        
        super.init(nibName: nil, bundle: nil)
        
        setupViews()
        setupDelegates()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupViews () {
        view.backgroundColor = AppColor.authBackground
        
        view.addSubview(logoView)
        logoView.topToSuperview(offset: 24, usingSafeArea: true)
        logoView.trailingToSuperview(offset: 24)
        
        let mainContainer = UIView()
        view.addSubview(mainContainer)
        mainContainer.leadingToSuperview(offset: 50)
        mainContainer.trailingToSuperview(offset: 50)
        mainContainer.topToSuperview()
        
        let contentContainer = UIView()
        contentContainer.addSubview(enterLabel)
        contentContainer.addSubview(emailField)
        contentContainer.addSubview(passwordField)
        contentContainer.addSubview(fogotPassButton)
        
        mainContainer.addSubview(contentContainer)
        contentContainer.centerYToSuperview()
        contentContainer.widthToSuperview()
        
        enterLabel.topToSuperview()
        enterLabel.leadingToSuperview()
        enterLabel.trailingToSuperview(offset: 0, relation: .equalOrGreater)
        
        emailField.topToBottom(of: enterLabel, offset: 30)
//        emailField.widthToSuperview()
        emailField.centerXToSuperview()
        
        passwordField.topToBottom(of: emailField, offset: 35)
        passwordField.widthToSuperview()
        
        fogotPassButton.topToBottom(of: passwordField, offset: 25)
        fogotPassButton.trailingToSuperview()
        fogotPassButton.leadingToSuperview(offset: 0, relation: .equalOrGreater)
        fogotPassButton.bottomToSuperview()
        
        view.addSubview(enterButton)
        enterButton.topToBottom(of: mainContainer)
        enterButton.leadingToSuperview(offset: 50)
        enterButton.trailingToSuperview(offset: 50)
        
        let bottonStackView = UIStackView()
        view.addSubview(bottonStackView)
        bottonStackView.axis = .horizontal
        bottonStackView.distribution = .equalSpacing
        
        bottonStackView.addArrangedSubview(noAccountLabel)
        bottonStackView.addArrangedSubview(singInButton)
        bottonStackView.topToBottom(of: enterButton, offset: 35)
        bottonStackView.centerXToSuperview()
        bottonStackView.bottomToSuperview(offset: -32)
    }
    
    func setupDelegates() {
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    func setupActions() {
        enterButton.addTarget(self, action: #selector(authRequest), for: .touchUpInside)
    }
    
    @objc func authRequest() {
        guard let email = emailField.text, let password = passwordField.text else {
            print("not enouth info")
            return
        }
        authService.autharisation(email: email, password: password) { (user) in
            if user.result == "success"{
                let employeeVC = EmployeeViewController(user: user)
                UIApplication.shared.keyWindow?.rootViewController = employeeVC
            } else {
                self.setFieldsColor(isError: true)
                self.emailField.shake()
                self.passwordField.shake()
            }
        }
    }
    
}

extension AuthViewController {
    private static func makeTextField(placeholder: String) -> UIUnderlinedTextField{
        let textField = UIUnderlinedTextField()
        textField.style = Style.textStyle
        textField.font = Style.textStyle.font?.font(size: Style.textStyle.size)
        textField.textColor = Style.textStyle.color?.color
        textField.attributedPlaceholder = placeholder.set(style: Style.placeholderStyle)
        textField.textAlignment = .left
        textField.tintColor = AppColor.placeholder
        textField.width(UIScreen.main.bounds.width - 100)
        return textField
    }
    
    private static func makeButton(title: String) -> UIButton{
        let button = UIButton(type: .system)
        let styledTitle = title.set(style: Style.mainButtonStyle)
        button.setAttributedTitle(styledTitle, for: .normal)
        button.height(50)
        button.layer.cornerRadius = 8
        button.backgroundColor = AppColor.button
        return button
    }
    
    private static func makeAdditionalButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        let styledTitle = title.set(style: Style.additionalButtonStyle)
        button.setAttributedTitle(styledTitle, for: .normal)
        button.height(16)
        return button
    }
    
    private static func makeLogo() -> UIImageView{
        let logo = AppImage.logo
        let imageView = UIImageView(image: logo)
        return imageView
    }
    
    private static func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.attributedText = text.set(style: Style.labelStyle)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }
    
    private static func makeAdditionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.attributedText = text.set(style: Style.additionalLabelStyle)
        label.numberOfLines = 1
        return label
    }
    
    private func setFieldsColor(isError: Bool) {
        if isError {
            emailField.tintColor = AppColor.error
            emailField.textColor = AppColor.error
            passwordField.tintColor = AppColor.error
            passwordField.textColor = AppColor.error
        } else {
            emailField.tintColor = AppColor.placeholder
            emailField.textColor = AppColor.label
            passwordField.tintColor = AppColor.placeholder
            passwordField.textColor = AppColor.label
        }
    }
}

//MARK: UITextFieldDelegate
extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.setFieldsColor(isError: false)
        }
    }
}
