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
    let isAdmin: Bool
    var boxData: BoxData
    private var boxFilling = boxStates.state0
    private var fillingTopConstraint: Constraint?
    private var boxFillingShift: CGFloat = 0
    
    private let infoView: UIView
    private let minusButton: UIButton
    private let plusButton: UIButton
    private let boxLabel: UILabel
    private let roomLabel: UILabel
    private let percentLabel: UILabel
    private let progressView: UIProgressView
    private let boxLowImageView: UIImageView
    private let boxMiddleImageView: UIImageView
    private let boxTopImageView: UIImageView
    
    private var gradientLayer0 = CAGradientLayer()
    private var gradientLayer40 = CAGradientLayer()
    private var gradientLayer60 = CAGradientLayer()
    private var gradientLayer80 = CAGradientLayer()
    private var gradientLayer100 = CAGradientLayer()
    
    private enum boxGradient {
        
        static let state20 = (AppColor.boxState20Up ?? .white, AppColor.boxState20Down ?? .white)
        
        static let state40 = (AppColor.boxState40Up ?? .white, AppColor.boxState40Down ?? .white)
        
        static let state60 = (AppColor.boxState60Up ?? .white, AppColor.boxState60Down ?? .white)
        
        static let state80 = (AppColor.boxState80Up ?? .white, AppColor.boxState80Down ?? .white)
        
        static let state100 = (AppColor.boxState100Up ?? .white, AppColor.boxState100Down ?? .white)
    }
    
    private enum boxStates: Int {
        case state0 = 0
        case state20 = 20
        case state40 = 40
        case state60 = 60
        case state80 = 80
        case state100 = 100
    }
    
    private enum Style {
        
        static let boxLabel: SwiftRichString.Style = .init {
            $0.font = AppFont.semibold24
            $0.color = AppColor.label
        }
        
        static let roomLabel: SwiftRichString.Style = .init {
            $0.font = AppFont.regular17
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
    
    init(token: String, boxData: BoxData, isAdmin: Bool) {
        self.token = token
        self.boxData = boxData
        self.isAdmin = isAdmin
        self.infoView = Self.makeInfoView()
        self.plusButton = Self.makeButton(isPlus: true)
        self.minusButton = Self.makeButton(isPlus: false)
        self.boxLabel = Self.makeBoxLabel()
        self.roomLabel = Self.makeRoomLabel()
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
        boxFillingShift = 0.028 * boxMiddleImageView.bounds.height
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
        
        infoView.addSubview(roomLabel)
        roomLabel.topToBottom(of: boxLabel, offset: 20)
        roomLabel.centerXToSuperview()
        roomLabel.leadingToSuperview(offset: 42)
        roomLabel.trailingToSuperview(offset: 42)
        
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fill
        
        buttonStackView.addArrangedSubview(minusButton)
        buttonStackView.addArrangedSubview(percentLabel)
        buttonStackView.addArrangedSubview(plusButton)
        
        
        infoView.addSubview(buttonStackView)
        buttonStackView.topToBottom(of: roomLabel, offset: 21)
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
        gradientLayer100 = makeGradient(state: .state100)
        gradientLayer80 = makeGradient(state: .state80)
        gradientLayer60 = makeGradient(state: .state60)
        gradientLayer40 = makeGradient(state: .state40)
        gradientLayer0 = makeGradient(state: .state0)
    }
    
    private func makeGradient(state: boxStates) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.locations = [0.0, 1.0]
        gradient.frame = self.view.bounds
        gradient.opacity = 0
        switch state {
        case .state0:
            gradient.colors = [boxGradient.state20.0.cgColor, boxGradient.state20.1.cgColor]
            gradient.opacity = 1
        case .state20:
            gradient.colors = [boxGradient.state20.0.cgColor, boxGradient.state20.1.cgColor]
        case .state40:
            gradient.colors = [boxGradient.state40.0.cgColor, boxGradient.state40.1.cgColor]
        case .state60:
            gradient.colors = [boxGradient.state60.0.cgColor, boxGradient.state60.1.cgColor]
        case .state80:
            gradient.colors = [boxGradient.state80.0.cgColor, boxGradient.state80.1.cgColor]
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
        label.attributedText = "Контейнер ##".set(style: Style.boxLabel)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }
    
    private static func makeRoomLabel() -> UILabel {
        let label = UILabel()
        label.attributedText = "Кабинет ###".set(style: Style.roomLabel)
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
        if isAdmin {
            minusButton.addTarget(self, action: #selector(decreaseBoxFilling), for: .touchUpInside)
        } else {
            minusButton.isEnabled = false
        }
        plusButton.addTarget(self, action: #selector(increaseBoxFilling), for: .touchUpInside)
    }
    
    @objc func increaseBoxFilling() {
        var animation = {}
        switch boxFilling {
        case .state0:
            boxFilling = .state20
            animation = {
                let boxShift = 35 + 4 * self.boxFillingShift
                self.fillingTopConstraint?.constant = boxShift
            }
        case .state20:
            boxFilling = .state40
            animation = {
                let boxShift = 35 + 3 * self.boxFillingShift
                self.fillingTopConstraint?.constant = boxShift
                self.gradientLayer40.opacity = 1
            }
        case .state40:
            boxFilling = .state60
            animation = {
                let boxShift = 35 + 2 * self.boxFillingShift
                self.fillingTopConstraint?.constant = boxShift
                self.gradientLayer60.opacity = 1
            }
        case .state60:
            boxFilling = .state80
            animation = {
                let boxShift = 35 + self.boxFillingShift
                self.fillingTopConstraint?.constant = boxShift
                self.gradientLayer80.opacity = 1
            }
        case .state80:
            boxFilling = .state100
            animation = {
                self.fillingTopConstraint?.constant = 35
                self.gradientLayer100.opacity = 1
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
            boxFilling = .state80
            animation = {
                let boxShift = 35 + self.boxFillingShift
                self.fillingTopConstraint?.constant = boxShift
                self.gradientLayer100.opacity = 0
            }
        case .state80:
            boxFilling = .state60
            animation = {
                let boxShift = 35 + 2 * self.boxFillingShift
                self.fillingTopConstraint?.constant = boxShift
                self.gradientLayer80.opacity = 0
            }
        case .state60:
            boxFilling = .state40
            animation = {
                let boxShift = 35 + 3 * self.boxFillingShift
                self.fillingTopConstraint?.constant = boxShift
                self.gradientLayer60.opacity = 0
            }
        case .state40:
            boxFilling = .state20
            animation = {
                let boxShift = 35 + 4 * self.boxFillingShift
                self.fillingTopConstraint?.constant = boxShift
                self.gradientLayer40.opacity = 0
            }
        case .state20:
            boxFilling = .state0
            animation = {
                let boxShift = 35 + 5 * self.boxFillingShift
                self.fillingTopConstraint?.constant = boxShift
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
        roomLabel.attributedText = "Кабинет \(boxData.room)".set(style: Style.roomLabel)
        
        var currentState = 0
        while currentState < state.rawValue {
            currentState += 20
            increaseBoxFilling()
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
        boxInteractionServise.fillBox(token: token, box: boxData, isAdmin: isAdmin, fullness: fullness) { (newBox) in
            if let newBox = newBox {
                self.boxData = newBox
            }
        }
    }
}
