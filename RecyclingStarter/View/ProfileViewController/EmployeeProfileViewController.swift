//
//  ProfileViewController.swift
//  RecyclingStarter
//
//  Created by  Matvey on 09.01.2021.
//  Copyright © 2021 Borisov Matvei. All rights reserved.
//

import UIKit
import TinyConstraints
import SwiftRichString

class EmployeeProfileViewController: UIViewController {
    
    private var userData: UserData
    private var scrollView = UIScrollView()
    let containerView = UIView()
    private lazy var emailInfoView = TitledInfoView(title: "e-mail", text: "", textPlaceholder: userData.email)
    private lazy var nameInfoView = TitledInfoView(title: "Имя", text: "\(userData.firstName)", textPlaceholder: "Иван Иванович")
    private lazy var phoneInfoView = TitledInfoView(title: "Телефон", text: "\(userData.phone)", textPlaceholder: "\(userData.phone)")
    private lazy var roomInfoView = TitledInfoView(title: "Локация", text: "\(userData.room)", textPlaceholder: "Возле лестницы")
    private lazy var oldPassInfoView = TitledInfoView(title: "Старый пароль", text: "", textPlaceholder: "********")
    private lazy var newPassInfoView = TitledInfoView(title: "Пароль", text: "", textPlaceholder: "********")
    private lazy var confirmNewPassInfoView = TitledInfoView(title: "Подтвердите пароль", text: "", textPlaceholder: "********")
    private lazy var saveDataButton = Self.createButton(title: "Сохранить")
    private lazy var savePassButton = Self.createButton(title: "Сменить пароль")
    private lazy var logoutButton = Self.createLogoutButton(title: "Выйти")
    private var bottomScrollViewConstraint: Constraint? = nil
    
    let accountService = LocalStorageServices()
    let userService = UserServices()
    let router = Router()
    let token: String
    
    private enum Style {
        static let buttonStyle: SwiftRichString.Style = .init {
            $0.font = AppFont.semibold16
            $0.color = AppColor.buttonText
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupSubviews()
        setupActions()
        registerForKeyboardNotification()
    }
    
    init(userData: UserData, token: String) {
        self.userData = userData
        self.token = token
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeKeyboardNotification()
    }
    
