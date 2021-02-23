//
//  RegistrationRowsView.swift
//  RecyclingStarter
//
//  Created by  Matvey on 21.02.2021.
//  Copyright © 2021 Borisov Matvei. All rights reserved.
//

import UIKit
import SwiftRichString
import TinyConstraints

class RegistrationRowsView: UIView {
    
    private let nameField: UIUnderlinedTextField
    private let emailField: UIUnderlinedTextField
    private let phoneField: UIUnderlinedTextField
    private let passwordField: UIUnderlinedTextField
    private let confirmPasField: UIUnderlinedTextField
    private let addressField: UIUnderlinedTextField
    private let officeField: UIUnderlinedTextField
    private let picker = UIPickerView()
    
    var regInfo: RegInfo {
        get { RegInfo(name: nameField.text,
                      email: emailField.text,
                      phone: phoneField.text,
                      pass: passwordField.text,
                      confirmPass: confirmPasField.text,
                      building: picker.selectedRow(inComponent: 0),
                      buildingName: addressField.text,
                      room: officeField.text)
        }
    }
    
    weak var textFieldDelegate: UITextFieldDelegate? {
        didSet {
            nameField.delegate = textFieldDelegate
            emailField.delegate = textFieldDelegate
            phoneField.delegate = textFieldDelegate
            confirmPasField.delegate = textFieldDelegate
            passwordField.delegate = textFieldDelegate
            addressField.delegate = textFieldDelegate
            officeField.delegate = textFieldDelegate
        }
    }
    
    weak var pickerDelegate: UIPickerViewDelegate? {
        didSet {
            picker.delegate = pickerDelegate
        }
    }
    weak var pickerDataSource: UIPickerViewDataSource? {
        didSet {
            picker.dataSource = pickerDataSource
        }
    }
    
    
    init() {
        self.nameField = Self.createField(placeholder: "Имя фамилия")
        self.emailField = Self.createField(placeholder: "e-mail")
        self.phoneField = Self.createField(placeholder: "Телефон")
        self.passwordField = Self.createField(placeholder: "Пароль")
        self.confirmPasField = Self.createField(placeholder: "Подтвердите пароль")
        self.addressField = Self.createField(placeholder: "Адресс здания")
        self.officeField = Self.createField(placeholder: "Номер офиса")
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }
    
    private func setupViews() {
        passwordField.isSecureTextEntry = true
        confirmPasField.isSecureTextEntry = true
        phoneField.keyboardType = .numberPad
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        self.addSubview(stackView)
        stackView.edgesToSuperview()
        
        stackView.addArrangedSubview(nameField)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(phoneField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(confirmPasField)
        stackView.addArrangedSubview(addressField)
        stackView.addArrangedSubview(officeField)
        
        stackView.spacing = 18
        
        addressField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPicker)))
    }
    
    private static func createField(placeholder: String) -> UIUnderlinedTextField {
        let field = UIUnderlinedTextField()
        field.tintColor = AppColor.underline
        field.attributedPlaceholder = placeholder.set(style: Style.placeholderStyle)
        field.textColor = Style.textFieldStyle.color?.color
        field.font = Style.textFieldStyle.font?.font(size: Style.textFieldStyle.size)
        field.height(40)
        return field
    }
    
    func reloadPicker() {
        picker.reloadAllComponents()
    }
    
    @objc func showPicker() {
        let toolbar = UIToolbar()
        toolbar.tintColor = AppColor.button
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(donePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton, doneButton], animated: false)
        toolbar.sizeToFit()
        addressField.inputAccessoryView = toolbar
        addressField.inputView = picker
        addressField.becomeFirstResponder()
    }
    
    @objc func donePicker() {
        if let address = pickerDelegate?.pickerView?(picker, titleForRow: picker.selectedRow(inComponent: 0), forComponent: 0) {
            addressField.text = address
        }
        print(picker.selectedRow(inComponent: 0))
        guard let vc = textFieldDelegate as? UIViewController else { return }
        vc.view.endEditing(true)
    }
}

struct RegInfo {
    var name: String?
    var email: String?
    var phone: String?
    var pass: String?
    var confirmPass: String?
    var building: Int?
    var buildingName: String?
    var room: String?
}
