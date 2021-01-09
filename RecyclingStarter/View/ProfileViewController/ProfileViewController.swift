//
//  ProfileViewController.swift
//  RecyclingStarter
//
//  Created by  Matvey on 09.01.2021.
//  Copyright © 2021 Borisov Matvei. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        label.text = "Some Profile"
        label.textAlignment = .center
        view.addSubview(label)
    }
    
    override func viewWillLayoutSubviews() {
        label.frame = CGRect(x: view.frame.origin.x + 16,
                             y: view.safeAreaInsets.top + 16,
                             width: view.frame.width - 32,
                             height: 20)
    }
}
