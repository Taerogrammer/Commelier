//
//  CoinCollectionViewCell.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/7/25.
//

import UIKit
import Kingfisher
import SnapKit

final class CoinCollectionViewCell: BaseCollectionViewCell, ReuseIdentifiable {
    let rankLabel = UILabel()
    let thumbnailImage = CircleImage(frame: .zero)
    let symbolLabel = UILabel()
    let nameLabel = UILabel()
    let rateLabel = UILabel()

    override func configureHierarchy() {
        [rankLabel, thumbnailImage, symbolLabel, nameLabel, rateLabel].forEach { contentView.addSubview($0) }
    }

    override func configureLayout() {
        rankLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }

        thumbnailImage.snp.makeConstraints { make in
            make.leading.equalTo(rankLabel.snp.trailing).offset(8)
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(26)
        }

        symbolLabel.snp.makeConstraints { make in
            make.leading.equalTo(thumbnailImage.snp.trailing).offset(4)
            make.centerY.equalTo(safeAreaLayoutGuide).offset(-6)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(symbolLabel)
            make.centerY.equalTo(safeAreaLayoutGuide).offset(6)
        }

        rateLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(nameLabel.snp.trailing).offset(8)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(8)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }

        nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        rateLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        rateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }

    override func configureView() {
        rankLabel.font = .systemFont(ofSize: 12)
        symbolLabel.font = .boldSystemFont(ofSize: 12)
        nameLabel.font = .systemFont(ofSize: 9)
        rateLabel.font = .boldSystemFont(ofSize: 9)
    }
}

// MARK: - configure cell
extension CoinCollectionViewCell {
    func configureCell(with coin: TrendingCoin) {
        rankLabel.text = coin.rank
        thumbnailImage.kf.setImage(with: URL(string: coin.imageURL))
        symbolLabel.text = coin.symbol
        nameLabel.text = coin.name
        updateRateLabel(with: coin.rate)
    }

    private func updateRateLabel(with number: Double) {
        let rounded = round(number * 100) / 100
        if rounded == 0.00 {
            rateLabel.textColor = UIColor.customBlack
            rateLabel.text = "\(rounded)%"
        } else if rounded > 0 {
            rateLabel.textColor = UIColor.customRed
            rateLabel.text = "▲ \(rounded)%"
        } else {
            rateLabel.textColor = UIColor.customBlue
            rateLabel.text = "▼ \(abs(rounded))%"
        }
    }
}
