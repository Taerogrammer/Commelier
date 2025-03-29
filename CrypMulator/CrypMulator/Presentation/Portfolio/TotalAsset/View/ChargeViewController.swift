//
//  ChargeViewController.swift
//  CrypMulator
//
//  Created by 김태형 on 3/28/25.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class ChargeViewController: BaseViewController {
    private let viewModel = ChargeViewModel()
    private let disposeBag = DisposeBag()

    private let titleLabel = UILabel()
    private lazy var amountButtons: [UIButton] = {
        [1_000_000, 5_000_000, 10_000_000].map { amount in
            let button = UIButton()
            button.tag = amount // 태그로 금액 저장
            return button
        }
    }()

    private let amountLabel = UILabel()
    private let unitLabel = UILabel()
    private let chargeButton = UIButton()

    private lazy var buttonStack = UIStackView(arrangedSubviews: amountButtons)
    private lazy var amountContainer = UIStackView(arrangedSubviews: [amountLabel, unitLabel])

    override func configureHierarchy() {
        view.addSubviews([
            titleLabel,
            buttonStack,
            amountContainer,
            chargeButton
        ])
    }

    override func configureLayout() {
        amountButtons.forEach {
            $0.snp.makeConstraints { $0.height.equalTo(44) }
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
        }

        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        amountContainer.snp.makeConstraints { make in
            make.top.equalTo(buttonStack.snp.bottom).offset(36)
            make.centerX.equalToSuperview()
        }

        chargeButton.snp.makeConstraints { make in
            make.top.equalTo(amountContainer.snp.bottom).offset(48)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(52)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func configureView() {
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually

        amountContainer.axis = .horizontal
        amountContainer.spacing = 6
        amountContainer.alignment = .center

        titleLabel.text = StringLiteral.Portfolio.chargeQuestion
        titleLabel.font = SystemFont.Title.large
        titleLabel.textAlignment = .center

        for button in amountButtons {
            let amount = button.tag
            button.setTitle("\(FormatUtility.formatAmount(amount)) \(StringLiteral.Currency.won)", for: .normal)
            button.setTitleColor(SystemColor.black, for: .normal)
            button.backgroundColor = SystemColor.whiteGray
            button.titleLabel?.font = SystemFont.Body.content
            button.layer.cornerRadius = 8
        }

        amountLabel.text = "0"
        amountLabel.font = SystemFont.Title.xLarge
        amountLabel.textAlignment = .center

        unitLabel.text = StringLiteral.Currency.won
        unitLabel.font = .systemFont(ofSize: 18, weight: .medium)

        chargeButton.setTitle(StringLiteral.Button.charge, for: .normal)
        chargeButton.setTitleColor(SystemColor.white, for: .normal)
        chargeButton.backgroundColor = SystemColor.blue
        chargeButton.layer.cornerRadius = 16
        chargeButton.titleLabel?.font = SystemFont.Title.small
    }

    override func bind() {
        let amountTaps = Signal.merge(
            amountButtons.enumerated().map { index, button in
                button.rx.tap
                    .map { [1_000_000, 5_000_000, 10_000_000][index] }
                    .asSignal(onErrorJustReturn: 0)
            }
        )

        let input = ChargeViewModel.Input(
            chargeTapped: chargeButton.rx.tap.asSignal(),
            amountSelected: amountTaps
        )

        let output = viewModel.transform(input: input)

        output.amountText
            .drive(amountLabel.rx.text)
            .disposed(by: disposeBag)

        output.action
            .emit(with: self) { owner, action in
                switch action {
                case .dismiss:
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
