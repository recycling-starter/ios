//
//  BoxManagmentViewController.swift
//  RecyclingStarter
//
//  Created by  Matvey on 27.07.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit
import TinyConstraints
import SwiftRichString

class BoxManagmentViewController: UIViewController {
    
    private let boxInteractionServise = BoxInteractionServices()
    private let localStorageService = LocalStorageServices()
    
    let token: String
    var boxData: BoxData
    private var boxFilling = boxStates.state0
    private var fillingTopConstraint: Constraint?
    private var boxFillingShift: CGFloat = 0
    
    private let infoView: UIView
    private let minusButton: UIButton
    private let plusButton: UIButton
    private let boxLabel: UILabel
    private let statusLabel: UILabel
    private let percentLabel: UILabel
    private let progressView: UIProgressView
    private let boxLowImageView: UIImageView
    private let boxMiddleImageView: UIImageView
    private let boxTopImageView: UIImageView
    
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
        
        static let state0Text = "Пусто"
        static let state25Text = "Немного есть"
        static let state50Text = "Заполнен на половину"
        static let state75Text = "Почти полон"
        static let state100Text = "Заполнен"
    }
    
    private enum Style {
        
        static let boxLabel: SwiftRichString.Style = .init {
            $0.font = AppFont.semibold24
            $0.color = AppColor.label
        }
        
        static let percentLabel: SwiftRichString.Style = .init {
            $0.font = AppFont.semibold22
            $0.color = AppColor.label
        }
    }
    
    private enum BoxImage {
        case low
        case middle
        case top
    }
    
    init(token: String, boxData: BoxData) {
        self.token = token
        self.boxData = boxData
        self.infoView = Self.makeInfoView()
        self.plusButton = Self.makeButton(isPlus: true)
        self.minusButton = Self.makeButton(isPlus: false)
        self.boxLabel = Self.makeBoxLabel()
        self.statusLabel = Self.makeStatusLabel()
        self.percentLabel = Self.makePercentLabel()
        self.progressView = Self.makeProgressView()
        self.boxLowImageView = Self.makeBoxImageView(part: .low)
        self.boxMiddleImageView = Self.makeBoxImageView(part: .middle)
        self.boxTopImageView = Self.makeBoxImageView(part: .top)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupButtonActions()
        setupGradient()
        getCurrentBoxState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        boxFillingShift = 0.035 * boxMiddleImageView.bounds.height
    }
    
    // MARK: Setup View
    func setupViews() {
        
        view.addSubview(infoView)
        infoView.leadingToSuperview(offset: 20, usingSafeArea: true)
        infoView.trailingToSuperview(offset: 20, usingSafeArea: true)
        infoView.bottomToSuperview(offset: -20, usingSafeArea: true)
        
        infoView.addSubview(boxLabel)
        boxLabel.topToSuperview(offset: 14)
        boxLabel.centerXToSuperview()
        
        infoView.addSubview(statusLabel)
        statusLabel.topToBottom(of: boxLabel, offset: 20)
        statusLabel.centerXToSuperview()
        statusLabel.leadingToSuperview(offset: 42)
        statusLabel.trailingToSuperview(offset: 42)
        
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fill
        
        buttonStackView.addArrangedSubview(minusButton)
        buttonStackView.addArrangedSubview(percentLabel)
        buttonStackView.addArrangedSubview(plusButton)
        
        
        infoView.addSubview(buttonStackView)
        buttonStackView.topToBottom(of: statusLabel, offset: 21)
        buttonStackView.leadingToSuperview(offset: 42)
        buttonStackView.trailingToSuperview(offset: 42)
        
        percentLabel.leadingToTrailing(of: minusButton, offset: 10)
        percentLabel.trailingToLeading(of: plusButton, offset: 10)
        
        infoView.addSubview(progressView)
        progressView.topToBottom(of: buttonStackView, offset: 41)
        progressView.leadingToSuperview(offset: 41)
        progressView.trailingToSuperview(offset: 41)
        
        view.addSubview(boxLowImageView)
        boxLowImageView.centerXToSuperview(offset: 4)
        boxLowImageView.topToSuperview(offset: 35, usingSafeArea: true)
        boxLowImageView.bottomToTop(of: infoView, offset: -35)
        
        view.addSubview(boxMiddleImageView)
        boxMiddleImageView.centerXToSuperview(offset: 4)
        fillingTopConstraint = boxMiddleImageView.topToSuperview(offset: 85, usingSafeArea: true)
        boxMiddleImageView.bottomToTop(of: infoView, offset: -35)
        
        view.addSubview(boxTopImageView)
        boxTopImageView.centerXToSuperview(offset: 4)
        boxTopImageView.topToSuperview(offset: 35, usingSafeArea: true)
        boxTopImageView.bottomToTop(of: infoView, offset: -35)
    }
    
    private func setupGradient() {
        self.gradientLayer100 = makeGradient(state: .state100)
        self.gradientLayer75 = makeGradient(state: .state75)
        self.gradientLayer50 = makeGradient(state: .state50)
        self.gradientLayer25 = makeGradient(state: .state25)
        self.gradientLayer0 = makeGradient(state: .state0)
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
    
    private static func makeInfoView() -> UIView {
        let view = UIView()
        
        view.layer.cornerRadius = 8
        view.backgroundColor = .white
        view.height(225)
        
        return view
    }
    
    private static func makeBoxLabel() -> UILabel {
        let label = UILabel()
        label.attributedText = "Контейнер ####".set(style: Style.boxLabel)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }
    
    private static func makeStatusLabel() -> UILabel {
        let label = UILabel()
        label.text = boxStates.state0Text
        label.font = AppFont.medium16
        label.textAlignment = .center
        return label
    }
    
    private static func makePercentLabel() -> UILabel {
        let label = UILabel()
        label.attributedText = "0%".set(style: Style.percentLabel)
        label.textAlignment = .center
        return label
    }
    
    private static func makeButton(isPlus: Bool) -> UIButton {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.width(22)
        button.tintColor = .black
        button.height(48)
        button.width(60)
        if isPlus {
            button.setImage(AppImage.plusImage, for: .normal)
        } else {
            button.setImage(AppImage.minusImage, for: .normal)
        }
        return button
    }
    
    private static func makeProgressView() -> UIProgressView {
        let progressView = UIProgressView()
        
        progressView.progressTintColor = AppColor.progressBarProgress
        progressView.trackTintColor = AppColor.progressBarTrack
        
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 3.5)
        progressView.layer.cornerRadius = 3.5
        progressView.clipsToBounds = true
        
        progressView.setProgress(0.01, animated: true)
        
        return progressView
    }
    
    private static func makeBoxImageView(part: BoxImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        switch part {
        case .low:
            imageView.image = AppImage.boxLow
        case .middle:
            imageView.image = AppImage.boxMiddle
        case .top:
            imageView.image = AppImage.boxTop
        }
        
        return imageView
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
                let boxShift = 35 + 3 * self.boxFillingShift
                self.fillingTopConstraint?.constant = boxShift
                self.statusLabel.text = boxStates.state25Text
                self.gradientLayer25.opacity = 1
                self.statusLabel.textColor = AppColor.boxState25Up
            }
        case .state25:
            boxFilling = .state50
            animation = {
                let boxShift = 35 + 2 * self.boxFillingShift
                self.fillingTopConstraint?.constant = boxShift
                self.statusLabel.text = boxStates.state50Text
                self.gradientLayer50.opacity = 1
                self.statusLabel.textColor = AppColor.boxState50Up
            }
        case .state50:
            boxFilling = .state75
            animation = {
                let boxShift = 35 + self.boxFillingShift
                self.fillingTopConstraint?.constant = boxShift
                self.statusLabel.text = boxStates.state75Text
                self.gradientLayer75.opacity = 1
                self.statusLabel.textColor = AppColor.boxState75Up
            }
        case .state75:
            boxFilling = .state100
            animation = {
                self.fillingTopConstraint?.constant = 35
                self.statusLabel.text = boxStates.state100Text
                self.gradientLayer100.opacity = 1
                self.statusLabel.textColor = AppColor.boxState100Up
            }
        default:
            break
        }
        fillBox(fullness: boxFilling.rawValue)
        percentLabel.attributedText = "\(boxFilling.rawValue)%".set(style: Style.percentLabel)
        progressView.setProgress(Float(boxFilling.rawValue) / 100, animated: true)
        UIView.animate(withDuration: 0.5) {
            animation()
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func decreaseBoxFilling() {
        var animation = {}
        switch boxFilling {
        case .state100:
            boxFilling = .state75
            animation = {
                let boxShift = 35 + self.boxFillingShift
                self.fillingTopConstraint?.constant = boxShift
                self.statusLabel.text = boxStates.state75Text
                self.gradientLayer100.opacity = 0
                self.statusLabel.textColor = AppColor.boxState75Up
            }
        case .state75:
            boxFilling = .state50
            animation = {
                let boxShift = 35 + 2 * self.boxFillingShift
                self.fillingTopConstraint?.constant = boxShift
                self.statusLabel.text = boxStates.state50Text
                self.gradientLayer75.opacity = 0
                self.statusLabel.textColor = AppColor.boxState50Up
            }
        case .state50:
            boxFilling = .state25
            animation = {
                let boxShift = 35 + 3 * self.boxFillingShift
                self.fillingTopConstraint?.constant = boxShift
                self.statusLabel.text = boxStates.state25Text
                self.gradientLayer50.opacity = 0
                self.statusLabel.textColor = AppColor.boxState50Up
            }
        case .state25:
            boxFilling = .state0
            animation = {
                let boxShift = 35 + 4 * self.boxFillingShift
                self.fillingTopConstraint?.constant = boxShift
                self.statusLabel.text = boxStates.state0Text
                self.gradientLayer25.opacity = 0
                self.statusLabel.textColor = AppColor.boxState0Up
            }
        default:
            break
        }
        fillBox(fullness: boxFilling.rawValue)
        progressView.setProgress(max(Float(boxFilling.rawValue) / 100, 0.01), animated: true)
        percentLabel.attributedText = "\(boxFilling.rawValue)%".set(style: Style.percentLabel)
        UIView.animate(withDuration: 0.5) {
            animation()
            self.view.layoutIfNeeded()
        }
    }
    
    private func updateBox(state: boxStates) {
        boxLabel.attributedText = "Контейнер \(boxData.id)".set(style: Style.boxLabel)
        
        if state.rawValue > 0 {
            increaseBoxFilling()
            if state.rawValue > 25 {
                increaseBoxFilling()
                if state.rawValue > 50 {
                    increaseBoxFilling()
                    if state.rawValue > 75 {
                        increaseBoxFilling()
                    }
                }
            }
        }
    }
    
    // MARK: Network
    private func getCurrentBoxState() {
        boxInteractionServise.getBox(box: boxData, token: token) { (newBox) in
            if let newBox = newBox {
                self.boxData = newBox
                if let state = boxStates(rawValue: newBox.fullness) {
                    self.updateBox(state: state)
                }
            }
        }
    }
    
    private func fillBox(fullness: Int) {
        boxInteractionServise.fillBox(token: token, box: boxData, fullness: fullness) { (newBox) in
            if let newBox = newBox {
                self.boxData = newBox
            }
        }
    }
}
