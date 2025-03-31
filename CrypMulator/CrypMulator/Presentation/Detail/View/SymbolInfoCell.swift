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
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(12)
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(4)
        }

        amountLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(-4)
        }
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(12)
            make.top.equalTo(amountLabel.snp.bottom).offset(-4)
        }
    }

    override func configureView() {
        titleLabel.font = SystemFont.Body.content
        amountLabel.font = SystemFont.Body.boldPrimary
        dateLabel.font = SystemFont.Body.small

        titleLabel.textColor = SystemColor.gray
        amountLabel.textColor = SystemColor.black
        dateLabel.textColor = SystemColor.gray

        backgroundColor = SystemColor.whiteGray

        contentView.layer.cornerRadius = 4
        contentView.layer.masksToBounds = true
        contentView.layer.backgroundColor = UIColor.clear.cgColor
        layer.cornerRadius = 4
        layer.masksToBounds = false
        layer.shadowColor = SystemColor.black.cgColor
    }
}
