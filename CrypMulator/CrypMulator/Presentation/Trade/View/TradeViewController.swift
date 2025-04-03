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

    private lazy var currentPriceView = TradeInfoView(
        type: type,
        name: titleEntity.title)

    private let amountLabel = UILabel()
    private let warningLabel = UILabel()

    private let numberPadView = CustomNumberPadView()

    private lazy var actionButton = ActionButton(title: type.title,
                                            backgroundColor: type.buttonColor)

    init(viewModel: TradeViewModel, titleEntity: NavigationTitleEntity, type: OrderType) {
        self.viewModel = viewModel
        self.titleEntity = titleEntity
        self.type = type
        super.init()
    }

    override func configureHierarchy() {
        view.addSubviews([
            currentPriceView,
            amountLabel,
            warningLabel,
            numberPadView,
            actionButton
        ])
    }

    override func configureLayout() {
        currentPriceView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(currentPriceView.snp.width).multipliedBy(0.6)
        }

        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(currentPriceView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }

        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }

        numberPadView.snp.makeConstraints { make in
            make.top.equalTo(warningLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.equalTo(actionButton.snp.top).inset(-24)
        }

        actionButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(48)
        }
    }

    override func configureView() {
        amountLabel.text = StringLiteral.Trade.defaultString
        amountLabel.font = SystemFont.Title.xLarge
        amountLabel.textAlignment = .center

        warningLabel.text = StringLiteral.Trade.warning
        warningLabel.textColor = SystemColor.red
        warningLabel.font = SystemFont.Body.primary
        warningLabel.textAlignment = .center
        warningLabel.isHidden = true
    }

    override func configureNavigation() {
        let titleView = NavigationTitleView(entity: titleEntity)
        navigationItem.titleView = titleView
        navigationItem.leftBarButtonItem = barButton
        navigationItem.rightBarButtonItem = favoriteButton
    }

    override func bind() {
        let barButtonTapped = barButton.tapPublisher
        let actionButtonTapped = actionButton.tapPublisher
        let input = TradeViewModel.Input(
            barButtonTapped: barButtonTapped,
            numberInput: numberPadView.buttonTapped.eraseToAnyPublisher(),
            tradeButtonTapped: actionButtonTapped)
        let output = viewModel.transform(input: input)

        output.action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .pop:
                    self?.navigationController?.popViewController(animated: true)
                case .tradeCompleted(let success):
                    self?.presentTradeResultAlert(success: success)
                }
            }
            .store(in: &cancellables)

        output.ticker
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ticker in
                self?.currentPriceView.updateCurrentPrice(with: ticker)
            }
            .store(in: &cancellables)

        output.availableCurrency
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currency in
                self?.currentPriceView.updateBalance(amount: currency)
            }
            .store(in: &cancellables)

        output.inputAmountText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.amountLabel.text = text
            }
            .store(in: &cancellables)

        output.shouldShowWarning
            .receive(on: DispatchQueue.main)
            .sink { [weak self] show in
                self?.warningLabel.isHidden = !show
            }
            .store(in: &cancellables)

        output.isLivePriceLoaded
            .receive(on: DispatchQueue.main)
            .sink { isLoaded in
                if !isLoaded {
                    LoadingIndicator.showLoading()
                } else {
                    LoadingIndicator.hideLoading()
                }
            }
            .store(in: &cancellables)

        output.isTradeButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.actionButton.isEnabled = isEnabled
                self?.actionButton.alpha = isEnabled ? 1.0 : 0.5
            }
            .store(in: &cancellables)

        let repo = ChargeRepository()
        repo.getFileURL()
    }

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

    private func presentTradeResultAlert(success: Bool) {
        let title = success ? StringLiteral.Trade.success : StringLiteral.Trade.failure
        let message = success ? StringLiteral.Trade.successMessage : StringLiteral.Trade.failureMessage

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringLiteral.Button.confirm, style: .default))
        present(alert, animated: true)
    }
}
