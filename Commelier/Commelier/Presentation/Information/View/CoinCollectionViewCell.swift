//
//  CoinCollectionViewCell.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/7/25.
//

import UIKit
import Kingfisher
import RxSwift
import SnapKit

final class CoinCollectionViewCell: BaseCollectionViewCell, ReuseIdentifiable {
    private var disposeBag = DisposeBag()

    private let rankLabel = UILabel()
    private let marketCapRankLabel = UILabel()
    private let thumbnailImage = CircleImage(frame: .zero)

    private let rateLabel = UILabel()
    private let volumeLabel = UILabel()

    private let symbolLabel = UILabel()
    private let nameLabel = UILabel()
    private let marketCapLabel = UILabel()

    private let stackView = UIStackView()

    override func configureHierarchy() {
        // 순위 + 마켓 랭크
        let rankRow = UIStackView(arrangedSubviews: [rankLabel, UIView(), marketCapRankLabel])
        rankRow.axis = .horizontal
        rankRow.alignment = .center

        // 퍼센트 + Vol 수직 스택
        let rateVolumeStack = UIStackView(arrangedSubviews: [rateLabel, volumeLabel])
        rateVolumeStack.axis = .vertical
        rateVolumeStack.alignment = .trailing
        rateVolumeStack.spacing = 2

        // 썸네일 + 오른쪽 정보 수평 스택
        let thumbnailRow = UIStackView(arrangedSubviews: [thumbnailImage, rateVolumeStack])
        thumbnailRow.axis = .horizontal
        thumbnailRow.alignment = .center
        thumbnailRow.spacing = 8

        // 심볼 + 이름 수직
        let labelStack = UIStackView(arrangedSubviews: [symbolLabel, nameLabel])
        labelStack.axis = .vertical
        labelStack.alignment = .leading
        labelStack.spacing = 2

        // 전체 스택
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.addArrangedSubviews([
            rankRow,
            thumbnailRow,
            labelStack,
            marketCapLabel
        ])

        contentView.addSubview(stackView)
    }

    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }

        thumbnailImage.snp.makeConstraints { make in
            make.size.equalTo(36)
        }

        marketCapRankLabel.setContentHuggingPriority(.required, for: .horizontal)
        marketCapRankLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    override func configureView() {
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = SystemColor.card

        rankLabel.font = SystemFont.Title.medium
        rankLabel.textColor = SystemColor.label

        marketCapRankLabel.font = SystemFont.Body.content
        marketCapRankLabel.textColor = SystemColor.whiteGray

        thumbnailImage.contentMode = .scaleAspectFill
        thumbnailImage.clipsToBounds = true

        rateLabel.font = SystemFont.Body.boldContent
        rateLabel.textColor = SystemColor.label
        rateLabel.textAlignment = .right

        volumeLabel.font = SystemFont.Body.content
        volumeLabel.textColor = SystemColor.label
        volumeLabel.textAlignment = .right

        symbolLabel.font = SystemFont.Body.boldContent
        symbolLabel.textColor = SystemColor.label

        nameLabel.font = SystemFont.Body.small
        nameLabel.textColor = SystemColor.label

        marketCapLabel.font = SystemFont.Body.boldSmall
        marketCapLabel.textColor = SystemColor.label
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func configureCell(with coin: CoinRankingViewData) {
        rankLabel.text = coin.rank
        marketCapRankLabel.text = "#\(coin.marketCapRank)"
        thumbnailImage.kf.setImage(with: URL(string: coin.imageURL))
        symbolLabel.text = coin.symbol
        nameLabel.text = coin.name
        rateLabel.text = formatRate(coin.rate)
        volumeLabel.text = "Vol: \(coin.totalVolume.formattedShortNumber())"
        marketCapLabel.text = "Total: \(coin.marketCap.formattedShortNumber())"
    }

    private func formatRate(_ number: Double) -> String {
        let rounded = round(number * 100) / 100
        if rounded == 0 {
            rateLabel.textColor = .black
            return "\(rounded)%"
        } else if rounded > 0 {
            rateLabel.textColor = .systemRed
            return "▲ \(rounded)%"
        } else {
            rateLabel.textColor = .systemGreen
            return "▼ \(abs(rounded))%"
        }
    }
}

extension String {
    func formattedShortNumber() -> String {
        guard let value = Double(self.filter("0123456789.".contains)) else {
            return self
        }

        let absValue = abs(value)
        switch absValue {
        case 1_000_000_000_000...:
            return String(format: "$%.2fT", value / 1_000_000_000_000)
        case 1_000_000_000...:
            return String(format: "$%.2fB", value / 1_000_000_000)
        case 1_000_000...:
            return String(format: "$%.2fM", value / 1_000_000)
        case 1_000...:
            return String(format: "$%.2fK", value / 1_000)
        default:
            return String(format: "$%.0f", value)
        }
    }
}
