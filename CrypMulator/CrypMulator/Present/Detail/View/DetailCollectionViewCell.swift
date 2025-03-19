//
//  DetailCollectionViewCell.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/8/25.
//

import UIKit
import SnapKit
import RxSwift

final class DetailCollectionViewCell: BaseCollectionViewCell, ReuseIdentifiable {
    private var disposeBag = DisposeBag()
    let title = UILabel()
    let money = UILabel()
    let date = UILabel()

    override func configureHierarchy() {
        [title, money, date].forEach { contentView.addSubview($0) }
    }

    override func configureLayout() {
        title.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(12)
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(4)
        }
        money.snp.makeConstraints { make in
            make.leading.equalTo(title)
            make.top.equalTo(title.snp.bottom).inset(-4)
        }
        date.snp.makeConstraints { make in
            make.leading.equalTo(title)
            make.top.equalTo(money.snp.bottom).inset(-4)
        }
    }

    override func configureView() {
        title.font = .systemFont(ofSize: 9)
        money.font = .boldSystemFont(ofSize: 12)
        date.font = .systemFont(ofSize: 6)
        title.textColor = UIColor.customGray
        money.textColor = UIColor.customBlack
        date.textColor = UIColor.customGray
        backgroundColor = UIColor.customWhiteGray

        contentView.layer.cornerRadius = 4
        contentView.layer.masksToBounds = true
        contentView.layer.backgroundColor = UIColor.clear.cgColor
        layer.cornerRadius = 4
        layer.masksToBounds = false
        layer.shadowColor = UIColor.customBlack.cgColor
    }
}
