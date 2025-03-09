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
    let rank = UILabel()
    let image = CircleImage(frame: .zero)
    let symbol = UILabel()
    let name = UILabel()
    let rate = UILabel()

    override func configureHierarchy() {
        [rank, image, symbol, name, rate].forEach { contentView.addSubview($0) }
    }

    override func configureLayout() {
        rank.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
        image.snp.makeConstraints { make in
            make.leading.equalTo(rank.snp.trailing).offset(8)
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(26)
        }
        symbol.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(4)
            make.centerY.equalTo(safeAreaLayoutGuide).offset(-4)
        }
        name.snp.makeConstraints { make in
            make.leading.equalTo(symbol)
            make.centerY.equalTo(safeAreaLayoutGuide).offset(4)
        }
        rate.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).inset(12)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
    }

    override func configureView() {
        rank.font = .systemFont(ofSize: 12)
        symbol.font = .boldSystemFont(ofSize: 12)
        name.font = .systemFont(ofSize: 9)
        rate.font = .boldSystemFont(ofSize: 9)
    }
}

// MARK: - configure cell
extension CoinCollectionViewCell {
    func configureCell(with coin: TrendingCoin) {
        rank.text = coin.rank
        image.kf.setImage(with: URL(string: coin.imageURL))
        symbol.text = coin.symbol
        name.text = coin.name
        // 우선
        rate.text = coin.rate.formatted()
    }
}
