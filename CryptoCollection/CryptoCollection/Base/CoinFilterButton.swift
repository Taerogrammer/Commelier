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
        title.text = "테스트"
        title.font = .boldSystemFont(ofSize: 14)
        title.textAlignment = .right
        upImage.image = UIImage(systemName: "arrowtriangle.up.fill")
        downImage.image = UIImage(systemName: "arrowtriangle.down.fill")
        upImage.contentMode = .scaleAspectFit
        downImage.contentMode = .scaleAspectFit
    }
}
