//
//  TrendingCollectionHeaderView.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/9/25.
//

import UIKit
import SnapKit

final class InformationCollectionHeaderView: UICollectionReusableView, ReuseIdentifiable {
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - configure view
extension InformationCollectionHeaderView: ViewConfiguration {
    func configureHierarchy() {
        addSubviews([titleLabel])
    }

    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
    }

    func configureView() {
        titleLabel.font = SystemFont.Title.small
        titleLabel.textColor = SystemColor.white
    }

    func configureTitle(with title: String) {
        titleLabel.text = title
    }
}
