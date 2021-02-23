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
    
    private let regLabel: UILabel
    private let regButton: UIButton
    private let closeButton: UIButton
    private let regRowsView = RegistrationRowsView()
    private var bottomConstraint: Constraint?
    
    private let registrationService = RegistrationService()
    
    var buildingsList: [String] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.regLabel = Self.createLabel(text: "Регистрация")
        self.regButton = Self.createButton(text: "Зарегистрироваться")
        self.closeButton = Self.createCloseButton()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupActions()
        registerForKeyboardNotification()
        loadBuildings()
    }
    
    deinit {
        removeKeyboardNotification()
    }
    
    func setupViews() {
        regRowsView.textFieldDelegate = self
        regRowsView.pickerDelegate = self
        regRowsView.pickerDataSource = self
        
        view.backgroundColor = AppColor.authBackground
        
        view.addSubview(closeButton)
        closeButton.topToSuperview(offset: 36, usingSafeArea: true)
        closeButton.leadingToSuperview(offset: 20)
        closeButton.width(40)
        closeButton.height(40)
        
        view.addSubview(regLabel)
        regLabel.centerY(to: closeButton)
        regLabel.leadingToTrailing(of: closeButton, offset: 5)
        
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        view.addSubview(scrollView)
        scrollView.topToBottom(of: regLabel, offset: 20)
        scrollView.leadingToSuperview(offset: 16)
        scrollView.trailingToSuperview(offset: 16)
        
        view.addSubview(regButton)
        regButton.width(to: scrollView)
        regButton.centerXToSuperview()
        regButton.topToBottom(of: scrollView, offset: 10)
        bottomConstraint = regButton.bottomToSuperview(offset: -20, usingSafeArea: true)
        
        scrollView.addSubview(regRowsView)
        regRowsView.edgesToSuperview()
        regRowsView.width(to: scrollView)
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
        let image = AppImage.logoutImage?.withRenderingMode(.alwaysTemplate)
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
    
    //MARK: Actions
    private func setupActions() {
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        regButton.addTarget(self, action: #selector(registration), for: .touchUpInside)
    }
    
    @objc private func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func loadBuildings() {
        registrationService.getBuildingsList { (list) in
            self.buildingsList = list
            self.regRowsView.reloadPicker()
        }
    }
    
    @objc private func registration() {
        regButton.isEnabled = false
        let info = regRowsView.regInfo
        print(info)
        if !registrationService.isVerifidePass(pass: info.pass,
                                              confirmPass: info.confirmPass) {
            let alert = UIAlertController(title: "Ошибка", message: "Пароли должны совпадать", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ок", style: .default)
            alert.view.tintColor = AppColor.button
            alert.addAction(okAction)
            regButton.isEnabled = true
            present(alert, animated: true)
            return
        }
        if !registrationService.isVerifideInfo(name: info.name, email: info.email, phone: info.phone, pass: info.pass, building: info.building, buildingName: info.buildingName, room: info.room) {
            let alert = UIAlertController(title: "Ошибка", message: "Все поля должны быть заполнены", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ок", style: .default)
            alert.view.tintColor = AppColor.button
            alert.addAction(okAction)
            regButton.isEnabled = true
            present(alert, animated: true)
            return
        }
        
        registrationService.registerNewUser(name: info.name, email: info.email, phone: info.phone, pass: info.pass, building: info.building, room: info.room) { (isSuccess) in
            if isSuccess {
                let alert = UIAlertController(title: "Успешно", message: "Подтвердите аккаунт на почте", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "ок", style: .default) { (_) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.view.tintColor = AppColor.button
                alert.addAction(okAction)
                self.regButton.isEnabled = true
                self.present(alert, animated: true)
                return
            } else {
                let alert = UIAlertController(title: "Ошибка", message: "Во время регистрации произошла ошибка", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "ок", style: .default)
                alert.view.tintColor = AppColor.button
                alert.addAction(okAction)
                self.regButton.isEnabled = true
                self.present(alert, animated: true)
                return
            }
        }
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
            self?.bottomConstraint?.constant = -((kbFrameSize?.height ?? 0) + 10.0)
            self?.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    @objc private func keyboardHide(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbAnimationTime = (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let kbCurve = (userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue ?? 0
        let animator = UIViewPropertyAnimator(duration: kbAnimationTime, curve: UIView.AnimationCurve(rawValue: Int(kbCurve))!) { [weak self] in
            self?.bottomConstraint?.constant = -20
            self?.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

//MARK: UIPickerViewDelegate, UIPickerViewDataSource
extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        buildingsList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        buildingsList[row]
    }
}
