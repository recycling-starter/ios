//
//  ResetPasswordViewController.swift
//  RecyclingStarter
//
//  Created by  Matvey on 26.02.2021.
//  Copyright © 2021 Borisov Matvei. All rights reserved.
//

import UIKit
import TinyConstraints
import SwiftRichString

class ResetPasswordViewController: UIViewController {
    
    private let resetLabel: UILabel
    private let resetButton: UIButton
    private let closeButton: UIButton
    private let emailTextField = UserInfoTextField()
    private let userService = UserServices()
    
    init() {
        self.resetLabel = Self.createLabel(text: "Восстановить пароль")
        self.resetButton = Self.createButton(text: "Отправить ссылку")
        self.closeButton = Self.createCloseButton()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupViews()
        setupActions()
    }
    
    private func setupViews() {
        emailTextField.delegate = self
        
        view.backgroundColor = AppColor.authBackground
        
        view.addSubview(closeButton)
        closeButton.topToSuperview(offset: 36, usingSafeArea: true)
        closeButton.leadingToSuperview(offset: 20)
        closeButton.width(40)
        closeButton.height(40)
        
        view.addSubview(resetLabel)
        resetLabel.centerY(to: closeButton)
        resetLabel.leadingToTrailing(of: closeButton, offset: 5)
        
        view.addSubview(emailTextField)
        emailTextField.styledPlaceholder = "E-mail"
        emailTextField.centerYToSuperview()
        emailTextField.leadingToSuperview(offset: 35)
        emailTextField.trailingToSuperview(offset: 35)
        
        view.addSubview(resetButton)
        resetButton.topToBottom(of: emailTextField, offset: 25)
        resetButton.centerXToSuperview()
        resetButton.width(to: emailTextField)
        
    }
    
    //MARK: Create UI elemets
    private static func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.textColor = Style.labelStyle.color?.color
        label.font = Style.labelStyle.font?.font(size: Style.labelStyle.size)
        label.attributedText = text.set(style: Style.labelStyle)
        return label
    }
    
    private static func createButton(text: String) -> UIButton {
        let button = UIButton()
        let styledText = text.set(style: Style.buttonTextStyle)
        button.setAttributedTitle(styledText, for: .normal)
        button.setBackgroundImage(AppImage.buttonMain, for: .normal)
        button.setBackgroundImage(AppImage.buttonMain?.alpha(0.8), for: .selected)
        button.setBackgroundImage(AppImage.buttonMain?.alpha(0.8), for: .highlighted)
        button.setBackgroundImage(AppImage.buttonMain?.alpha(0.8), for: .disabled)
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.height(51)
        return button
    }
    
    private static func createCloseButton() -> UIButton {
        let button = UIButton()
        let image = AppImage.returnImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = AppColor.label
        button.imageView?.transform = CGAffineTransform(rotationAngle: .pi)
        button.imageView?.height(28)
        return button
    }
    
    //MARK: Style
    private enum Style {
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

//MARK: UITextFieldDelegate
extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//MARK: Actions
extension ResetPasswordViewController {
    private func setupActions() {
        closeButton.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
    }
    
    @objc private func closeVC() {
        self.dismiss(animated: true)
    }
    
    @objc private func resetPassword() {
        userService.resetPassword(email: emailTextField.text ?? "") { (isSuccess) in
            self.showSuccessAlert()
        }
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(title: "Успешно", message: "Ссылка для сброса пароля отправлена на ваш email", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ок", style: .default) { (_) in
            self.closeVC()
        }
        alert.view.tintColor = AppColor.button
        alert.addAction(actionOk)
        present(alert, animated: true)
    }
}
