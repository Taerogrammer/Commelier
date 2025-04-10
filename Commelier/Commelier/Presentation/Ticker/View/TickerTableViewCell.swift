//
//  TickerTableViewCell.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/7/25.
//

import UIKit
import SnapKit
import RxSwift

final class TickerTableViewCell: BaseTableViewCell, ReuseIdentifiable {
    private var disposeBag = DisposeBag()
    let name = UILabel()
    let price = UILabel()
    let changeRate = UILabel()
    let changePrice = UILabel()
    let tradePrice = UILabel()

    override func configureHierarchy() {
        [name, price, changeRate, changePrice, tradePrice]
            .forEach { contentView.addSubview($0) }
    }

    override func configureLayout() {
        name.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.25)
        }
        price.snp.makeConstraints { make in
            make.trailing.equalTo(changeRate.snp.leading).offset(-8)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
        }
        changeRate.snp.makeConstraints { make in
            make.trailing.equalTo(tradePrice.snp.leading).offset(-8)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.2)
        }
        changePrice.snp.makeConstraints { make in
            make.trailing.equalTo(changeRate.snp.trailing)
            make.top.equalTo(changeRate.snp.bottom).offset(2)
            make.bottom.greaterThanOrEqualTo(contentView.safeAreaInsets).inset(4)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.15)
        }
        tradePrice.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.25)
        }

    }

    override func configureView() {
        backgroundColor = SystemColor.background

        name.font = SystemFont.Body.boldContent
        price.font = SystemFont.Body.content
        changeRate.font = SystemFont.Body.content
        changePrice.font = SystemFont.Body.small
        tradePrice.font = SystemFont.Body.content

        name.textAlignment = .left
        price.textAlignment = .right
        changeRate.textAlignment = .right
        changePrice.textAlignment = .right
        tradePrice.textAlignment = .right
    }

    func updateColor(number: Double) {

        if round(number * 100) / 100 == 0.00 {
            changeRate.textColor = SystemColor.label
            changePrice.textColor = SystemColor.label
        } else if round(number * 100) / 100 > 0 {
            changeRate.textColor = SystemColor.red
            changePrice.textColor = SystemColor.red
        } else {
            changeRate.textColor = SystemColor.green
            changePrice.textColor = SystemColor.green
        }
    }

    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }

}
