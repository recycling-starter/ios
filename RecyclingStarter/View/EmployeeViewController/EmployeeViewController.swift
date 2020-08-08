//
//  EmployeeViewController.swift
//  RecyclingStarter
//
//  Created by  Matvey on 27.07.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit
import TinyConstraints
import SwiftRichString

class EmployeeViewController: UIViewController {
    
    let user: User
    private var boxFilling = boxStates.state0
    
    private let infoView = UIView()
    private let minusButton: UIButton
    private let plusButton: UIButton
    private let boxLabel: UILabel
    private let statusLabel: UILabel
//    private let persentLabel: UILabel
    
    private var gradientLayer0 = CAGradientLayer()
    private var gradientLayer25 = CAGradientLayer()
    private var gradientLayer50 = CAGradientLayer()
    private var gradientLayer75 = CAGradientLayer()
    private var gradientLayer100 = CAGradientLayer()
    
    private enum boxGradient {
        
        static let state0 = (AppColor.boxState0Up ?? .white, AppColor.boxState0Down ?? .white)
        
        static let state25 = (AppColor.boxState25Up ?? .white, AppColor.boxState25Down ?? .white)
        
        static let state50 = (AppColor.boxState50Up ?? .white, AppColor.boxState50Down ?? .white)
        
        static let state75 = (AppColor.boxState75Up ?? .white, AppColor.boxState75Down ?? .white)
        
        static let state100 = (AppColor.boxState100Up ?? .white, AppColor.boxState100Down ?? .white)
    }
    
    private enum boxStates: Int {
        case state0 = 0
        case state25 = 25
        case state50 = 50
        case state75 = 75
        case state100 = 100
    }
    
    private enum Style {
        static let button: SwiftRichString.Style = .init {
            $0.font = AppFont.semibold40
            $0.color = AppColor.label
        }
        
        static let boxLabel: SwiftRichString.Style = .init {
            $0.font = AppFont.semibold24
            $0.color = AppColor.label
        }
    }
    
    init(user: User) {
        self.user = user
        self.plusButton = Self.makeButton(isPlus: true)
        self.minusButton = Self.makeButton(isPlus: false)
        self.boxLabel = Self.makeBoxLabel()
        self.statusLabel = Self.makeStatusLabel()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupButtonActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.gradientLayer100 = makeGradient(state: .state100)
        self.gradientLayer75 = makeGradient(state: .state75)
        self.gradientLayer50 = makeGradient(state: .state50)
        self.gradientLayer25 = makeGradient(state: .state25)
        self.gradientLayer0 = makeGradient(state: .state0)
    }
    
    
    // MARK: Setup View
    func setupViews() {
        
        let buttonsStackView = UIStackView()
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .equalSpacing
        
        buttonsStackView.addArrangedSubview(minusButton)
//        buttonsStackView.addArrangedSubview(persentLabel)
        buttonsStackView.addArrangedSubview(plusButton)
        
        let infoStackView = UIStackView()
        infoStackView.axis = .vertical
        infoStackView.distribution = .equalSpacing
        
        infoStackView.addArrangedSubview(boxLabel)
        infoStackView.addArrangedSubview(statusLabel)
        infoStackView.addArrangedSubview(buttonsStackView)
        
        view.addSubview(infoView)
        infoView.backgroundColor = .white
        infoView.leadingToSuperview(offset: 20)
        infoView.trailingToSuperview(offset: 20)
        infoView.bottomToSuperview(offset: -20)
        infoView.height(200)
        
        infoView.addSubview(infoStackView)
        infoStackView.edgesToSuperview(insets: .top(10) + .left(10) + .bottom(10) + .right(10))
        
        }
    
    private func makeGradient(state: boxStates) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.locations = [0.0, 1.0]
        gradient.frame = self.view.bounds
        gradient.opacity = 0
        switch state {
        case .state0:
            gradient.colors = [boxGradient.state0.0.cgColor, boxGradient.state0.1.cgColor]
            gradient.opacity = 1
        case .state25:
            gradient.colors = [boxGradient.state25.0.cgColor, boxGradient.state25.1.cgColor]
        case .state50:
            gradient.colors = [boxGradient.state50.0.cgColor, boxGradient.state50.1.cgColor]
        case .state75:
            gradient.colors = [boxGradient.state75.0.cgColor, boxGradient.state50.1.cgColor]
        case .state100:
            gradient.colors = [boxGradient.state100.0.cgColor, boxGradient.state100.1.cgColor]
        }
        self.view.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
    private static func makeBoxLabel() -> UILabel {
        let label = UILabel()
        label.attributedText = "Контейнер #1337".set(style: Style.boxLabel)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }
    
    private static func makeStatusLabel() -> UILabel {
        let label = UILabel()
        label.text = "ba + + NaN"
        label.font = AppFont.medium16
        return label
    }
    
    private static func makeButton(isPlus: Bool) -> UIButton {
        let button = UIButton(type: .system)
        var title: NSAttributedString
        if isPlus {
            title = "+".set(style: Style.button)
        } else {
            title = "-".set(style: Style.button)
        }
        button.setAttributedTitle(title, for: .normal)
        
        return button
    }
    
    
    // MARK: Setup Actions
    func setupButtonActions() {
        minusButton.addTarget(self, action: #selector(decreaseBoxFilling), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(increaseBoxFilling), for: .touchUpInside)
    }
    
    @objc func increaseBoxFilling() {
        var animation = {}
        switch boxFilling {
        case .state0:
            boxFilling = .state25
            animation = {
                self.gradientLayer25.opacity = 1
                self.statusLabel.textColor = AppColor.boxState25Up
            }
        case .state25:
            boxFilling = .state50
            animation = {
                self.gradientLayer50.opacity = 1
                self.statusLabel.textColor = AppColor.boxState50Up
            }
        case .state50:
            boxFilling = .state75
            animation = {
                self.gradientLayer75.opacity = 1
                self.statusLabel.textColor = AppColor.boxState75Up
            }
        case .state75:
            boxFilling = .state100
            animation = {
                self.gradientLayer100.opacity = 1
                self.statusLabel.textColor = AppColor.boxState100Up
            }
        default:
            break
        }
        UIView.animate(withDuration: 0.5) {
            animation()
        }
    }
    
    @objc func decreaseBoxFilling() {
        var animation = {}
        switch boxFilling {
        case .state100:
            boxFilling = .state75
            animation = {
                self.gradientLayer100.opacity = 0
                self.statusLabel.textColor = AppColor.boxState75Up
            }
        case .state75:
            boxFilling = .state50
            animation = {
                self.gradientLayer75.opacity = 0
                self.statusLabel.textColor = AppColor.boxState50Up
            }
        case .state50:
            boxFilling = .state25
            animation = {
                self.gradientLayer50.opacity = 0
                self.statusLabel.textColor = AppColor.boxState50Up
            }
        case .state25:
            boxFilling = .state0
            animation = {
                self.gradientLayer25.opacity = 0
                self.statusLabel.textColor = AppColor.boxState0Up
            }
        default:
            break
        }
        UIView.animate(withDuration: 0.5) {
            animation()
        }
    }
}
