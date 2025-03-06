//
//  TickerViewModel.swift
//  CryptoCollection
//
//  Created by 김태형 on 3/6/25.
//

import RxCocoa
import RxSwift

final class TickerViewModel: ViewModel {
    private let disposeBag = DisposeBag()

    struct Input {

    }

    struct Output {
        let data: Observable<[UpbitMarketResponse]>
    }

    func transform(input: Input) -> Output {
        let data = PublishRelay<[UpbitMarketResponse]>()
        let timer = Observable<Int>.interval(.seconds(5), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background))


        // TODO: 방법 고민해보기
        /*
         .timer 메서드로 구현하면 0초부터 시작은 하나 늦게 호출됨.
         처음은 전자의 식으로 호출 후 5초 뒤부턴 timer 식 호출
         */
        NetworkManager.shared.getItem(
            api: UpbitRouter.getMarket(),
            type: [UpbitMarketResponse].self)
        .subscribe(with: self) { owner, value in
            data.accept(value)
        } onFailure: { owner, error in
            print("failed", APIError.unknownError)
        } onDisposed: { owner in
            print("onDisposed")
        }
        .disposed(by: disposeBag)

        timer
            .subscribe(with: self) { owner, value in
                print("Timer:", value)
                NetworkManager.shared.getItem(
                    api: UpbitRouter.getMarket(),
                    type: [UpbitMarketResponse].self)
                .subscribe(with: self) { owner, value in
                    data.accept(value)
                } onFailure: { owner, error in
                    print("failed", error)
                } onDisposed: { owner in
                    print("onDisposed")
                }
                .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)

        return Output(data: data.asObservable())
    }

}
