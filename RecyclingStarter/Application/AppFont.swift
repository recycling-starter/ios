//
//  AppFont.swift
//  RecyclingStarter
//
//  Created by  Matvey on 25.07.2020.
//  Copyright © 2020 Borisov Matvei. All rights reserved.
//

import UIKit

enum AppFont {
    
    // MARK: - Bold
    static let bold32 = bold(size: 32)
    
    // MARK: - Semibold
    static let semibold40 = semibold(size: 40)
    static let semibold32 = semibold(size: 28)
    static let semibold24 = semibold(size: 24)
    static let semibold22 = semibold(size: 22)
    static let semibold18 = semibold(size: 18)
    static let semibold16 = semibold(size: 16)
    static let semibold12 = semibold(size: 12)
    
    // MARK: - Medium
    static let medium16 = medium(size: 16)
    static let medium14 = medium(size: 14)
    
    // MARK: - Regular
    static let regular17 = regular(size: 17)
    static let regular14 = regular(size: 14)
    static let regular12 = regular(size: 12)
    static let regular10 = regular(size: 10)
    
    // MARK: - Private
    private static func bold(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Exo2-Bold", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
        return font
    }
    
    private static func semibold(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Exo2-SemiBold", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .semibold)
        }
        return font
    }
    
    private static func medium(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Exo2-Medium", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .medium)
        }
        return font
    }
    
    private static func regular(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Exo2-Regular", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
        return font
    }
}
