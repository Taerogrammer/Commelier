//
//  TotalAssetView.swift
//  CrypMulator
//
//  Created by 김태형 on 3/27/25.
//

import UIKit
import SnapKit

final class TotalAssetView: BaseView {
    private let titleLabel = UILabel()

    override func configureHierarchy() {
        addSubview(titleLabel)
    }

    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(12)
        }
    }

    override func configureView() {
        titleLabel.text = StringLiteral.Portfolio.totalAsset
        titleLabel.font = SystemFont.Title.large
    }

}
