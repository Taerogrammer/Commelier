//
//  SymbolInfoCell.swift
//  CrypMulator
//
//  Created by 김태형 on 3/31/25.
//

import UIKit
import SnapKit
import RxSwift

final class SymbolInfoCell: BaseCollectionViewCell, ReuseIdentifiable {
    private var disposeBag = DisposeBag()
    let titleLabel = UILabel()
    let amountLabel = UILabel()
    let dateLabel = UILabel()

    override func configureHierarchy() {
        contentView.addSubviews([titleLabel, amountLabel, dateLabel])
    }

    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(8)
        }

        amountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }

        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(amountLabel.snp.bottom).offset(8)
        }
    }

    override func configureView() {
        titleLabel.font = SystemFont.Body.content
        amountLabel.font = SystemFont.Body.boldPrimary
        dateLabel.font = SystemFont.Body.small

        /// ㅇㅇㅇ
        titleLabel.textColor = SystemColor.white
        amountLabel.textColor = SystemColor.white
        dateLabel.textColor = SystemColor.white

        contentView.backgroundColor = SystemColor.darkBrown
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
    }

    func configureCorners(for indexPath: IndexPath, in collectionView: UICollectionView) {
        let totalItems = collectionView.numberOfItems(inSection: indexPath.section)

        let isLeft = indexPath.item % 2 == 0
        let isRight = !isLeft
        let isTopRow = indexPath.item < 2
        let rowCount = Int(ceil(Double(totalItems) / 2.0))
        let currentRow = indexPath.item / 2
        let isBottomRow = currentRow == rowCount - 1

        var corners: CACornerMask = []

        if isLeft && isTopRow {
            corners.insert(.layerMinXMinYCorner)
        }
        if isRight && isTopRow {
            corners.insert(.layerMaxXMinYCorner)
        }
        if isLeft && isBottomRow {
            corners.insert(.layerMinXMaxYCorner)
        }
        if isRight && isBottomRow {
            corners.insert(.layerMaxXMaxYCorner)
        }

        contentView.layer.cornerRadius = 16
        contentView.layer.maskedCorners = corners
        contentView.layer.masksToBounds = true
    }
}
