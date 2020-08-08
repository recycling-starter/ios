//
//  Router.swift
//  RecyclingStarter
//
//  Created by  Matvey on 31.07.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit


class Router {
    
    private let localStorageService = LocalStorageServices()
    
    private let authService = AuthServices()
    
    func firstViewController() -> UIViewController{
        let loadVC = LoadScreenViewController()
        
        var vc: UIViewController = AuthViewController()
        
        localStorageService.loadUserData { (loadInfo) in
            if let email = loadInfo?.email, let password = loadInfo?.password{
                self.authService.autharisation(email: email, password: password) { (user) in
                    if let user = user{
                        vc = EmployeeViewController(user: user)
                    }
                    UIApplication.shared.keyWindow?.setRootViewController(vc, options: UIWindow.TransitionOptions(direction: .fade, style: .easeOut))
                }
            } else {
                DispatchQueue.main.async {
                    UIApplication.shared.keyWindow?.setRootViewController(vc, options: UIWindow.TransitionOptions(direction: .fade, style: .easeOut))
                }
            }
        }
        return loadVC
    }
}
