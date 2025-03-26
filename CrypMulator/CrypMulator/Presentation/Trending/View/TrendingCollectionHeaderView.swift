//
//  TrendingCollectionHeaderView.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/9/25.
//

import UIKit
import SnapKit

final class TrendingCollectionHeaderView: UICollectionReusableView, ReuseIdentifiable {
    private let titleLabel = UILabel()
    private let updateLabel = UILabel()

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
extension TrendingCollectionHeaderView: ViewConfiguration {
    func configureHierarchy() {
        [titleLabel, updateLabel].forEach { addSubview($0) }
    }

    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
        updateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
    }

    func configureView() {
        titleLabel.font = .boldSystemFont(ofSize: 12)
        titleLabel.textColor = SystemColor.black
        updateLabel.font = .systemFont(ofSize: 12)
        updateLabel.textColor = SystemColor.gray
    }

    func configureTitle(with title: String, updateTime: String?) {
        titleLabel.text = title
        guard let updateTime = updateTime else { return }
        updateLabel.text = updateTime
    }
}
