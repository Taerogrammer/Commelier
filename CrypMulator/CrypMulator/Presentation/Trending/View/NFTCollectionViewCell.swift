//
//  NFTCollectionViewCell.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/7/25.
//

import UIKit
import Kingfisher
import SnapKit

final class NFTCollectionViewCell: BaseCollectionViewCell, ReuseIdentifiable {
    let image = UIImageView()
    let symbol = UILabel()
    let floorPrice = UILabel()
    let floorPricePercentage = UILabel()

    override func configureHierarchy() {
        [image, symbol, floorPrice, floorPricePercentage].forEach { contentView.addSubview($0) }
    }

    override func configureLayout() {
        image.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(4)
            make.top.equalTo(safeAreaLayoutGuide).inset(8)
            make.size.equalTo(72)
        }
        symbol.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).inset(6)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-6)
            make.top.equalTo(image.snp.bottom).offset(4)
        }
        floorPrice.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(symbol.snp.bottom).offset(4)
        }
        floorPricePercentage.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(floorPrice.snp.bottom).offset(4)
        }
    }

    override func configureView() {
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 8
        symbol.font = .boldSystemFont(ofSize: 9)
        symbol.textColor = UIColor.customBlack
        symbol.textAlignment = .center
        floorPrice.font = .systemFont(ofSize: 9)
        floorPrice.textColor = UIColor.customGray
        floorPricePercentage.font = .boldSystemFont(ofSize: 9)
    }
}

// MARK: - configure cell
extension NFTCollectionViewCell {
    func configureCell(with nft: TrendingNFT) {
        image.kf.setImage(with: URL(string: nft.imageURL))
        symbol.text = nft.name
        floorPrice.text = nft.floorPrice
        updateFloorPricePercentageLabel(rate: nft.floorPriceChange)
    }

    private func updateFloorPricePercentageLabel(rate: String) {
        let doubleTypeRate = Double(rate) ?? 0.0
        if doubleTypeRate > 0.0 {
            floorPricePercentage.textColor = UIColor.customRed
            floorPricePercentage.text = "▲ \(rate)%"
        } else if doubleTypeRate == 0.0 {
            floorPricePercentage.textColor = UIColor.customBlack
            floorPricePercentage.text = "\(rate)%"
        } else {
            floorPricePercentage.textColor = UIColor.customBlue
            floorPricePercentage.text = "▼ \(rate)%"
        }
    }
}
