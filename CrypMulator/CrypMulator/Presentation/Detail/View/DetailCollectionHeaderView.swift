//
//  DetailCollectionHeaderView.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/9/25.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class DetailCollectionHeaderView: UICollectionReusableView, ReuseIdentifiable {

    private let titleLabel = UILabel()
    let moreButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - configure view
extension DetailCollectionHeaderView: ViewConfiguration {
    func configureHierarchy() {
        [titleLabel, moreButton].forEach { addSubview($0) }
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
        moreButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).inset(36)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func configureView() {
        titleLabel.font = .boldSystemFont(ofSize: 12)
        titleLabel.textColor = SystemColor.black
        moreButton.setTitle("더보기 ", for: .normal)
        let image = SystemIcon.chevronRight.resizeImageTo(size: CGSize(width: 12, height: 12))
        moreButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        moreButton.setImage(image, for: .normal)
        moreButton.semanticContentAttribute = .forceRightToLeft
        moreButton.setTitleColor(SystemColor.gray, for: .normal)
    }

    func configureTitle(with title: String) {
        titleLabel.text = title
    }
}
