//
//  ActionButton.swift
//  CrypMulator
//
//  Created by 김태형 on 3/31/25.
//

import UIKit

final class ActionButton: UIButton {

    init(title: String, titleColor: UIColor = SystemColor.white, backgroundColor: UIColor, font: UIFont = SystemFont.Button.primary) {
        super.init(frame: .zero)
        configure(title: title, titleColor: titleColor, backgroundColor: backgroundColor, font: font)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(title: String, titleColor: UIColor, backgroundColor: UIColor, font: UIFont) {
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        titleLabel?.font = font
        layer.cornerRadius = 8
        clipsToBounds = true
    }
}
