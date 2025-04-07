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
    private let thumbnailImage = CircleImage(frame: .zero)
    private let symbolLabel = UILabel()
    private let nameLabel = UILabel()
    private let rateLabel = UILabel()
    private let stackView = UIStackView()

    override func configureHierarchy() {
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading

        contentView.addSubview(stackView)
        stackView.addArrangedSubviews([thumbnailImage, symbolLabel, nameLabel, rateLabel])
    }

    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }

        thumbnailImage.snp.makeConstraints { make in
            make.size.equalTo(28)
        }
    }

    override func configureView() {
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.05
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 6

        symbolLabel.font = SystemFont.Body.boldContent
        nameLabel.font = SystemFont.Body.small
        rateLabel.font = SystemFont.Body.boldSmall

        symbolLabel.textColor = .black
        nameLabel.textColor = .darkGray
    }
}

// MARK: - configure cell
extension CoinCollectionViewCell {
    func configureCell(with coin: CoinRankingViewData) {
        thumbnailImage.kf.setImage(with: URL(string: coin.imageURL))
        symbolLabel.text = coin.symbol
        nameLabel.text = coin.name
        updateRateLabel(with: coin.rate)
    }

    private func updateRateLabel(with number: Double) {
        let rounded = round(number * 100) / 100
        if rounded == 0.00 {
            rateLabel.textColor = .black
            rateLabel.text = "\(rounded)%"
        } else if rounded > 0 {
            rateLabel.textColor = SystemColor.red
            rateLabel.text = "▲ \(rounded)%"
        } else {
            rateLabel.textColor = SystemColor.green
            rateLabel.text = "▼ \(abs(rounded))%"
        }
    }
}
