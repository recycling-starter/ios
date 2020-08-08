//
//  LoadScreenViewController.swift
//  RecyclingStarter
//
//  Created by  Matvey on 31.07.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit

class LoadScreenViewController: UIViewController {
    
    let logo = AppImage.logo
    
    override func viewDidLoad() {
        let logoView = UIImageView()
        logoView.image = logo
        logoView.frame = CGRect(x: 0, y: 0, width: 150, height: 48)
        
        view.addSubview(logoView)
        view.backgroundColor = AppColor.background
        logoView.centerInSuperview()
    }
    
    init() {
        super.init(nibName: nil, bundle:    nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
