//
//  TradeContainerView.swift
//  CrypMulator
//
//  Created by 김태형 on 4/1/25.
//

import UIKit
import SnapKit

final class TradeContainerView: BaseView {

    private let titleLabel = UILabel()
    let contentView = UIView()

    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
    }

    override func configureView() {
        backgroundColor = SystemColor.whiteGray
        layer.cornerRadius = 12
        clipsToBounds = true

        titleLabel.font = SystemFont.Title.medium
        titleLabel.textColor = SystemColor.black

        contentView.backgroundColor = .clear
    }

    override func configureHierarchy() {
        addSubviews([titleLabel, contentView])
    }

    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        contentView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(40)
        }
    }
}
