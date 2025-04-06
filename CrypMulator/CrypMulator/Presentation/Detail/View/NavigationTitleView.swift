//
//  DetailTitleView.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/8/25.
//

import UIKit
import Kingfisher
import SnapKit

// TODO: - 숫자 Int64 + 쉼표로 바꾸기
final class NavigationTitleView: BaseView {
    private let stackView = UIStackView()
    let image = UIImageView()
    let marketLabel = UILabel()

    init(entity: NavigationTitleEntity) {
        super.init(frame: .zero)
        configure(entity: entity)
    }

    override func configureHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubviews([image, marketLabel])
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

        marketLabel.font = SystemFont.Title.small
        marketLabel.textColor = SystemColor.white

        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
    }

    private func configure(entity: NavigationTitleEntity) {
        marketLabel.text = entity.title
        image.setCoinImage(with: entity.imageURLString)
    }
}
