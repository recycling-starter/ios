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
                self.authService.autharisation(email: email, password: password) { (userData, token) in
                    if let userData = userData{
                        print(userData.boxes)
                        vc = BoxListViewController(token: token, boxList: userData.boxes)
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
    
    func presentAuthVC() {
        let vc = AuthViewController()
        
        UIApplication.shared.keyWindow?.setRootViewController(vc, options: UIWindow.TransitionOptions(direction: .fade, style: .linear))
    }
    
    func presentRegistrationVC() {
        let vc = RegisterViewController()
        
        UIApplication.shared.keyWindow?.setRootViewController(vc, options: UIWindow.TransitionOptions(direction: .fade, style: .linear))
    }
    
    func presentBoxManagmentVC(token: String, boxData: BoxData) {
        let vc = BoxManagmentViewController(token: token, boxData: boxData)
        
        UIApplication.shared.keyWindow?.setRootViewController(vc, options: UIWindow.TransitionOptions(direction: .fade, style: .linear))
    }
    
    func presentBoxListViewController(token: String, boxList: [BoxData]) {
        let vc = BoxListViewController(token: token, boxList: boxList)
        
        UIApplication.shared.keyWindow?.setRootViewController(vc, options: UIWindow.TransitionOptions(direction: .fade, style: .linear))
    }
}
