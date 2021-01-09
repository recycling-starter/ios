//
//  EmployeeTabBarController.swift
//  RecyclingStarter
//
//  Created by  Matvey on 09.01.2021.
//  Copyright © 2021 Borisov Matvei. All rights reserved.
//

import UIKit

class EmployeeTabBarController: UITabBarController {
    
    var token: String
    var userData: UserData
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBarList = [setupBoxList(), setupProfile()]
        viewControllers = tabBarList
        tabBar.tintColor = AppColor.button
    }
    
    init(token: String, userData: UserData) {
        self.token = token
        self.userData = userData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBoxList() -> UINavigationController {
        let boxListVC = BoxListViewController(token: token, boxList: userData.boxes)
        let navigation = UINavigationController(rootViewController: boxListVC)
        
        let boxImage = AppImage.boxIcon?.withRenderingMode(.alwaysTemplate)
        let boxListBarItem = UITabBarItem(title: nil, image: boxImage, tag: 0)
        navigation.tabBarItem = boxListBarItem
        
        return navigation
    }
    
    private func setupProfile() -> ProfileViewController {
        let profileVC = ProfileViewController()
        
        let profileImage = AppImage.profileIcon?.withRenderingMode(.alwaysTemplate)
        let profileBarItem = UITabBarItem(title: nil, image: profileImage, tag: 1)
        profileVC.tabBarItem = profileBarItem
        
        return profileVC
    }
}
