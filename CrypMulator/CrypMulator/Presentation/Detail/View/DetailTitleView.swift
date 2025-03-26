//
//  DetailTitleView.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/8/25.
//

import UIKit
import SnapKit

final class DetailTitleView: BaseView {
    private let stackView = UIStackView()
    let image = UIImageView()
    let id = UILabel()

    override func configureHierarchy() {
        addSubview(stackView)

        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(id)
    }

    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        image.snp.makeConstraints { make in
            make.size.equalTo(28)
        }
    }

    override func configureView() {
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 14
        id.font = .boldSystemFont(ofSize: 16)
        id.textColor = SystemColor.black
    }
}
