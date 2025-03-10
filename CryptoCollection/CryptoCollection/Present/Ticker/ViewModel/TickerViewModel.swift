//
//  TickerViewModel.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import RxCocoa
import RxSwift
import RxGesture

final class TickerViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    private var disposable: Disposable?
    private let data = PublishRelay<[UpbitMarketResponse]>()
    private let buttonStatus = BehaviorRelay<ButtonStatus>(value: ButtonStatus(
        price: .unClicked,
        changedPrice: .unClicked,
        acc: .unClicked))

    struct Input {
        let priceTapped: TapControlEvent
        let changedPriceTapped: TapControlEvent
        let accTapped: TapControlEvent
    }

    struct Output {
        let data: Observable<[UpbitMarketResponse]>
        let buttonStatus: Observable<ButtonStatus>
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

        // TODO: 방법 고민해보기
        /*
         .timer 메서드로 구현하면 0초부터 시작은 하나 늦게 호출됨.
         처음은 전자의 식으로 호출 후 5초 뒤부턴 timer 식 호출
         */
        getData()

        /*
         timer를 Disposable로 선언 후 명시적으로 dispose() 시켜줌
         */
        getDataByTimer()

        let sortedData = Observable
            .combineLatest(data, buttonStatus)
            .map { data, buttonStatus in
                return self.sortData(data: data, status: buttonStatus)
            }
            .asObservable()

        return Output(data: sortedData,
                      buttonStatus: buttonStatus.asObservable())
    }

    private func getData() {
        NetworkManager.shared.getItem(
            api: UpbitRouter.getMarket(),
            type: [UpbitMarketResponse].self)
        .subscribe(with: self) { owner, value in
            owner.data.accept(value)
        } onFailure: { owner, error in
            print("failed", error)
        } onDisposed: { owner in
            print("onDisposed")
        }
        .disposed(by: disposeBag)
    }

    func getDataByTimer() {
        disposeTimer()
        disposable = Observable<Int>.interval(.seconds(2), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(with: self) { owner, val in
                owner.getData()
            } onDisposed: { owner in
                print("Timer Disposed")
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

    private func sortData(data: [UpbitMarketResponse], status: ButtonStatus) -> [UpbitMarketResponse] {
        if status.price == .unClicked && status.changedPrice == .unClicked && status.acc == .unClicked {
            return data.sorted { $0.acc_trade_price_24h > $1.acc_trade_price_24h }
        } else {
            switch status.price {
            case .unClicked: break
            case .upClicked:
                print("price - upClicked")
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
                print("acc - downClicked")
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
