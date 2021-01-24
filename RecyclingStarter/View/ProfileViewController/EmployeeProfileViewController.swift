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
    private lazy var emailInfoView = TitledInfoView(title: "e-mail", text: "", textPlaceholder: userData.email)
    private lazy var nameInfoView = TitledInfoView(title: "Имя", text: "\(userData.firstName)", textPlaceholder: "Иван Иванович")
    private lazy var phoneInfoView = TitledInfoView(title: "Телефон", text: "\(userData.phone)", textPlaceholder: "\(userData.phone)")
    private lazy var locationInfoView = TitledInfoView(title: "Локация", text: "\(userData.room)", textPlaceholder: "Возле лестницы")
    private lazy var oldPassInfoView = TitledInfoView(title: "Старый пароль", text: "", textPlaceholder: "********")
    private lazy var passInfoView = TitledInfoView(title: "Пароль", text: "", textPlaceholder: "********")
    private lazy var confirmPassInfoView = TitledInfoView(title: "Подтвердите пароль", text: "", textPlaceholder: "********")
    private lazy var saveDataButton = Self.createButton(title: "Сохранить")
    private lazy var savePassButton = Self.createButton(title: "Сменить пароль")
    private lazy var logoutButton = Self.createLogoutButton(title: "Выйти")
    
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
    }
    
    init(userData: UserData) {
        self.userData = userData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        view.backgroundColor = AppColor.authBackground
        
        view.addSubview(scrollView)
        scrollView.edgesToSuperview(excluding: .bottom)
        scrollView.bottomToSuperview(usingSafeArea: true)
        
        let containerView = UIView()
        scrollView.addSubview(containerView)
        containerView.edgesToSuperview()
        containerView.width(view.frame.width)
        
        let stackView = UIStackView(arrangedSubviews: [emailInfoView, nameInfoView, phoneInfoView, locationInfoView, saveDataButton, oldPassInfoView, passInfoView, confirmPassInfoView, savePassButton, logoutButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        containerView.addSubview(stackView)
        stackView.topToSuperview(offset: 28)
        stackView.leadingToSuperview(offset: 46)
        stackView.trailingToSuperview(offset: 46)
        stackView.bottomToSuperview(offset: -32)
        
        scrollView.gestureRecognizers?.forEach {
            $0.delaysTouchesBegan = true; $0.cancelsTouchesInView = false
        }
    }
    
    private func setupSubviews() {
        oldPassInfoView.textField.isSecureTextEntry = true
        passInfoView.textField.isSecureTextEntry = true
        confirmPassInfoView.textField.isSecureTextEntry = true
    }
    
    private static func createButton(title: String) -> styledButton {
        let button = styledButton(type: .system)
        let styledTitle = title.set(style: Style.buttonStyle)
        button.setAttributedTitle(styledTitle, for: .normal)
        button.height(50)
        button.layer.cornerRadius = 8
        button.backgroundColor = AppColor.button
        return button
    }
    
    private static func createLogoutButton(title: String) -> styledButton {
        let button = Self.createButton(title: title)
        button.backgroundColor = AppColor.error
        return button
    }
}
