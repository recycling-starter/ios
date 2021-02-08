//
//  UIImageExtension.swift
//  RecyclingStarter
//
//  Created by  Matvey on 02.02.2021.
//  Copyright © 2021 Borisov Matvei. All rights reserved.
//

import UIKit

extension UIImage {
    func alpha(_ value: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: value)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
