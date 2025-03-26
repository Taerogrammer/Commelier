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
import RxSwift
import Toast

final class SearchCoinCollectionViewCell: BaseCollectionViewCell, ReuseIdentifiable {
    var disposeBag = DisposeBag()
    private let image = CircleImage(frame: .zero)
    private let symbol = UILabel()
    private let name = UILabel()
    private let rank = rankLabel()
    let favoriteButton = UIButton()
    private var viewModel: SearchCoinCollectionCellViewModel?
    private let realm = try! Realm()
    private var blueStyle = ToastStyle()
    private var redStyle = ToastStyle()

    override func configureHierarchy() {
        [image, symbol, name, rank, favoriteButton].forEach { contentView.addSubview($0) }
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
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(24)
            make.size.equalTo(20)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
        }
    }

    override func configureView() {
        symbol.font = .boldSystemFont(ofSize: 14)
        name.font = .systemFont(ofSize: 12)
        name.textColor = UIColor.customGray
        favoriteButton.setImage(SystemIcon.heart, for: .normal)
        favoriteButton.tintColor = UIColor.customBlack
        blueStyle.messageColor = UIColor.customBlue
        redStyle.messageColor = UIColor.customRed
    }

    // 중첩 구독 방지
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }

    func bind(with viewModel: SearchCoinCollectionCellViewModel) {
        self.viewModel = viewModel
        let input = SearchCoinCollectionCellViewModel.Input(
            favoriteButtonTapped: favoriteButton.rx.tap)
        let output = viewModel.transform(input: input)

        output.favoriteButtonResult
            .bind(with: self) { owner, action in
                let scenes = UIApplication.shared.connectedScenes
                guard let windowScene = scenes.first as? UIWindowScene, let window = windowScene.windows.last else { return }

                switch action {
                case .itemAdded:

                    window.rootViewController?.view.makeToast("즐겨찾기에서 추가되었습니다",
                                                              duration: 2.0,
                                                              position: .top,
                                                              style: owner.blueStyle)
                case .itemDeleted:
                    window.rootViewController?.view.makeToast("즐겨찾기에서 제거되었습니다",
                                                              duration: 2.0,
                                                              position: .top,
                                                              style: owner.redStyle)
                }
                owner.updateFavoriteButton(id: owner.viewModel?.coinData.id ?? "")
            }
            .disposed(by: disposeBag)
    }
}


// MARK: - configure cell
extension SearchCoinCollectionViewCell {
    func configureCell(with item: CoinData) {
        image.kf.setImage(with: URL(string: item.thumb))
        symbol.text = item.symbol
        name.text = item.name
        if let rankInt = item.market_cap_rank { rank.text = "#\(rankInt)" }
        updateFavoriteButton(id: item.id)
    }

    func updateFavoriteButton(id: String) {
        let isLiked = realm.objects(FavoriteCoin.self).filter("id == %@", id).first != nil
        favoriteButton.setImage(UIImage(systemName: isLiked ? "star.fill" : "star"), for: .normal)

        favoriteButton.setImage(isLiked ? SystemIcon.heartFilled : SystemIcon.heart, for: .normal)
    }
}
