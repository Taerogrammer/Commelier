//
//  TradeViewController.swift
//  CrypMulator
//
//  Created by 김태형 on 4/1/25.
//

import Combine
import UIKit
import SnapKit

final class TradeViewController: BaseViewController {

    private let type: OrderType
    private let viewModel: TradeViewModel
    private var cancellables = Set<AnyCancellable>()

    private let titleEntity: NavigationTitleEntity
    private let barButton = UIBarButtonItem(
        image: SystemIcon.arrowLeft,
        style: .plain,
        target: nil,
        action: nil)
    private let favoriteButton = UIBarButtonItem()

    private let currentPriceView = TradeContainerView(title: StringLiteral.Trade.currentPrice)
    private let currentPriceLabel = UILabel()

    private lazy var buySellView = TradeContainerView(title: type.priceTitle)
    private let buySellPriceLabel = UILabel()

    private lazy var amountButtons: [UIButton] = [
        "100,000 만원", "50,000 만원", "1,000 만원", "100만원"
    ].map { makeSelectionButton(title: $0) }

    private lazy var percentButtons: [UIButton] = [
        "100%", "50%", "25%", "10%"
    ].map { makeSelectionButton(title: $0) }

    private lazy var amountStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: amountButtons)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()

    private lazy var percentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: percentButtons)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()

    private let balanceView = TradeAmountInfoView(
        title: "보유자산",
        amountText: "1,000,000,000",
        unit: "KRW"
    )

    private let totalView = TradeAmountInfoView(
        title: "총",
        amountText: "0",
        unit: "BTC"
    )

    private lazy var actionButton = ActionButton(title: type.title,
                                            backgroundColor: type.buttonColor)

    init(viewModel: TradeViewModel, titleEntity: NavigationTitleEntity, type: OrderType) {
        self.viewModel = viewModel
        self.titleEntity = titleEntity
        self.type = type
        super.init()
    }

    override func configureHierarchy() {
        view.addSubviews([currentPriceView, buySellView, amountStackView, percentStackView, balanceView, totalView, actionButton])
        currentPriceView.addSubview(currentPriceLabel)
        buySellView.addSubview(buySellPriceLabel)
    }

    override func configureLayout() {
        currentPriceView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(currentPriceView.snp.width).multipliedBy(0.4)
        }
        currentPriceLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        buySellView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.top.equalTo(currentPriceView.snp.bottom).offset(12)
            make.height.equalTo(buySellView.snp.width).multipliedBy(0.4)
        }
        buySellPriceLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        amountStackView.snp.makeConstraints { make in
            make.top.equalTo(buySellView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(40)
        }

        percentStackView.snp.makeConstraints { make in
            make.top.equalTo(amountStackView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(40)
        }

        balanceView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(percentStackView.snp.bottom).offset(44)
        }

        totalView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(balanceView.snp.bottom).offset(28)
        }

        actionButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(48)
        }
    }

    override func configureView() {
        currentPriceLabel.font = SystemFont.Title.large
        currentPriceLabel.text = "총 1000"

        buySellPriceLabel.font = SystemFont.Title.large
        buySellPriceLabel.text = "100,000,000 KRW"
    }

    override func configureNavigation() {
        let titleView = NavigationTitleView(entity: titleEntity)
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = barButton
        navigationItem.rightBarButtonItem = favoriteButton
    }

    override func bind() {
        let barButtonTapped = barButton.tapPublisher
        let input = TradeViewModel.Input(
            barButtonTapped: barButtonTapped)
        // 여기부터
        let output = viewModel.transform(input: input)

        output.action
            .sink { [weak self] action in
                switch action {
                case .pop:
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &cancellables)

    }

    // TODO: - 버튼 색상 물어보기
    private func makeSelectionButton(title: String) -> UIButton {
        let button = UIButton()
        button.clipsToBounds = true
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = SystemFont.Body.content
        button.backgroundColor = SystemColor.white
        button.layer.borderWidth = 1
        button.layer.borderColor = SystemColor.black.cgColor
        button.layer.cornerRadius = 8
        return button
    }
}

