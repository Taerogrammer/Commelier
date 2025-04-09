//
//  ChargeViewModel.swift
//  CrypMulator
//
//  Created by 김태형 on 3/28/25.
//

import Foundation
import RxCocoa
import RxSwift

final class ChargeViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    private let chargeRepository: ChargeRepositoryProtocol

    init(repository: ChargeRepositoryProtocol = ChargeRepository()) {
        self.chargeRepository = repository
    }

    enum Action {
        case dismiss
    }

    struct Input {
        let chargeTapped: Signal<Void>
        let amountSelected: Signal<Int>
    }

    struct Output {
        let amountText: Driver<String>
        let action: Signal<Action>
        let isButtonEnabled: Driver<Bool>
        let showLimitReached: Signal<Void>
    }

    private let selectedAmount = BehaviorRelay<Int>(value: 0)
    private let actionRelay = PublishRelay<Action>()
    private let limitReachedRelay = PublishRelay<Void>()

    func transform(input: Input) -> Output {
        let maxAmount = 100_000_000

        // 금액 버튼 클릭
        input.amountSelected
            .emit(with: self) { owner, amount in
                let current = owner.selectedAmount.value

                if current >= maxAmount {
                    owner.limitReachedRelay.accept(())
                    return
                }

                let newAmount = current + amount
                let capped = min(newAmount, maxAmount)

                if capped == maxAmount && newAmount > maxAmount {
                    owner.limitReachedRelay.accept(())
                }

                owner.selectedAmount.accept(capped)
            }
            .disposed(by: disposeBag)

        // 충전 버튼 클릭
        input.chargeTapped
            .emit(with: self) { owner, _ in
                let amount = Int64(owner.selectedAmount.value)
                let now = Int64(Date().timeIntervalSince1970)
                let entity = ChargeEntity(amount: amount, timestamp: now)
                owner.chargeRepository.saveCharge(entity)
                owner.actionRelay.accept(.dismiss)
            }
            .disposed(by: disposeBag)

        // 금액 표시 포맷
        let amountText = selectedAmount
            .map { FormatUtility.formatAmount($0) }
            .asDriver(onErrorJustReturn: "0")

        // 버튼 활성화 조건
        let isButtonEnabled = selectedAmount
            .map { $0 < maxAmount }
            .asDriver(onErrorJustReturn: false)

        return Output(
            amountText: amountText,
            action: actionRelay.asSignal(),
            isButtonEnabled: isButtonEnabled,
            showLimitReached: limitReachedRelay.asSignal()
        )
    }
}
