//
//  Color.swift
//  Commelier
//
//  Created by 김태형 on 4/10/25.
//

import UIKit

extension UIColor {
    static func dynamicColor(light: String, dark: String) -> UIColor {
        return UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(hex: dark) : UIColor(hex: light)
        }
    }
}
