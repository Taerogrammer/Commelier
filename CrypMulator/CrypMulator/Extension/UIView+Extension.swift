//
//  UIView+Extension.swift
//  CrypMulator
//
//  Created by 김태형 on 3/25/25.
//

import UIKit

extension UIView {
    func addSubViews(_ views: [UIView]) {
        views.forEach { view in
            self.addSubview(view)
        }
    }
}
