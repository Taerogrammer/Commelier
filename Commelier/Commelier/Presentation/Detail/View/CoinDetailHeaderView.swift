//
//  DetailCollectionHeaderView.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/9/25.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class CoinDetailHeaderView: UICollectionReusableView, ReuseIdentifiable {

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
extension CoinDetailHeaderView: ViewConfiguration {
    func configureHierarchy() {
        addSubview(titleLabel)
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func configureView() {
        titleLabel.font = SystemFont.Title.medium
        titleLabel.textColor = SystemColor.background
    }

    func configureTitle(with title: String) {
        titleLabel.text = title
    }
}
