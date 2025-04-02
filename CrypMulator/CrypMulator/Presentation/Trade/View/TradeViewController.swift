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

    private lazy var currentPriceView = TradeInfoView(type: type)

    private let numberPadView = CustomNumberPadView()
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = SystemFont.Title.xLarge
        label.textAlignment = .center
        return label
    }()

    private var inputAmount: String = "0" {
        didSet {
            if let amount = Decimal(string: inputAmount) {
                amountLabel.text = FormatUtility.decimalToString(amount)
            }
        }
    }

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

        numberPadView.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.equalTo(actionButton.snp.top).inset(-24)
        }

        actionButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(48)
        }
    }

    override func configureView() {
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
        let output = viewModel.transform(input: input)

        output.action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .pop:
                    self?.navigationController?.popViewController(animated: true)
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

        numberPadView.buttonTapped
            .sink { [weak self] value in
                guard let self = self else { return }

                switch value {
                case "←":
                    self.inputAmount = String(self.inputAmount.dropLast())
                    if self.inputAmount.isEmpty { self.inputAmount = "0" }
                default:
                    if self.inputAmount == "0" {
                        self.inputAmount = value
                    } else {
                        self.inputAmount += value
                    }
                }
            }
            .store(in: &cancellables)
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
}
