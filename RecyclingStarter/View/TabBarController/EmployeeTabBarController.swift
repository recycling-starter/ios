//
//  EmployeeTabBarController.swift
//  RecyclingStarter
//
//  Created by  Matvey on 09.01.2021.
//  Copyright © 2021 Borisov Matvei. All rights reserved.
//

import UIKit

class EmployeeTabBarController: UITabBarController {
    
    var userData: UserData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBarList = [setupBoxList(), setupProfile()]
        viewControllers = tabBarList
        tabBar.tintColor = AppColor.button
        tabBar.isTranslucent = false
        tabBar.barTintColor = AppColor.navigationBarColor
    }
    
    init(userData: UserData) {
        self.userData = userData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBoxList() -> UINavigationController {
        let boxListVC = BoxListViewController(userData: userData)
        boxListVC.title = "Контейнеры"
        let navigation = UINavigationController(rootViewController: boxListVC)
        
        let boxImage = AppImage.recyclingIcon?.withRenderingMode(.alwaysTemplate)
        let boxListBarItem = UITabBarItem(title: nil, image: boxImage, tag: 0)
        navigation.tabBarItem = boxListBarItem
        navigation.navigationBar.isTranslucent = false
        navigation.navigationBar.barTintColor = AppColor.navigationBarColor
        navigation.navigationBar.tintColor = AppColor.button
        navigation.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: AppFont.semibold18,
            NSAttributedString.Key.foregroundColor: AppColor.label ?? .black
        ]
        
        return navigation
    }
    
    private func setupProfile() -> UINavigationController {
        let profileVC = EmployeeProfileViewController(userData: userData)
        let navigation = UINavigationController(rootViewController: profileVC)
        profileVC.title = "Настройки"
        navigation.navigationBar.prefersLargeTitles = true
        navigation.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: AppFont.semibold32]
        navigation.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: AppFont.semibold18]
        
        let profileImage = AppImage.profileIcon?.withRenderingMode(.alwaysTemplate)
        let profileBarItem = UITabBarItem(title: nil, image: profileImage, tag: 1)
        navigation.tabBarItem = profileBarItem
        
        return navigation
    }
}
