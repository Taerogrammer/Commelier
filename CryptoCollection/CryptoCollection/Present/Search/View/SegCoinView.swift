//
//  SegCoinView.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/8/25.
//

import UIKit
import SnapKit

final class SegCoinView: BaseView {
    lazy var coinCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createFlowLayout())

    override func configureHierarchy() {
        self.addSubview(coinCollectionView)
    }

    override func configureLayout() {
        coinCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }

    override func configureView() {
        coinCollectionView.showsVerticalScrollIndicator = false
    }
}

// MARK: - collection view
extension SegCoinView {
    private func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 48.0)
        layout.scrollDirection = .vertical

        return layout
    }
}