    private func setupLayout() {
        view.backgroundColor = AppColor.authBackground
        
        view.addSubview(scrollView)
        scrollView.edgesToSuperview(excluding: .bottom)
        bottomScrollViewConstraint = scrollView.bottomToSuperview(usingSafeArea: true)
        
        scrollView.addSubview(containerView)
        containerView.edgesToSuperview()
        containerView.width(view.frame.width)
        
        let stackView = UIStackView(arrangedSubviews: [emailInfoView, nameInfoView, phoneInfoView, roomInfoView, saveDataButton, oldPassInfoView, newPassInfoView, confirmNewPassInfoView, savePassButton, logoutButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        containerView.addSubview(stackView)
        stackView.topToSuperview(offset: 28)
        stackView.leadingToSuperview(offset: 32)
        stackView.trailingToSuperview(offset: 32)
        stackView.bottomToSuperview(offset: -32)
        
        scrollView.delaysContentTouches = true
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupSubviews() {
        emailInfoView.isUserInteractionEnabled = false
        oldPassInfoView.textField.isSecureTextEntry = true
        newPassInfoView.textField.isSecureTextEntry = true
        confirmNewPassInfoView.textField.isSecureTextEntry = true
        
        nameInfoView.textField.delegate = self
        phoneInfoView.textField.delegate = self
        roomInfoView.textField.delegate = self
        oldPassInfoView.textField.delegate = self
        newPassInfoView.textField.delegate = self
        confirmNewPassInfoView.textField.delegate = self
        
        phoneInfoView.textField.keyboardType = .phonePad
    }
    
    private static func createButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        let styledTitle = title.set(style: Style.buttonStyle)
        button.setAttributedTitle(styledTitle, for: .normal)
        button.height(50)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.setBackgroundImage(AppImage.buttonMain, for: .normal)
        button.setBackgroundImage(AppImage.buttonMain?.alpha(0.8), for: .selected)
        button.setBackgroundImage(AppImage.buttonMain?.alpha(0.8), for: .highlighted)
        button.setBackgroundImage(AppImage.buttonMain?.alpha(0.8), for: .disabled)
        return button
    }
    
    private static func createLogoutButton(title: String) -> UIButton {
        let button = Self.createButton(title: title)
        button.setBackgroundImage(AppImage.errorColor, for: .normal)
        button.setBackgroundImage(AppImage.errorColor?.alpha(0.8), for: .selected)
        button.setBackgroundImage(AppImage.errorColor?.alpha(0.8), for: .highlighted)
        button.setBackgroundImage(AppImage.errorColor?.alpha(0.8), for: .disabled)
        return button
    }
}


//MARK: Setup Actions
extension EmployeeProfileViewController {
    private func setupActions() {
        savePassButton.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        saveDataButton.addTarget(self, action: #selector(changeUserInfo), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    @objc private func logout() {
        accountService.logoutUser {
            DispatchQueue.main.async { [weak self] in
                self?.router.presentAuthVC()
            }
        }
    }
    
    @objc private func changeUserInfo() {
        saveDataButton.isEnabled = false
        guard isVerifyInfoFields() else {
            self.saveDataButton.isEnabled = true
            return
        }
        let name = nameInfoView.textField.text
        let photeString = phoneInfoView.textField.text
        let room = roomInfoView.textField.text
        userService.updateUserData(firstName: name, phone: photeString, room: room) { (newUserData) in
            if let newUserData = newUserData {
                let alert = UIAlertController(title: "Успешно", message: "Данные изменены", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Oк", style: .default)
                alert.view.tintColor = AppColor.button
                alert.addAction(okAction)
                self.present(alert, animated: true)
                self.nameInfoView.textField.styledText = newUserData.firstName
                self.phoneInfoView.textField.styledText = "\(String(describing: newUserData.phone))"
                self.roomInfoView.textField.styledText = newUserData.room
            } else {
                let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Oк", style: .default)
                alert.view.tintColor = AppColor.button
                alert.addAction(okAction)
                self.present(alert, animated: true)
            }
            self.saveDataButton.isEnabled = true
        }
    }
    
    @objc private func changePassword() {
        savePassButton.isEnabled = false
        guard isVerifyPasswordFields(),
              let oldPass = oldPassInfoView.textField.text,
              let newPass = newPassInfoView.textField.text
        else {
            savePassButton.isEnabled = true
            return
        }
        
        userService.updateUserPassword(oldPassword: oldPass, newPassword: newPass) { (passData) in
            if let _ = passData?.status {
                self.accountService.saveUserInfo(email: self.userData.email, password: newPass)
                let alert = UIAlertController(title: "Успешно", message: "Пароль изменен", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Oк", style: .default)
                alert.view.tintColor = AppColor.button
                alert.addAction(okAction)
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Ошибка", message: "Введен неверный пароль", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Oк", style: .default)
                alert.view.tintColor = AppColor.button
                alert.addAction(okAction)
                self.oldPassInfoView.textField.errorSignalize()
                self.newPassInfoView.textField.errorSignalize()
                self.confirmNewPassInfoView.textField.errorSignalize()
                self.present(alert, animated: true)
            }
            self.savePassButton.isEnabled = true
        }
    }
    
    private func isVerifyPasswordFields() -> Bool {
        guard var oldPass = oldPassInfoView.textField.text,
              var newPass = newPassInfoView.textField.text,
              var confirmNewPass = confirmNewPassInfoView.textField.text else { return false }
        oldPass = oldPass.trimmingCharacters(in: .whitespacesAndNewlines)
        newPass = newPass.trimmingCharacters(in: .whitespacesAndNewlines)
        confirmNewPass = confirmNewPass.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if oldPass == "" && newPass == "" && confirmNewPass == "" {
            let alert = UIAlertController(title: "Ошибка", message: "Поля должны быть заполнены", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Oк", style: .default)
            alert.view.tintColor = AppColor.button
            alert.addAction(okAction)
            present(alert, animated: true)
            return false
        } else if newPass != confirmNewPass {
            let alert = UIAlertController(title: "Ошибка", message: "Пароли должны совпадать", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Oк", style: .default)
            alert.view.tintColor = AppColor.button
            alert.addAction(okAction)
            newPassInfoView.textField.errorSignalize()
            confirmNewPassInfoView.textField.errorSignalize()
            present(alert, animated: true)
            return false
        }
        return true
    }
    
    private func isVerifyInfoFields() -> Bool {
        guard var name = nameInfoView.textField.text,
              var phone = phoneInfoView.textField.text,
              var room = roomInfoView.textField.text else { return false }
        
        name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        phone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        room = room.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if name == "" || phone == "" || room == "" {
            let alert = UIAlertController(title: "Ошибка", message: "Поля не должны быть пустыми", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Oк", style: .default)
            alert.view.tintColor = AppColor.button
            alert.addAction(okAction)
            nameInfoView.textField.errorSignalize()
            phoneInfoView.textField.errorSignalize()
            roomInfoView.textField.errorSignalize()
            present(alert, animated: true)
            return false
        } else if Int(phone) == nil {
            let alert = UIAlertController(title: "Ошибка", message: "Телефон может состоять только из цифр", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Oк", style: .default)
            alert.view.tintColor = AppColor.button
            alert.addAction(okAction)
            nameInfoView.textField.errorSignalize()
            phoneInfoView.textField.errorSignalize()
            roomInfoView.textField.errorSignalize()
            present(alert, animated: true)
        }
        return true
    }
}

extension EmployeeProfileViewController: UITextFieldDelegate {
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let kbAnimationTime = (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let kbCurve = (userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue ?? 0
        let animator = UIViewPropertyAnimator(duration: kbAnimationTime, curve: UIView.AnimationCurve(rawValue: Int(kbCurve))!) { [weak self] in
            self?.bottomScrollViewConstraint?.constant = -((kbFrameSize?.height ?? 0) - (self?.tabBarController?.tabBar.frame.height ?? 0))
            self?.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    @objc private func keyboardHide() {
        bottomScrollViewConstraint?.constant = 0
    }
    
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == oldPassInfoView.textField || textField == newPassInfoView.textField || textField == confirmNewPassInfoView.textField {
            oldPassInfoView.textField.cleanErrorSignalize()
            newPassInfoView.textField.cleanErrorSignalize()
            confirmNewPassInfoView.textField.cleanErrorSignalize()
        } else {
            nameInfoView.textField.cleanErrorSignalize()
            phoneInfoView.textField.cleanErrorSignalize()
            roomInfoView.textField.cleanErrorSignalize()
        }
    }
}
