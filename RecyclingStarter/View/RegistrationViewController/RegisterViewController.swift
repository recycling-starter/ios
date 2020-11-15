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
    private let closeButton: UIButton
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.nameField = Self.makeField(placeholder: "Имя")
        self.surnameField = Self.makeField(placeholder: "Фамилия")
        self.emailField = Self.makeField(placeholder: "e-mail")
        self.phoneField = Self.makeField(placeholder: "phone")
        self.passwordField = Self.makeField(placeholder: "Пароль")
        self.adressField = Self.makeField(placeholder: "Адресс здания")
        self.officeField = Self.makeField(placeholder: "Номер офиса")
        self.codeField = Self.makeField(placeholder: "Код регистрации")
        self.regLabel = Self.makeLabel(text: "Регистрация")
        self.regButton = Self.makeButton(text: "Зарегистрироваться")
        self.closeButton = Self.makeCloseButton()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupDelegate()
        setupActions()
    }
    
    func setupViews() {
        view.backgroundColor = AppColor.authBackground
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        stackView.addArrangedSubview(nameField)
        stackView.addArrangedSubview(surnameField)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(phoneField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(adressField)
        stackView.addArrangedSubview(officeField)
        stackView.addArrangedSubview(codeField)
        
        stackView.spacing = 15
        
        view.addSubview(closeButton)
        closeButton.topToSuperview(offset: 36, usingSafeArea: true)
        closeButton.leadingToSuperview(offset: 20)
        closeButton.width(40)
        closeButton.height(40)
        
        view.addSubview(regLabel)
//        regLabel.topToSuperview(offset: 36)
//        regLabel.leadingToSuperview(offset: 46)
        regLabel.centerY(to: closeButton)
        regLabel.leadingToTrailing(of: closeButton, offset: 5)
        
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        view.addSubview(scrollView)
        scrollView.topToBottom(of: regLabel, offset: 20)
        scrollView.leadingToSuperview(offset: 30)
        scrollView.trailingToSuperview(offset: 30)
        
        view.addSubview(regButton)
        regButton.width(to: scrollView)
        regButton.centerXToSuperview()
        regButton.topToBottom(of: scrollView, offset: 10)
        regButton.bottomToSuperview(offset: -20, usingSafeArea: true)
        
        scrollView.addSubview(stackView)
        
        stackView.topToSuperview()
        stackView.bottomToSuperview()
        stackView.leadingToSuperview()
        stackView.width(to: scrollView)
    }
    
    private func setupDelegate() {
        nameField.delegate = self
        surnameField.delegate = self
        emailField.delegate = self
        phoneField.delegate = self
        passwordField.delegate = self
        adressField.delegate = self
        officeField.delegate = self
        codeField.delegate = self
    }
    
    //MARK: Make UI elemets
    private static func makeField(placeholder: String) -> UIUnderlinedTextField {
        let field = UIUnderlinedTextField()
        field.tintColor = AppColor.underline
        field.attributedPlaceholder = placeholder.set(style: Style.placeholderStyle)
        field.textColor = Style.textFieldStyle.color?.color
        field.font = Style.textFieldStyle.font?.font(size: Style.textFieldStyle.size)
        field.height(40)
        return field
    }
    
    private static func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.textColor = Style.labelStyle.color?.color
        label.font = Style.labelStyle.font?.font(size: Style.labelStyle.size)
        label.attributedText = text.set(style: Style.labelStyle)
        return label
    }
    
    private static func makeButton(text: String) -> UIButton {
        let button = UIButton()
        let styledText = text.set(style: Style.buttonTextStyle)
        button.setAttributedTitle(styledText, for: .normal)
        button.backgroundColor = AppColor.button
        button.layer.cornerRadius = 8
        button.height(51)
        return button
    }
    
    private static func makeCloseButton() -> UIButton {
        let button = UIButton()
        let image = AppImage.logoutImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = AppColor.label
        button.imageView?.transform = CGAffineTransform(rotationAngle: .pi)
        button.imageView?.height(28)
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
    
    //MARK: Actions
    private func setupActions() {
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    }
    
    @objc private func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
