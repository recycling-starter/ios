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

class AuthViewController: UIViewController {
    
    private let emailField: UserInfoTextField
    private let passwordField: UserInfoTextField
    private let enterButton: styledButton
    private let enterLabel: UILabel
    private let fogotPassButton: UIButton
    private let noAccountLabel: UILabel
    private let singInButton: UIButton
    private let logoView: UIImageView
    
    private let authService = AuthServices()
    private let localStorageService = LocalStorageServices()
    private let router = Router()
    
    
    // MARK: Styles
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
        self.emailField = LoginTextField()
        self.passwordField = PasswordTextField()
        self.enterButton = Self.createButton(title: "Войти")
        self.enterLabel = Self.createLabel(text: "Войти в систему:")
        self.fogotPassButton = Self.createAdditionalButton(title: "Забыли пароль?")
        self.noAccountLabel = Self.createAdditionLabel(text: "Нет аккаунта?")
        self.singInButton = Self.createAdditionalButton(title: "Зарегистрироваться")
        self.logoView = Self.createLogo()
        
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
    
    // MARK: Setup View
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
        emailField.widthToSuperview()
        
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
        singInButton.addTarget(self, action: #selector(goToRegistration), for: .touchUpInside)
    }

}

// MARK: Button actions
extension AuthViewController {
    @objc func authRequest() {
        enterButton.isEnabled = false
        guard let email = emailField.text, let password = passwordField.text else {
            enterButton.isEnabled = true
            return
        }
        
        authService.autharisation(email: email, password: password) { (userData, token) in
            if let userData = userData{
                self.router.presentEmployeeScreens(token: token, userData: userData)
                self.localStorageService.saveUserInfo(email: email, password: password)
            } else {
                self.emailField.errorSignalize()
                self.passwordField.errorSignalize()
            }
            self.enterButton.isEnabled = true
        }
    }
    
    @objc private func goToRegistration() {
        let vc = RegisterViewController()
        self.present(vc, animated: true, completion: nil)
    }
}


// MARK: Setup UI elements
extension AuthViewController {
    
    private static func createButton(title: String) -> styledButton{
        let button = styledButton(type: .system)
        let styledTitle = title.set(style: Style.mainButtonStyle)
        button.setAttributedTitle(styledTitle, for: .normal)
        button.height(50)
        button.layer.cornerRadius = 8
        button.backgroundColor = AppColor.button
        return button
    }
    
    private static func createAdditionalButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        let styledTitle = title.set(style: Style.additionalButtonStyle)
        button.setAttributedTitle(styledTitle, for: .normal)
        button.height(16)
        return button
    }
    
    private static func createLogo() -> UIImageView{
        let logo = AppImage.logo
        let imageView = UIImageView(image: logo)
        return imageView
    }
    
    private static func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.attributedText = text.set(style: Style.labelStyle)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }
    
    private static func createAdditionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.attributedText = text.set(style: Style.additionalLabelStyle)
        label.numberOfLines = 1
        return label
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
        self.emailField.cleanErrorSignalize()
        self.passwordField.cleanErrorSignalize()
    }
}

class styledButton: UIButton {
    override open var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? AppColor.button : AppColor.buttomUnavailable
        }
    }
}
