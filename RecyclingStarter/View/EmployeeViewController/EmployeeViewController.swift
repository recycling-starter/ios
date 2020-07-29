//
//  EmployeeViewController.swift
//  RecyclingStarter
//
//  Created by  Matvey on 27.07.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit
import TinyConstraints

class EmployeeViewController: UIViewController {
    
    let user: UserLogin
    let infoView = UIView()
    let minusButton = UIButton(type: .system)
    let plusButton = UIButton(type: .system)
    let boxLabet = UILabel()
    let statusLabel = UILabel()
    let persentLabel = UILabel()
    let gradientLayer = CAGradientLayer()
    
    
    init(user: UserLogin) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupGradient()
        super.viewWillAppear(true)
        
    }
    
    func setupViews() {
        view.backgroundColor = .clear
        
        let buttonsStackView = UIStackView()
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .equalSpacing
        
        buttonsStackView.addArrangedSubview(minusButton)
        buttonsStackView.addArrangedSubview(persentLabel)
        buttonsStackView.addArrangedSubview(plusButton)
        
        let infoStackView = UIStackView()
        infoStackView.axis = .vertical
        infoStackView.distribution = .equalSpacing
        
        infoStackView.addArrangedSubview(boxLabet)
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
        
        
        let title = NSAttributedString(string: "-")
        minusButton.setAttributedTitle(title, for: .normal)
        minusButton.layer.borderColor = UIColor.black.cgColor
        minusButton.layer.borderWidth = 1
        
        }
    
    func setupGradient() {
        gradientLayer.colors = [AppColor.boxMinLoadUp?.cgColor, AppColor.boxMinLoadDown?.cgColor]
        gradientLayer.locations = [0.0 , 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
