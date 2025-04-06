//
//  UIStackView+Extension.swift
//  CrypMulator
//
//  Created by 김태형 on 3/27/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}
