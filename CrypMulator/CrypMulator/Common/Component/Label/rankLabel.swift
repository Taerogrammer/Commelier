//
//  rankLabel.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/8/25.
//

import UIKit

final class rankLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        font = .boldSystemFont(ofSize: 9)
        textColor = UIColor.customGray
        textAlignment = .center
        backgroundColor = UIColor.customWhiteGray
        layer.cornerRadius = 6
    }

    // 양 옆 간격 제공
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + 12, height: size.height + 8)
    }
}
