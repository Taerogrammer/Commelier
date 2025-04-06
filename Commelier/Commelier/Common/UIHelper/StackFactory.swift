//
//  StackFactory.swift
//  CrypMulator
//
//  Created by 김태형 on 3/28/25.
//

import UIKit

enum StackFactory {

    static func horizontalRowStack(
        left: UILabel,
        right: UILabel,
        spacing: CGFloat = 4,
        distribution: UIStackView.Distribution = .equalSpacing
    ) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [left, right])
        stack.axis = .horizontal
        stack.spacing = spacing
        stack.distribution = distribution
        return stack
    }

    static func verticalStack(
        views: [UIView],
        spacing: CGFloat = 8,
        alignment: UIStackView.Alignment = .fill
    ) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = .vertical
        stack.spacing = spacing
        stack.alignment = alignment
        return stack
    }
}
