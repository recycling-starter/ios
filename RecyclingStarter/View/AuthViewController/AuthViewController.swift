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
    
    let emailField = UIUnderlinedTextField()
    let passwordField = UIUnderlinedTextField()
    let enterButton = UIButton(type: .system)
    let enterLabel = UILabel()
    let authService = AuthServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        setupDelegates()
        
        setupActions()
    }
    
    func setupViews () {
        view.backgroundColor = AppColor.authBackground
        
        enterButton.backgroundColor = AppColor.button
        let title = NSAttributedString(string: "Enter")
        enterButton.setAttributedTitle(title, for: .normal)
        enterButton.titleLabel?.textColor = AppColor.buttonText
        
        enterLabel.text = "Enter"
        enterLabel.textColor = AppColor.label
        enterLabel.textAlignment = .left
        
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        
        stackView.addArrangedSubview(enterLabel)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(enterButton)
        
        view.addSubview(stackView)
        stackView.topToSuperview(offset: 50)
        stackView.leadingToSuperview(offset: 30)
        stackView.trailingToSuperview(offset: 30)
        stackView.bottomToSuperview(offset: -50)
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
        authService.autharisation(email: email, password: password) { (response) in
            print(response)
        }
//        NetworkRequest().re()
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
}
