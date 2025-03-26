//
//  CoinFilterButton.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/7/25.
//

import UIKit
import SnapKit

final class CoinFilterButton: BaseView {
    let title = UILabel()
    let upImage = UIImageView()
    let downImage = UIImageView()

    override func configureHierarchy() {
        [title, upImage, downImage].forEach { addSubview($0) }
    }

    override func configureLayout() {
        self.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(26)
        }

        title.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(upImage.snp.leading)
        }
        upImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(title)
            make.size.equalTo(10)
        }
        downImage.snp.makeConstraints { make in
            make.centerX.equalTo(upImage)
            make.bottom.equalTo(title)
            make.size.equalTo(10)
        }
    }
    override func configureView() {
        title.font = SystemFont.Body.content
        title.textAlignment = .right
        upImage.image = SystemIcon.arrowUp
        downImage.image = SystemIcon.arrowDown
        upImage.contentMode = .scaleAspectFit
        downImage.contentMode = .scaleAspectFit
        upImage.tintColor = SystemColor.gray
        downImage.tintColor = SystemColor.gray
        buttonStatus(status: .unClicked)
    }

    func buttonStatus(status: CoinFilterButtonStatus) {
        switch status {
        case .unClicked:
            title.font = SystemFont.Body.primary
            upImage.image = SystemIcon.arrowUp
            downImage.image = SystemIcon.arrowDown
            upImage.tintColor = SystemColor.gray
            downImage.tintColor = SystemColor.gray
        case .upClicked:
            title.font = SystemFont.Body.boldPrimary
            upImage.image = SystemIcon.arrowUp
            downImage.image = SystemIcon.arrowDown
            upImage.tintColor = SystemColor.black
            downImage.tintColor = SystemColor.gray
        case .downClicked:
            title.font = SystemFont.Body.boldPrimary
            upImage.image = SystemIcon.arrowUp
            downImage.image = SystemIcon.arrowDown
            upImage.tintColor = SystemColor.gray
            downImage.tintColor = SystemColor.black
        }
    }
}

enum CoinFilterButtonStatus {
    case unClicked
    case upClicked
    case downClicked
}
