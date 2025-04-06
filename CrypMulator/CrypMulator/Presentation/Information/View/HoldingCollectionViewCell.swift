//
//  CoinCollectionViewCell.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/8/25.
//

import UIKit
import Kingfisher
import SnapKit
import RxSwift

final class HoldingCollectionViewCell: BaseCollectionViewCell, ReuseIdentifiable {
    var disposeBag = DisposeBag()
    private let image = CircleImage(frame: .zero)
    private let transactionQuantity = UILabel()
    private let nameLabel = UILabel()

    override func configureHierarchy() {
        contentView.addSubviews([image, nameLabel, transactionQuantity/*, favoriteButton*/])
    }

    override func configureLayout() {
        image.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.size.equalTo(36)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
        }
        transactionQuantity.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide).offset(9)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(20)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide).offset(-9)
        }
    }

    override func configureView() {
        nameLabel.font = SystemFont.Body.boldPrimary
        transactionQuantity.font = SystemFont.Body.content
        transactionQuantity.textColor = SystemColor.gray
    }

    // 중첩 구독 방지
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }

}


// MARK: - configure cell
extension HoldingCollectionViewCell {
    func configureCell(with item: HoldingEntity) {
        if let urlString = item.imageURL, let url = URL(string: urlString) {
            image.kf.setImage(with: url, placeholder: UIImage(systemName: "bitcoinsign.circle"))
        } else {
            image.image = UIImage(systemName: "bitcoinsign.circle")
        }

        nameLabel.text = item.symbol.uppercased()
        transactionQuantity.text = "\(item.transactionQuantity.rounded(scale: 6)) \(item.symbol.uppercased())"
    }
}
