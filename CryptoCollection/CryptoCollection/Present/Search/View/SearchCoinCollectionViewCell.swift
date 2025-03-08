//
//  CoinCollectionViewCell.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/8/25.
//

import UIKit
import Kingfisher
import SnapKit
import RealmSwift

final class SearchCoinCollectionViewCell: BaseCollectionViewCell, ReuseIdentifiable {
    let image = CircleImage(frame: .zero)
    let symbol = UILabel()
    let name = UILabel()
    let rank = UILabel()
    let favorite = UIButton()

    override func configureHierarchy() {
        [image, symbol, name, rank, favorite].forEach { contentView.addSubview($0) }
    }

    override func configureLayout() {
        image.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(24)
            make.size.equalTo(36)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
        }
        symbol.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(20)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide).offset(-8)
        }
        name.snp.makeConstraints { make in
            make.leading.equalTo(symbol)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide).offset(8)
        }
        rank.snp.makeConstraints { make in
            make.leading.equalTo(symbol.snp.trailing).offset(8)
            make.centerY.equalTo(symbol)
        }
        favorite.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(24)
            make.size.equalTo(20)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
        }
    }

    override func configureView() {
        symbol.font = .boldSystemFont(ofSize: 14)
        name.font = .systemFont(ofSize: 12)
        rank.font = .boldSystemFont(ofSize: 9)
        name.textColor = UIColor.customGray

        image.image = UIImage(systemName: "person.fill")
        symbol.text = "BTC"
        name.text = "Bitcoin"
        rank.text = "#1"
        favorite.setImage(UIImage(systemName: "start"), for: .normal)
        favorite.tintColor = .customBlack
    }
}
