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
        title.font = .systemFont(ofSize: 14)
        title.textAlignment = .right
        upImage.image = UIImage(systemName: "arrowtriangle.up.fill")
        downImage.image = UIImage(systemName: "arrowtriangle.down.fill")
        upImage.contentMode = .scaleAspectFit
        downImage.contentMode = .scaleAspectFit
        upImage.tintColor = .customGray
        downImage.tintColor = .customGray
        buttonStatus(status: .unClicked)
    }

    func buttonStatus(status: CoinFilterButtonStatus) {
        switch status {
        case .unClicked:
            title.font = .systemFont(ofSize: 14)
            upImage.image = UIImage(systemName: "arrowtriangle.up.fill")
            downImage.image = UIImage(systemName: "arrowtriangle.down.fill")
            upImage.tintColor = .customGray
            downImage.tintColor = .customGray
        case .upClicked:
            title.font = .boldSystemFont(ofSize: 14)
            upImage.image = UIImage(systemName: "arrowtriangle.up.fill")
            downImage.image = UIImage(systemName: "arrowtriangle.down.fill")
            upImage.tintColor = .customBlack
            downImage.tintColor = .customGray
        case .downClicked:
            title.font = .boldSystemFont(ofSize: 14)
            upImage.image = UIImage(systemName: "arrowtriangle.up.fill")
            downImage.image = UIImage(systemName: "arrowtriangle.down.fill")
            upImage.tintColor = .customGray
            downImage.tintColor = .customBlack
        }
    }
}

enum CoinFilterButtonStatus {
    case unClicked
    case upClicked
    case downClicked
}
