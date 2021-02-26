//
//  Router.swift
//  RecyclingStarter
//
//  Created by  Matvey on 31.07.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit


class Router {
    
    private let authService = UserServices()
    
    func firstViewController() -> UIViewController{
        let loadVC = LoadScreenViewController()
        
        var vc: UIViewController = AuthViewController()
        
        authService.getUserData { (userData) in
            if let userData = userData {
                vc = EmployeeTabBarController(userData: userData)
            }
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.setRootViewController(vc, options: UIWindow.TransitionOptions(direction: .fade, style: .easeOut))
            }
        }
        return loadVC
    }
    
    func presentAuthVC() {
        let vc = AuthViewController()
        
        UIApplication.shared.keyWindow?.setRootViewController(vc, options: UIWindow.TransitionOptions(direction: .fade, style: .linear))
    }
    
    func presentRegistrationVC() {
        let vc = RegisterViewController()
        
        UIApplication.shared.keyWindow?.setRootViewController(vc, options: UIWindow.TransitionOptions(direction: .fade, style: .linear))
    }
    
    func presentEmployeeScreens(token: String, userData: UserData) {
        let vc = EmployeeTabBarController(userData: userData)
        
        UIApplication.shared.keyWindow?.setRootViewController(vc, options: UIWindow.TransitionOptions(direction: .fade, style: .linear))
    }
}
