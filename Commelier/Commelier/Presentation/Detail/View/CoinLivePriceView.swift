//
//  CoinSummaryView.swift
//  CrypMulator
//
//  Created by 김태형 on 3/30/25.
//

import Combine
import UIKit
import NumberterKit
import SnapKit

final class CoinLivePriceView: BaseView {
    private var viewModel: CoinLivePriceViewModel?
    private var cancellables = Set<AnyCancellable>()
    private let priceLabel = UILabel()
    private let changePriceLabel = UILabel()
    private let changeRate = UILabel()

    init(viewModel: CoinLivePriceViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
    }

    override func configureHierarchy() {
        addSubviews([priceLabel, changePriceLabel, changeRate])
    }

    override func configureLayout() {
        priceLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
        }
        changePriceLabel.snp.makeConstraints { make in
            make.leading.equalTo(priceLabel.snp.trailing).offset(16)
            make.bottom.equalTo(priceLabel)
        }
        changeRate.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
        }
    }

    override func configureView() {
        priceLabel.font = SystemFont.Title.large
        changePriceLabel.font = SystemFont.Body.primary
        changeRate.font = SystemFont.Body.boldContent
    }

    override func bind() {
        let input = CoinLivePriceViewModel.Input()
        let output = viewModel?.transform(input: input)

        output?.ticker
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ticker in
                self?.configure(with: ticker)
            }
            .store(in: &cancellables)
    }
}

// MARK: - configure
extension CoinLivePriceView {
    private func configure(with entity: LivePriceEntity) {
        priceLabel.text = StringLiteral.Currency.wonMark + Int64(entity.price).formatted
        changePriceLabel.text = Int64(entity.signedChangePrice).formatted
        changeRate.text = entity.priceChangeState.symbol + (entity.signedChangeRate * 100.0).description + StringLiteral.Operator.percentage
        changeRate.textColor = entity.priceChangeState.color
    }
}
