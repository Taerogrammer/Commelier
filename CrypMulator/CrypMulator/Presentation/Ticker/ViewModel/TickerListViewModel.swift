//
//  TickerViewModel.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import RxCocoa
import RxSwift
import RxGesture

final class TickerListViewModel: ViewModel {
    private var disposable: Disposable?
    private let disposeBag = DisposeBag()
    private let data = PublishRelay<[UpbitMarketEntity]>()
    private let buttonStatus = BehaviorRelay<ButtonStatus>(value: ButtonStatus(
        price: .unClicked,
        changedPrice: .unClicked,
        acc: .unClicked))
    private let errorRelay = PublishRelay<APIError>()

    // 외부에서 사용할 에러 stream
    var errorStream: Observable<APIError> {
        return errorRelay.asObservable()
    }

    struct Input {
        let priceTapped: TapControlEvent
        let changedPriceTapped: TapControlEvent
        let accTapped: TapControlEvent
    }

    struct Output {
        let data: Observable<[UpbitMarketEntity]>
        let buttonStatus: Observable<ButtonStatus>
        let error: Observable<APIError>
    }

    func transform(input: Input) -> Output {
        input.priceTapped
            .when(.recognized)
            .subscribe(with: self) { owner, _ in
                owner.buttonConfigure(button: .price)
            }
            .disposed(by: disposeBag)

        input.changedPriceTapped
            .when(.recognized)
            .subscribe(with: self) { owner, _ in
                owner.buttonConfigure(button: .changedPrice)
            }
            .disposed(by: disposeBag)

        input.accTapped
            .when(.recognized)
            .subscribe(with: self) { owner, _ in
                owner.buttonConfigure(button: .acc)
            }
            .disposed(by: disposeBag)

        let sortedData = Observable
            .combineLatest(data, buttonStatus)
            .map { data, buttonStatus in
                return self.sortData(data: data, status: buttonStatus)
            }
            .asObservable()

        return Output(data: sortedData,
                      buttonStatus: buttonStatus.asObservable(),
                      error: errorRelay.asObservable())
    }

    func getDataByTimer() {
        disposeTimer()
        disposable = Observable<Int>.interval(.seconds(2), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .startWith(0)
            .subscribe(with: self) { owner, val in
                NetworkManager.shared.getItem(
                    api: UpbitRouter.getMarket(), type: [UpbitMarketEntity].self)
                .subscribe(with: owner) { owner, value in
                    owner.data.accept(value)
                } onFailure: { owner, error in
                    owner.errorRelay.accept(error as! APIError)
                }
                .disposed(by: owner.disposeBag)
            }
    }

    func disposeTimer() {
        disposable?.dispose()
    }

    private func buttonConfigure(button: ButtonType) {
        let currentStatus = buttonStatus.value
        let newStatus: ButtonStatus

        switch button {
        case .price:
            newStatus = ButtonStatus(
                price: changeStatus(currentStatus: currentStatus.price),
                changedPrice: .unClicked,
                acc: .unClicked)
        case .changedPrice:
            newStatus = ButtonStatus(
                price: .unClicked,
                changedPrice: changeStatus(currentStatus: currentStatus.changedPrice),
                acc: .unClicked)
        case .acc:
            newStatus = ButtonStatus(
                price: .unClicked,
                changedPrice: .unClicked,
                acc: changeStatus(currentStatus: currentStatus.acc))
        }
        buttonStatus.accept(newStatus)
    }

    private func changeStatus(currentStatus: CoinFilterButtonStatus) -> CoinFilterButtonStatus {
        switch currentStatus {
        case .unClicked:
            return .downClicked
        case .upClicked:
            return .unClicked
        case .downClicked:
            return .upClicked
        }
    }

    private func sortData(data: [UpbitMarketEntity], status: ButtonStatus) -> [UpbitMarketEntity] {
        if status.price == .unClicked && status.changedPrice == .unClicked && status.acc == .unClicked {
            return data.sorted { $0.acc_trade_price_24h > $1.acc_trade_price_24h }
        } else {
            switch status.price {
            case .unClicked: break
            case .upClicked:
                return data.sorted { $0.trade_price < $1.trade_price }
            case .downClicked:
                return data.sorted { $0.trade_price > $1.trade_price }
            }
            switch status.changedPrice {
            case .unClicked: break
            case .upClicked:
                return data.sorted { $0.signed_change_rate < $1.signed_change_rate }
            case .downClicked:
                return data.sorted { $0.signed_change_rate > $1.signed_change_rate }
            }
            switch status.acc {
            case .unClicked: break
            case .upClicked:
                return data.sorted { $0.acc_trade_price_24h < $1.acc_trade_price_24h }
            case .downClicked:
                return data.sorted { $0.acc_trade_price_24h > $1.acc_trade_price_24h }
            }
        }
        return []
    }
}

enum ButtonType {
    case price
    case changedPrice
    case acc
}

struct ButtonStatus {
    let price: CoinFilterButtonStatus
    let changedPrice: CoinFilterButtonStatus
    let acc: CoinFilterButtonStatus
}
