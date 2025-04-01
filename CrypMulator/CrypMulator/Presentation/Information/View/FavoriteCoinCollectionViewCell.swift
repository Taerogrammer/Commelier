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

// TODO: - Realm 수정 필요
final class FavoriteCoinCollectionViewCell: BaseCollectionViewCell, ReuseIdentifiable {
    var disposeBag = DisposeBag()
    private let image = CircleImage(frame: .zero)
    private let transactionQuantity = UILabel()
    private let name = UILabel()
    private let favoriteButton = UIButton()
    private var viewModel: SearchCoinCollectionCellViewModel?
    private let realm = try! Realm()
    private var blueStyle = ToastStyle()
    private var redStyle = ToastStyle()

    override func configureHierarchy() {
        contentView.addSubviews([image, name, transactionQuantity, favoriteButton])
    }

    override func configureLayout() {
        image.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.size.equalTo(36)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
        }
        transactionQuantity.snp.makeConstraints { make in
            make.leading.equalTo(name)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide).offset(9)
        }
        name.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(20)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide).offset(-9)
        }
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.size.equalTo(28)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
        }
    }

    override func configureView() {
        name.font = SystemFont.Body.boldPrimary
        transactionQuantity.font = SystemFont.Body.content
        transactionQuantity.textColor = SystemColor.gray
        favoriteButton.setImage(SystemIcon.heart, for: .normal)
        favoriteButton.tintColor = SystemColor.black
        blueStyle.messageColor = SystemColor.blue
        redStyle.messageColor = SystemColor.red
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

                    window.rootViewController?.view.makeToast(StringLiteral.FavoriteMessage.add,
                                                              duration: 2.0,
                                                              position: .top,
                                                              style: owner.blueStyle)
                case .itemDeleted:
                    window.rootViewController?.view.makeToast(StringLiteral.FavoriteMessage.remove,
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
extension FavoriteCoinCollectionViewCell {
    func configureCell(with item: CoinSearchData) {
        image.kf.setImage(with: URL(string: item.thumb))
        name.text = item.symbol
        transactionQuantity.text = "0.000015 BTC"
        updateFavoriteButton(id: item.id)
    }

    func updateFavoriteButton(id: String) {
        let isLiked = realm.objects(OldFavoriteCoin.self).filter("id == %@", id).first != nil
        favoriteButton.setImage(isLiked ? SystemIcon.heartFilled : SystemIcon.heart, for: .normal)
    }
}
